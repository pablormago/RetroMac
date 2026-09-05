//
//  SDLControllerManager.swift
//  RetroMac
//
//  Añade soporte de mandos vía SDL2, como AÑADIDO al framework nativo
//  GameController — no lo sustituye. Sirve para mandos genéricos, antiguos o clones
//  que macOS no certifica (GameController.framework solo reconoce MFi/HID
//  estándar), aprovechando la base de datos de mapeados que trae SDL2
//  (gamecontrollerdb.txt, integrada en el propio binario).
//
//  Cómo evita coger dos veces el mismo mando físico (uno por GameController y el
//  mismo otra vez por SDL2): usa la API pública de Apple
//  `GCController.supportsHIDDevice(_:)` (macOS 11+) sobre los dispositivos HID reales
//  del sistema — es la misma técnica que usa el propio SDL2 en su otro backend
//  (`IOS_SupportedHIDDevice` en su código fuente, src/joystick/apple/SDL_mfijoystick.m)
//  para lo mismo. Aquí se hace por Vendor/Product ID en vez de por IOHIDDeviceRef
//  exacto (SDL2 no expone su IOHIDDeviceRef interno por API pública), así que dos
//  mandos IDÉNTICOS conectados a la vez podrían, en teoría, confundirse entre sí —
//  caso raro y aceptado, mejor que no tener ninguna comprobación.
//
//  SDL2 se inicializa SOLO con los subsistemas de joystick/gamecontroller — nada de
//  vídeo, audio ni bucle de eventos propio (SDL_PollEvent). Un timer a ~60Hz llama a
//  SDL_GameControllerUpdate() y compara con el estado del fotograma anterior para
//  detectar flancos de pulsación, igual que hace pressedChangedHandler de
//  GameController (que solo dispara en el cambio, no mientras se mantiene pulsado).
//

import Foundation
import GameController
import IOKit.hid

final class SDLControllerManager {

    static let shared = SDLControllerManager()

    private var iniciado = false
    private var timer: Timer?
    // Contenido de gamecontrollerdb.txt, para poder reaprovechar mapeados de otras
    // plataformas (ver adaptarMapeadoDeOtraPlataforma).
    private var textoBaseDeMapeados: String?
    // Índices a los que ya se ha intentado adaptar un mapeado, para no reintentarlo
    // 60 veces por segundo si no hay ninguno aprovechable.
    private var intentadoAdaptarMapeado = Set<Int32>()

    // Un SDL_GameController* por índice de joystick que SDL2 ha abierto.
    private var mandosAbiertos: [Int32: OpaquePointer] = [:]
    // Estado del botón en el fotograma anterior, por índice + botón, para detectar
    // el flanco de "se acaba de pulsar" (no repetir mientras se mantiene).
    private var estadoAnterior: [Int32: [SDL_GameControllerButton: Bool]] = [:]

    private let botonesDigitales: [SDL_GameControllerButton] = [
        SDL_CONTROLLER_BUTTON_DPAD_UP, SDL_CONTROLLER_BUTTON_DPAD_DOWN,
        SDL_CONTROLLER_BUTTON_DPAD_LEFT, SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
        SDL_CONTROLLER_BUTTON_A, SDL_CONTROLLER_BUTTON_B,
        SDL_CONTROLLER_BUTTON_X, SDL_CONTROLLER_BUTTON_Y,
        SDL_CONTROLLER_BUTTON_LEFTSHOULDER, SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
    ]

    // Umbral de "pulsado" para los gatillos analógicos (0...32767 en SDL2).
    private let umbralGatillo: Int16 = 8000

    private init() {}

    /// Se llama una sola vez desde `AppDelegate.applicationDidFinishLaunching`.
    /// No recibe el ViewController: la instancia sobre la que se llaman las funciones
    /// de navegación (`dpadArriba()`, `botonA()`, etc. de mainScreenGameController.swift)
    /// se resuelve en el momento de despachar, desde el global `mainController` — así
    /// el arranque de SDL2 no depende del ciclo de vida de ninguna pantalla.
    func iniciar() {
        print("SDLControllerManager: iniciar() llamado")
        guard !iniciado else { return }
        iniciado = true

        if SDL_Init(UInt32(SDL_INIT_JOYSTICK) | UInt32(SDL_INIT_GAMECONTROLLER)) != 0 {
            print("SDLControllerManager: SDL_Init falló: \(String(cString: SDL_GetError()))")
            iniciado = false
            return
        }
        print("SDLControllerManager: SDL2 inicializado (solo joystick+gamecontroller). Version: \(Self.versionSDL())")
        cargarBaseDeMapeados()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.actualizar()
        }
    }

    /// Carga `gamecontrollerdb.txt` (base de mapeados comunitaria, la misma que usan
    /// RetroArch y compañía) desde los recursos de la app. Sin esto SDL2 solo conoce
    /// los mandos que trae de serie, y cualquier mando genérico/clon queda como
    /// "joystick sin mapeado" — que es justo lo que pasaba con el USB de pruebas.
    private func cargarBaseDeMapeados() {
        guard let ruta = Bundle.main.path(forResource: "gamecontrollerdb", ofType: "txt") else {
            print("SDLControllerManager: no encuentro gamecontrollerdb.txt en el bundle")
            return
        }
        // SDL_GameControllerAddMappingsFromFile es una macro de C (Swift no importa
        // macros con parámetros), así que se expande a mano tal cual la define
        // SDL_gamecontroller.h.
        let añadidos = SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(ruta, "rb"), 1)
        if añadidos < 0 {
            print("SDLControllerManager: fallo cargando gamecontrollerdb.txt: \(String(cString: SDL_GetError()))")
        } else {
            print("SDLControllerManager: gamecontrollerdb.txt cargado, \(añadidos) mapeados añadidos")
            textoBaseDeMapeados = try? String(contentsOfFile: ruta, encoding: .utf8)
        }
    }

    private static func versionSDL() -> String {
        var v = SDL_version()
        SDL_GetVersion(&v)
        return "\(v.major).\(v.minor).\(v.patch)"
    }

    func detener() {
        timer?.invalidate()
        timer = nil
        for (_, mando) in mandosAbiertos { SDL_GameControllerClose(mando) }
        mandosAbiertos.removeAll()
        estadoAnterior.removeAll()
        if iniciado { SDL_Quit() }
        iniciado = false
    }

    private func actualizar() {
        SDL_GameControllerUpdate()
        abrirMandosNuevos()
        cerrarMandosDesconectados()
        leerBotones()
    }

    // MARK: - Detección de mandos nuevos, evitando los que ya tiene GameController

    // Para no repetir el mismo log 60 veces por segundo: se recuerda qué índices ya
    // se han diagnosticado (se abrieran o no como game controller) y solo se vuelve
    // a loguear si el número total de joysticks cambia (mando nuevo, o el mismo
    // desconectado y reconectado).
    private var ultimoTotalJoysticks: Int32 = -1

    private func abrirMandosNuevos() {
        let total = SDL_NumJoysticks()
        if total != ultimoTotalJoysticks {
            print("SDLControllerManager: SDL_NumJoysticks() = \(total) (antes: \(ultimoTotalJoysticks))")
            ultimoTotalJoysticks = total
        }
        guard total > 0 else { return }
        // Se calcula una sola vez por pasada (no por mando) — es una operación de
        // IOKit, más cara que leer el estado de un botón.
        var vidPidDeGameController: Set<UInt32>?

        for indice in 0..<total {
            guard mandosAbiertos[indice] == nil else { continue }

            let nombreJoystick = SDL_JoystickNameForIndex(indice).map { String(cString: $0) } ?? "?"
            let vid = SDL_JoystickGetDeviceVendor(indice)
            let pid = SDL_JoystickGetDeviceProduct(indice)

            // Si no hay mapeado para macOS, se intenta reaprovechar el de otra
            // plataforma para el mismo mando físico (ver la función).
            if SDL_IsGameController(indice) != SDL_TRUE, !intentadoAdaptarMapeado.contains(indice) {
                intentadoAdaptarMapeado.insert(indice)
                adaptarMapeadoDeOtraPlataforma(indice: indice, nombre: nombreJoystick)
            }

            guard SDL_IsGameController(indice) == SDL_TRUE else {
                // Este es probablemente el caso real: SDL2 VE el mando a nivel HID,
                // pero no tiene un mapeado de botones (gamecontrollerdb) para su
                // VID/PID — con la API de "joystick" a secas SÍ se podría leer, pero
                // sin saber qué botón físico es cada cual. Se deja constancia clara
                // en vez de descartarlo en silencio, que es lo que hacía antes.
                print("""
                    SDLControllerManager: índice \(indice) («\(nombreJoystick)», \
                    vid=0x\(String(vid, radix: 16)) pid=0x\(String(pid, radix: 16))) \
                    es un joystick para SDL2 pero SDL_IsGameController = false — no tiene \
                    mapeado de botones conocido (gamecontrollerdb), se ignora.
                    """)
                continue
            }

            if vidPidDeGameController == nil {
                vidPidDeGameController = Self.vidPidYaSoportadosPorGameController()
                print("SDLControllerManager: dispositivos HID que GameController.framework ya soporta (vid<<16|pid): \(vidPidDeGameController!.map { String($0, radix: 16) })")
            }
            if vidPidDeGameController!.contains(Self.clave(vid: vid, pid: pid)) {
                print("SDLControllerManager: índice \(indice) («\(nombreJoystick)») ya lo tiene GameController.framework — SDL2 no lo abre.")
                continue
            }

            guard let mando = SDL_GameControllerOpen(indice) else {
                print("SDLControllerManager: SDL_GameControllerOpen falló para índice \(indice): \(String(cString: SDL_GetError()))")
                continue
            }
            mandosAbiertos[indice] = mando
            estadoAnterior[indice] = [:]
            let nombre = SDL_GameControllerName(mando).map { String(cString: $0) } ?? "?"
            print("SDLControllerManager: mando abierto por SDL2 (GameController no lo soporta): \(nombre)")
        }
    }

    /// Muchos mandos genéricos están en gamecontrollerdb.txt SOLO con
    /// `platform:Windows` o `platform:Linux` — y SDL2 ignora los mapeados de otras
    /// plataformas, así que en macOS se quedan sin mapear aunque el fichero los
    /// tenga (comprobado con un «USB gamepad» vid=0x081f pid=0xe401: está para
    /// Windows y Linux, no para Mac). Como el reparto de botones de un mando USB no
    /// cambia según el sistema operativo, aquí se busca una entrada con el MISMO
    /// vendor+product y se vuelve a registrar con el GUID real de este Mac y
    /// `platform:Mac OS X`.
    ///
    /// El GUID de SDL2 son 16 bytes en hex: bus(0-3) crc(4-7) vendor(8-15)
    /// product(16-23) versión(24-31) — se comparan solo vendor+product, que es lo que
    /// identifica el modelo de mando; crc (depende del nombre) y versión (firmware)
    /// pueden variar entre plataformas para el mismo aparato.
    private func adaptarMapeadoDeOtraPlataforma(indice: Int32, nombre: String) {
        guard let base = textoBaseDeMapeados else { return }

        let guid = SDL_JoystickGetDeviceGUID(indice)
        var buffer = [CChar](repeating: 0, count: 64)
        SDL_JoystickGetGUIDString(guid, &buffer, 64)
        let guidPropio = String(cString: buffer)
        guard guidPropio.count >= 24 else { return }

        let inicio = guidPropio.index(guidPropio.startIndex, offsetBy: 8)
        let fin = guidPropio.index(guidPropio.startIndex, offsetBy: 24)
        let vendorProducto = String(guidPropio[inicio..<fin])

        for linea in base.split(separator: "\n") {
            guard !linea.hasPrefix("#"), linea.count > 24 else { continue }
            let campos = linea.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
            guard campos.count == 2, campos[0].count >= 24 else { continue }
            let guidOtro = String(campos[0])
            let i = guidOtro.index(guidOtro.startIndex, offsetBy: 8)
            let f = guidOtro.index(guidOtro.startIndex, offsetBy: 24)
            guard String(guidOtro[i..<f]) == vendorProducto else { continue }

            // Se reescribe con NUESTRO guid y plataforma macOS, conservando el reparto
            // de botones tal cual venía.
            let resto = String(campos[1])
                .replacingOccurrences(of: "platform:Windows,", with: "")
                .replacingOccurrences(of: "platform:Linux,", with: "")
                .replacingOccurrences(of: "platform:Android,", with: "")
            let adaptado = "\(guidPropio),\(resto)platform:Mac OS X,"
            if SDL_GameControllerAddMapping(adaptado) >= 0 {
                print("SDLControllerManager: «\(nombre)» no tenía mapeado para macOS; reaprovechado el de otra plataforma del mismo modelo (vendor+product \(vendorProducto)).")
                return
            }
        }
        print("SDLControllerManager: «\(nombre)» no tiene mapeado en gamecontrollerdb para ninguna plataforma — no se puede usar por SDL2 sin configurarlo a mano.")
    }

    private func cerrarMandosDesconectados() {
        for (indice, mando) in mandosAbiertos where SDL_GameControllerGetAttached(mando) == SDL_FALSE {
            SDL_GameControllerClose(mando)
            mandosAbiertos.removeValue(forKey: indice)
            estadoAnterior.removeValue(forKey: indice)
        }
    }

    // MARK: - Lectura de botones y despacho a las mismas funciones que GameController

    private func leerBotones() {
        guard !mandosAbiertos.isEmpty else { return }
        // `mainController` es el global que ViewController.viewDidLoad rellena con su
        // propia instancia; se resuelve aquí y no al arrancar porque SDL2 puede estar
        // listo antes de que exista la pantalla principal.
        guard let controlador = mainController as? ViewController else {
            print("SDLControllerManager: hay mando abierto pero mainController aún no es un ViewController — se ignora la pulsación")
            return
        }
        for (indice, mando) in mandosAbiertos {
            for boton in botonesDigitales {
                let pulsadoAhora = SDL_GameControllerGetButton(mando, boton) != 0
                let pulsadoAntes = estadoAnterior[indice]?[boton] ?? false
                estadoAnterior[indice]?[boton] = pulsadoAhora
                guard pulsadoAhora && !pulsadoAntes else { continue } // solo el flanco de "se acaba de pulsar"
                despachar(boton: boton, en: controlador)
            }
            // Los gatillos son ejes analógicos en SDL2, no botones digitales.
            comprobarGatillo(mando: mando, indice: indice, eje: SDL_CONTROLLER_AXIS_TRIGGERLEFT,
                              claveEstado: -1, controlador: controlador) { $0.gatilloIzquierdo() }
            comprobarGatillo(mando: mando, indice: indice, eje: SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
                              claveEstado: -2, controlador: controlador) { $0.gatilloDerecho() }
        }
    }

    private func despachar(boton: SDL_GameControllerButton, en controlador: ViewController) {
        switch boton {
        case SDL_CONTROLLER_BUTTON_DPAD_UP: controlador.dpadArriba()
        case SDL_CONTROLLER_BUTTON_DPAD_DOWN: controlador.dpadAbajo()
        case SDL_CONTROLLER_BUTTON_DPAD_LEFT: controlador.dpadIzquierda()
        case SDL_CONTROLLER_BUTTON_DPAD_RIGHT: controlador.dpadDerecha()
        case SDL_CONTROLLER_BUTTON_A: controlador.botonA()
        case SDL_CONTROLLER_BUTTON_B: controlador.botonB()
        case SDL_CONTROLLER_BUTTON_X: controlador.botonX()
        case SDL_CONTROLLER_BUTTON_Y: controlador.botonY()
        case SDL_CONTROLLER_BUTTON_LEFTSHOULDER: controlador.hombroIzquierdo()
        case SDL_CONTROLLER_BUTTON_RIGHTSHOULDER: controlador.hombroDerecho()
        default: break
        }
    }

    // Los gatillos comparten el mismo diccionario `estadoAnterior` que los botones
    // digitales usando dos claves de botón que SDL2 nunca genera de verdad (-1/-2),
    // simplemente para reutilizar el mismo mecanismo de flanco sin otro diccionario.
    private func comprobarGatillo(mando: OpaquePointer, indice: Int32, eje: SDL_GameControllerAxis,
                                   claveEstado: Int32, controlador: ViewController,
                                   accion: (ViewController) -> Void) {
        let claveBoton = SDL_GameControllerButton(rawValue: claveEstado)
        let valor = SDL_GameControllerGetAxis(mando, eje)
        let pulsadoAhora = valor > umbralGatillo
        let pulsadoAntes = estadoAnterior[indice]?[claveBoton] ?? false
        estadoAnterior[indice]?[claveBoton] = pulsadoAhora
        guard pulsadoAhora && !pulsadoAntes else { return }
        accion(controlador)
    }

    // MARK: - Deduplicación con GameController.framework

    private static func clave(vid: UInt16, pid: UInt16) -> UInt32 {
        (UInt32(vid) << 16) | UInt32(pid)
    }

    /// Recorre TODOS los dispositivos HID del sistema y devuelve el VendorID+ProductID
    /// de los que `GameController.framework` ya sabe manejar — para que SDL2 no abra
    /// esos mismos. `supportsHIDDevice` es la API pública de Apple para esto (macOS
    /// 11+); en macOS más antiguo no hay forma pública de preguntarlo, así que se
    /// asume que no hay ninguno reservado (SDL2 podría entonces duplicar algún mando
    /// en esas versiones — limitación conocida, no hay alternativa pública).
    private static func vidPidYaSoportadosPorGameController() -> Set<UInt32> {
        guard #available(macOS 11.0, *) else { return [] }
        guard let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0) as IOHIDManager? else {
            return []
        }
        IOHIDManagerSetDeviceMatching(manager, nil)
        IOHIDManagerOpen(manager, 0)
        defer { IOHIDManagerClose(manager, 0) }
        guard let dispositivos = IOHIDManagerCopyDevices(manager) as? Set<IOHIDDevice> else { return [] }

        var resultado = Set<UInt32>()
        for dispositivo in dispositivos {
            guard GCController.supportsHIDDevice(dispositivo) else { continue }
            guard let vid = IOHIDDeviceGetProperty(dispositivo, kIOHIDVendorIDKey as CFString) as? Int,
                  let pid = IOHIDDeviceGetProperty(dispositivo, kIOHIDProductIDKey as CFString) as? Int
            else { continue }
            resultado.insert(clave(vid: UInt16(truncatingIfNeeded: vid), pid: UInt16(truncatingIfNeeded: pid)))
        }
        return resultado
    }
}
