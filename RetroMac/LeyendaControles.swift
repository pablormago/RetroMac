//
//  LeyendaControles.swift
//  RetroMac
//
//  Leyenda de controles de teclado y mando.
//
//  Se monta como una capa por encima de la pantalla actual (no vive en el
//  storyboard) por dos razones: no hay que tocar las tres escenas — Principal,
//  Lista y Grid —, y cuando llegue el rediseño de la interfaz se puede cambiar
//  o quitar tocando un solo archivo.
//
//  Lo que muestra es CONTEXTUAL: solo las teclas y botones que de verdad hacen
//  algo en la pantalla en la que estás. Las tablas de abajo están sacadas leyendo
//  los handlers reales:
//    - mando:    mainScreenGameController.swift (dpadArriba/…, botonA/…, hombros,
//                gatillos). El mando SDL2 llama a esas MISMAS funciones, así que
//                la leyenda vale para los dos tipos de mando.
//    - teclado:  OJO, está en DOS sitios. Una parte en los keyDown
//                (listScreenKeyboard.swift y GridScreen.keyDown) y otra —las teclas
//                de función y los cursores de la pantalla principal— en los
//                keyEquivalent de los botones del storyboard, que van dentro de
//                <string key="keyEquivalent"> del buttonCell, a veces en base64, y
//                con las Fn guardadas como caracteres Unicode invisibles (F1 es
//                U+F704). Buscar solo los keyDown da la impresión falsa de que la
//                pantalla principal no atiende al teclado.
//

import Cocoa

final class LeyendaControles {

    /// La capa que está puesta ahora mismo, si hay alguna.
    private static var capaVisible: NSView?

    static var estaVisible: Bool { capaVisible != nil }

    /// Una línea de la leyenda. Si `teclado` va vacío es que esa acción solo
    /// existe en el mando (y al revés).
    private struct Atajo {
        let teclado: String
        let mando: String
        let accion: String
    }

    // MARK: - Contenido

    private static func atajos(para pantalla: String) -> [Atajo] {
        switch pantalla {

        case "Principal":
            return [
                Atajo(teclado: "←  →",        mando: "←  →",  accion: "Cambiar de sistema"),
                Atajo(teclado: "Intro",       mando: "A",     accion: "Entrar en el sistema"),
                Atajo(teclado: "F5",          mando: "X",     accion: "Partidas en red (Netplay)"),
                Atajo(teclado: "F1",          mando: "L2",    accion: "Ajustes"),
                Atajo(teclado: "H",           mando: "R2",    accion: "Mostrar u ocultar esta ayuda"),
            ]

        case "Lista":
            return [
                Atajo(teclado: "↑  ↓",        mando: "↑  ↓",  accion: "Juego anterior / siguiente"),
                Atajo(teclado: "←  →",        mando: "",      accion: "Cambiar de sistema"),
                Atajo(teclado: "F7  F9",      mando: "L1  R1", accion: "Sistema anterior / siguiente"),
                Atajo(teclado: "Intro  ·  F8", mando: "A",    accion: "Lanzar el juego"),
                Atajo(teclado: "F12",         mando: "B",     accion: "Opciones del juego"),
                Atajo(teclado: "Esc  ·  ⌫",   mando: "Y",     accion: "Volver a la pantalla principal"),
                Atajo(teclado: "F5",          mando: "X",     accion: "Partidas en red (Netplay)"),
                Atajo(teclado: "F1",          mando: "L2",    accion: "Ajustes"),
                Atajo(teclado: "H",           mando: "R2",    accion: "Mostrar u ocultar esta ayuda"),
            ]

        case "Grid":
            return [
                Atajo(teclado: "",            mando: "←  →",  accion: "Juego anterior / siguiente"),
                Atajo(teclado: "",            mando: "↑  ↓",  accion: "Subir / bajar una fila"),
                Atajo(teclado: "F7  F9",      mando: "L1  R1", accion: "Sistema anterior / siguiente"),
                Atajo(teclado: "Intro  ·  F8", mando: "A",    accion: "Lanzar el juego o abrir la carpeta"),
                Atajo(teclado: "F12",         mando: "B",     accion: "Opciones del juego"),
                Atajo(teclado: "Esc  ·  ⌫",   mando: "Y",     accion: "Volver a la pantalla principal"),
                Atajo(teclado: "F5",          mando: "X",     accion: "Partidas en red (Netplay)"),
                Atajo(teclado: "F1",          mando: "L2",    accion: "Ajustes"),
                Atajo(teclado: "H",           mando: "R2",    accion: "Mostrar u ocultar esta ayuda"),
            ]

        default:
            return [
                Atajo(teclado: "H", mando: "R2", accion: "Mostrar u ocultar esta ayuda"),
            ]
        }
    }

    private static func titulo(para pantalla: String) -> String {
        switch pantalla {
        case "Principal": return "Controles · Sistemas"
        case "Lista":     return "Controles · Lista de juegos"
        case "Grid":      return "Controles · Cuadrícula"
        default:          return "Controles"
        }
    }

    // MARK: - Mostrar y ocultar

    /// Instante del último cambio, para el antirrebote de abajo.
    private static var ultimoCambio = Date.distantPast

    /// Abre la leyenda si está cerrada y la cierra si está abierta.
    /// Se llama desde el teclado (H) y desde el gatillo derecho del mando.
    ///
    /// Antirrebote: en la pantalla principal la misma pulsación puede llegar dos
    /// veces — una por el monitor local de eventos que se instala en
    /// ViewController.viewDidAppear y otra por la cadena de respondedores—, y dos
    /// alternar() seguidos dejarían la leyenda como estaba, es decir, sin abrirse.
    static func alternar() {
        guard Date().timeIntervalSince(ultimoCambio) > 0.2 else { return }
        ultimoCambio = Date()
        if estaVisible {
            ocultar()
        } else {
            mostrar()
        }
    }

    static func ocultar() {
        capaVisible?.removeFromSuperview()
        capaVisible = nil
    }

    static func mostrar() {
        // Con un modal delante (Ajustes, Netplay, Opciones) no pintamos nada:
        // la capa se montaría debajo y no se vería.
        guard ventanaModal == "Ninguna" else { return }
        guard let anfitriona = SingletonState.shared.currentViewController?.view else { return }
        ocultar()

        let capa = construirCapa(en: anfitriona.bounds, pantalla: ventana)
        capa.autoresizingMask = [.width, .height]
        anfitriona.addSubview(capa)
        capaVisible = capa
    }

    // MARK: - Construcción de la vista

    private static func construirCapa(en marco: NSRect, pantalla: String) -> NSView {
        let fondo = NSView(frame: marco)
        fondo.wantsLayer = true
        fondo.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.55).cgColor

        let lineas = atajos(para: pantalla)
        let tarjeta = construirTarjeta(titulo: titulo(para: pantalla), lineas: lineas)
        fondo.addSubview(tarjeta)

        tarjeta.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tarjeta.centerXAnchor.constraint(equalTo: fondo.centerXAnchor),
            tarjeta.centerYAnchor.constraint(equalTo: fondo.centerYAnchor),
        ])
        return fondo
    }

    private static func construirTarjeta(titulo: String, lineas: [Atajo]) -> NSView {
        let tarjeta = NSVisualEffectView()
        tarjeta.material = .hudWindow
        tarjeta.blendingMode = .withinWindow
        tarjeta.state = .active
        tarjeta.wantsLayer = true
        tarjeta.layer?.cornerRadius = 16
        tarjeta.layer?.borderWidth = 1
        tarjeta.layer?.borderColor = NSColor.white.withAlphaComponent(0.18).cgColor

        let pila = NSStackView()
        pila.orientation = .vertical
        pila.alignment = .leading
        pila.spacing = 10
        pila.translatesAutoresizingMaskIntoConstraints = false

        pila.addArrangedSubview(etiqueta(titulo, tamano: 22, peso: .semibold, color: .labelColor))

        // Cabecera de las dos columnas de teclas.
        pila.addArrangedSubview(filaCabecera())
        pila.addArrangedSubview(separador())

        for linea in lineas {
            pila.addArrangedSubview(filaDeAtajo(linea))
        }

        pila.addArrangedSubview(separador())
        pila.addArrangedSubview(etiqueta("El mando SDL2 y el mando nativo de Mac usan los mismos botones.",
                                         tamano: 11, peso: .regular, color: .secondaryLabelColor))

        tarjeta.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 28),
            pila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -28),
            pila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 24),
            pila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -24),
        ])
        return tarjeta
    }

    /// Anchos fijos para que las tres columnas queden alineadas en todas las filas.
    private static let anchoTeclado: CGFloat = 120
    private static let anchoMando: CGFloat = 90
    private static let anchoAccion: CGFloat = 320

    private static func filaCabecera() -> NSView {
        let fila = NSStackView()
        fila.orientation = .horizontal
        fila.spacing = 16
        fila.addArrangedSubview(columna(etiqueta("TECLADO", tamano: 10, peso: .semibold, color: .tertiaryLabelColor), ancho: anchoTeclado))
        fila.addArrangedSubview(columna(etiqueta("MANDO", tamano: 10, peso: .semibold, color: .tertiaryLabelColor), ancho: anchoMando))
        fila.addArrangedSubview(columna(etiqueta("", tamano: 10, peso: .regular, color: .tertiaryLabelColor), ancho: anchoAccion))
        return fila
    }

    private static func filaDeAtajo(_ atajo: Atajo) -> NSView {
        let fila = NSStackView()
        fila.orientation = .horizontal
        fila.alignment = .centerY
        fila.spacing = 16
        fila.addArrangedSubview(columna(tecla(atajo.teclado), ancho: anchoTeclado))
        fila.addArrangedSubview(columna(tecla(atajo.mando), ancho: anchoMando))
        fila.addArrangedSubview(columna(etiqueta(atajo.accion, tamano: 13, peso: .regular, color: .labelColor), ancho: anchoAccion))
        return fila
    }

    /// Dibuja una tecla o botón con aspecto de tecla. Vacío = un guion apagado,
    /// para que se vea de un vistazo que esa acción no está en ese mando/teclado.
    private static func tecla(_ texto: String) -> NSView {
        guard !texto.isEmpty else {
            return etiqueta("—", tamano: 13, peso: .regular, color: .quaternaryLabelColor)
        }
        let caja = NSView()
        caja.wantsLayer = true
        caja.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.12).cgColor
        caja.layer?.cornerRadius = 5
        caja.layer?.borderWidth = 1
        caja.layer?.borderColor = NSColor.white.withAlphaComponent(0.25).cgColor

        let rotulo = etiqueta(texto, tamano: 12, peso: .medium, color: .labelColor)
        rotulo.translatesAutoresizingMaskIntoConstraints = false
        caja.addSubview(rotulo)
        NSLayoutConstraint.activate([
            rotulo.leadingAnchor.constraint(equalTo: caja.leadingAnchor, constant: 8),
            rotulo.trailingAnchor.constraint(equalTo: caja.trailingAnchor, constant: -8),
            rotulo.topAnchor.constraint(equalTo: caja.topAnchor, constant: 3),
            rotulo.bottomAnchor.constraint(equalTo: caja.bottomAnchor, constant: -3),
        ])
        return caja
    }

    /// Mete una vista en una celda de ancho fijo, pegada a la izquierda.
    private static func columna(_ vista: NSView, ancho: CGFloat) -> NSView {
        let celda = NSView()
        vista.translatesAutoresizingMaskIntoConstraints = false
        celda.addSubview(vista)
        NSLayoutConstraint.activate([
            celda.widthAnchor.constraint(equalToConstant: ancho),
            vista.leadingAnchor.constraint(equalTo: celda.leadingAnchor),
            vista.trailingAnchor.constraint(lessThanOrEqualTo: celda.trailingAnchor),
            vista.topAnchor.constraint(equalTo: celda.topAnchor),
            vista.bottomAnchor.constraint(equalTo: celda.bottomAnchor),
        ])
        return celda
    }

    private static func separador() -> NSView {
        let linea = NSView()
        linea.wantsLayer = true
        linea.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.15).cgColor
        linea.translatesAutoresizingMaskIntoConstraints = false
        linea.heightAnchor.constraint(equalToConstant: 1).isActive = true
        linea.widthAnchor.constraint(equalToConstant: anchoTeclado + anchoMando + anchoAccion + 32).isActive = true
        return linea
    }

    private static func etiqueta(_ texto: String, tamano: CGFloat, peso: NSFont.Weight, color: NSColor) -> NSTextField {
        let campo = NSTextField(labelWithString: texto)
        campo.font = NSFont.systemFont(ofSize: tamano, weight: peso)
        campo.textColor = color
        campo.lineBreakMode = .byTruncatingTail
        return campo
    }
}
