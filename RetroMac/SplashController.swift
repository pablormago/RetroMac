//
//  SplashController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 12/01/2022.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa

var etiqueta = NSTextField()
class SplashController: NSViewController {
    
    var version = "2.1"
    @IBOutlet weak var botonFondo: NSButton!
    @IBOutlet weak var taskLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        etiqueta = taskLabel
        let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        let path2 =  rutaApp2 +  "/BOBwin.exe"
        let fileDoesExist = FileManager.default.fileExists(atPath: path2)
        print("Existe")
        var pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
        if fileDoesExist {
            esBoB = true
            let imagen = NSImage(contentsOf: pathLogo!)!
            botonFondo.image = imagen
        }else {
            esBoB = false
        }
        taskLabel.stringValue = "Iniciando…"
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        ///        self.view.layer?.cornerRadius = 20.0
        ///        self.view.window?.isOpaque = false
        ///        self.view.window?.titlebarAppearsTransparent = true
        ///self.view.window?.styleMask = [.borderless]
        self.view.window?.titleVisibility = .hidden
        self.view.window?.titlebarAppearsTransparent = true
        //self.view.window?.styleMask.insert(.fullSizeContentView)
        
        self.view.window?.styleMask.remove(.closable)
        
        ///self.view.window?.styleMask.remove(.fullScreen)
        //self.view.window?.styleMask.remove(.miniaturizable)
        //self.view.window?.styleMask.remove(.resizable)
    }
    
    override func viewDidAppear() {
        //        self.view.layer?.cornerRadius = 20.0
        //        self.view.window?.isOpaque = false
        //        self.view.window?.titlebarAppearsTransparent = true
        //        self.view.window?.titleVisibility = .hidden
        //        self.view.window?.titlebarAppearsTransparent = true
        //        DispatchQueue.main.sync {
        //
        //        }
        let defaults = UserDefaults.standard
        var switchestado = defaults.integer(forKey: "LocalMedia") ?? 0
        
        if switchestado == 0 {
            buscarLocal = false
        }else {
            buscarLocal = true
        }
        
        ///COMPROBAR QUE EXISTE CONFIG
        ///
        // Usamos la API de URL de FileManager y `.path` (NO `URL(string:)` + `.absoluteString`,
        // que fallaba/percent-encodeaba con espacios y generaba rutas mal formadas).
        let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("RetroMac")
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        var existeconfig = Bool()
        let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url2 = NSURL(fileURLWithPath: path2)
        if let pathComponent = url2.appendingPathComponent("/RetroMac/es_systems_mac.cfg") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            // Válido = existe, no vacío y parsea (contiene <system>). Un cfg de 0 bytes
            // o corrupto hacía que la app arrancara sin ningún sistema.
            if cfgEsValido(filePath) {
                existeconfig = true
                print("ESTÁ")

            } else {
                existeconfig = false
                print("NO ESTÁ (o vacío) — recopiando el cfg del bundle")
                do {
                    guard let sourcePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") else {
                        return
                    }
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let sourceUrl = URL(fileURLWithPath: sourcePath)
                    let destination = documentsDirectory.appendingPathComponent("RetroMac/es_systems_mac.cfg", isDirectory: false)
                    // Si existe pero está vacío/corrupto, lo borramos antes de copiar el bueno.
                    if fileManager.fileExists(atPath: destination.path) {
                        try? fileManager.removeItem(at: destination)
                    }
                    try fileManager.copyItem(at: sourceUrl, to: destination)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                }
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        var retroversion = String()
        var existeRetro = Bool()
        ///comprobar que EXISTE RETROMAC.TXT
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("/Retroarch/RetroMac.txt") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                existeRetro = true
                print("ESTÁ")
                // Lectura segura de la versión (antes crasheaba con preconditionFailure
                // si el fichero no se podía abrir). Si no se puede leer, queda "" y se
                // trata como cambio de versión.
                retroversion = (try? String(contentsOfFile: filePath, encoding: .utf8))?
                    .components(separatedBy: .newlines).first?
                    .trimmingCharacters(in: .whitespaces) ?? ""
                if retroversion == version {
                    existeRetro = true
                    
                }else {
                    existeRetro = false
                    // Cambio de versión: actualizamos RetroMac.txt, pero NO pisamos el cfg del
                    // usuario (contiene sus selecciones de core por sistema, escritas por
                    // escribeSistemas). Solo lo recopiamos del bundle si falta o no es válido.
                    let str = version
                    let filename = getDocumentsDirectory().appendingPathComponent("/Retroarch/RetroMac.txt")
                    try? str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)

                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destination = documentsDirectory.appendingPathComponent("RetroMac/es_systems_mac.cfg", isDirectory: false)
                    if !cfgEsValido(destination.path), let sourcePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") {
                        try? FileManager.default.removeItem(at: destination)
                        try? fileManager.copyItem(at: URL(fileURLWithPath: sourcePath), to: destination)
                    }
                }
            } else {
                existeRetro = false
                print("NO ESTÁ")
                let str = version
                let filename = getDocumentsDirectory().appendingPathComponent("/Retroarch/RetroMac.txt")
                
                do {
                    try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                }

            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        
        let Xemu = "/Users/Shared/Xemu"
        let myGroup = DispatchGroup()
        myGroup.enter()
        //// Do your task
        var isDir:ObjCBool = true
        let theProjectPath = Xemu
        if !FileManager.default.fileExists(atPath: theProjectPath, isDirectory: &isDir) || existeRetro == false {
            taskLabel.stringValue = "Generando la Base"
            copiarBase()
        } else {
            //print("Existe")
        }
        myGroup.leave() //// When your task completes
        myGroup.notify(queue: DispatchQueue.main) {
        }
        
        // MARK: Comprobar la Carpeta Emuladores_Mac
        
        
        DispatchQueue.background(background: {
            // Cada paso dice lo que está haciendo de verdad (antes había tramos largos
            // con la etiqueta congelada en el mensaje anterior).
            downloadEmulators()

            // La lista de MAME (1,3 MB) ya NO se carga aquí: solo la usan los scrapers,
            // así que se carga de forma perezosa (asegurarTitulosMame) la primera vez
            // que se necesita. Esto quita ~30.000 líneas de parseo en cada arranque.
            DispatchQueue.main.sync { etiqueta.stringValue = "Preparando datos de sistemas…" }
            llenaSistemasIds()

            DispatchQueue.main.sync { etiqueta.stringValue = "Leyendo configuración de RetroArch…" }
            readRetroArchConfig ()
            readCitraConfig ()

            DispatchQueue.main.sync { etiqueta.stringValue = "Leyendo shaders…" }
            shadersList ()

            // - MARK: cargar array de juegos-cores, juegos-shaders y systems-shaders, etc
            DispatchQueue.main.sync { etiqueta.stringValue = "Cargando preferencias…" }
            let defaults = UserDefaults.standard
            arrayGamesCores = (defaults.array(forKey: "juegosCores") as? [[String]]) ?? []
            arrayGamesShaders = (defaults.array(forKey: "juegosShaders")as? [[String]]) ?? []
            arraySystemsShaders = (defaults.array(forKey: "systemsShaders")as? [[String]]) ?? []
            arrayGamesBezels = (defaults.array(forKey: "juegosBezels")as? [[String]]) ?? []
            arraySystemsBezels = (defaults.array(forKey: "systemsBezels")as? [[String]]) ?? []

            DispatchQueue.main.sync { etiqueta.stringValue = "Buscando juegos…" }
            self.cuentaJuegosEnSistemas()
        }, completion:{
            // Feedback de error: si no se cargó ningún sistema, avisamos en vez de dejar
            // la app vacía sin explicación (antes fallaba en silencio).
            if allTheSystems.isEmpty {
                let alerta = NSAlert()
                alerta.messageText = "No se pudo cargar la configuración de sistemas"
                alerta.informativeText = "No se ha leído ningún sistema de:\n~/Documents/RetroMac/es_systems_mac.cfg\n\nRevisa que el fichero existe y no está vacío. La app se abrirá sin sistemas."
                alerta.alertStyle = .warning
                alerta.addButton(withTitle: "Continuar")
                alerta.runModal()
            }

            // Si algún core del cfg no se pudo descargar, se dice claramente (no se oculta):
            // casi siempre es un nombre mal escrito o renombrado en el cfg.
            if !coresNoDescargados.isEmpty {
                let aviso = NSAlert()
                aviso.messageText = "Algunos cores del cfg no se pudieron descargar"
                aviso.informativeText = "No están disponibles en el buildbot de libretro:\n\n"
                    + coresNoDescargados.sorted().joined(separator: ", ")
                    + "\n\nRevisa el nombre en es_systems_mac.cfg (suelen ser nombres antiguos o mal escritos)."
                aviso.alertStyle = .informational
                aviso.addButton(withTitle: "Continuar")
                aviso.runModal()
            }

            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
            }
        })
        
        
        
    }
    func cuentaJuegosEnSistemas()  {
        //print("ENTRO A CONTAR")
        let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url2 = NSURL(fileURLWithPath: path2)
        let pathComponent = url2.appendingPathComponent("/RetroMac/es_systems_mac.cfg")
        //let pathXMLinterno = Bundle.main.url(forResource: "es_systems_mac", withExtension: "cfg")
        var datosdelsitema = [[String]]()
        datosdelsitema = []
        tieneRoms = false
        juegosPorConsola = []
        var contador = Int()
        contador = 0
        if let pathComponent = pathComponent, let data = try? Data(contentsOf: pathComponent as URL)
            
        {
            let parser = BookParser(data: data)
            
            
            for book in parser.books
            {
                //print(book.name)
                let miSistema = book.name
                var extensionescuenta = String()
                extensionescuenta = book.extensiones
                let miPath = book.path
                let miCores = book.links
                var misCores = [[String]]()
                if let links = book.links {
                    for link in links
                    {
                        let miNombre = link.name
                        let miCore = link.core
                        let miComando = link.emucommand
                        let migrupo = [miNombre, miCore, miComando]
                        misCores.append(migrupo)
                    }
                } else {
                    //misCores.append([""])
                }
                
                
                
                let micomando = book.comando
                let minombre = book.fullname
                let miplataforma = book.platform
                let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
                let miruta = rutaApp2 + book.path /// Es lo mismo que ROMPATH
                ///
                ///DATOS DEL STRUCT SISTEMA:
                //                struct Sistema {
                //                let sistema: String
                //                let fullname: String
                //                let command: String
                //                let rompath: String
                //                let platform: String
                //                let extensions: String
                //                let theme: String
                //                let emuladores: [[String]]
                //
                //                }
                ///GUARDAR TODOS LOS SISTEMAS EN EL ARRAY allTheSystems
                ///
                let consolaRaw1: ConsolaRaw = ConsolaRaw(nombrecorto: book.name, nombrelargo: book.fullname, comando: book.comando, rompath: book.path, platform: book.platform, extensions: book.extensiones, theme: book.theme, emuladores: misCores)
                allTheSystems.append(consolaRaw1)
                
                ///Comprobar si hay gamelist.xml
                let fileDoesExist2 = FileManager.default.fileExists(atPath: miruta + "/gamelist.xml")
                if fileDoesExist2 {
                    ///Si existe, lo añadimos al array de sistemas
                    DispatchQueue.main.sync {
                        taskLabel.stringValue = "Cargando \(minombre)"
                    }
                    
                    let migrupo = [miSistema, String(contador) , extensionescuenta, micomando, minombre, miPath]
                    let sistema1: Consola = Consola(sistema: miSistema, fullname: minombre, command: micomando, rompath: miPath, platform: miplataforma, extensions: extensionescuenta, games: juegosGamelistCarga(sistema: migrupo), videos: arrayVideos, cores: misCores)
                    allTheGames.append(sistema1)
                    datosdelsitema.append(migrupo)
                    contador += 1
                    //print(datosdelsitema)
                    //print(datosdelsitema)
                    
                }else {
                    ///Si no existe hay que comprobar si hay juegos, y crear el xml en caso de que lo haya
                    var encuentra =  false
                    var isDir:ObjCBool = true
                    if FileManager.default.fileExists(atPath: miruta, isDirectory: &isDir) {
                        //para cada book.extensiones
                        var extensionescuenta = [String]()
                        extensionescuenta = book.extensiones.components(separatedBy: " ")
                        for extensiones in extensionescuenta {
                            
                            let fileManager = FileManager.default
                            let enumerator = fileManager.enumerator(atPath: miruta as String)
                            while let element = enumerator?.nextObject() as? String {
                                if element.hasSuffix(extensiones) { // checks the extension
                                    //print(element)
                                    encuentra = true
                                    break
                                }
                            }
                            if encuentra == true {
                                break
                            }else{
                                encuentra = false
                            }
                        }
                        
                        if encuentra == true {
                            ///Creamos el xml y añadimos el sistema al array porque ha encontrado ROMS
                            print("ROMS ENCONTRADAS")
                            extensionesTemp = extensionescuenta
                            //crearGameListInicioCarga(ruta: miruta)
                            var migrupo2 = [String]()
                            migrupo2 = [miSistema, String(contador) , book.extensiones, micomando, minombre, miPath]
                            let sistema1: Consola = Consola(sistema: miSistema, fullname: minombre, command: micomando, rompath: miPath, platform: miplataforma, extensions: book.extensiones, games: juegosGamelistCarga(sistema: migrupo2), videos: arrayVideos, cores: misCores)
                            allTheGames.append(sistema1)
                            DispatchQueue.main.sync {
                                taskLabel.stringValue = "Cargando \(minombre)"
                            }
                            
                            //sistemasTengo.append(book.name)
                        }else {
                            
                        }
                    }
                }
                
                
            }
        }
        let favoritosSystem: Consola = Consola(sistema: "fav", fullname: "Favoritos", command: "", rompath: "", platform: "", extensions: "", games: favoritos, videos: arrayVideosFav, cores: [])
        //allTheSystems.sort(by: {($0.nombrecorto ) < ($1.nombrecorto) })
        //escribeSistemas ()
        allTheGames.append(favoritosSystem)
        allTheSystems.sort(by: {($0.nombrelargo ) < ($1.nombrelargo) })
        allTheGames.sort(by: {($0.fullname ) < ($1.fullname) })
        
        for consola in allTheGames {
            print("Consola: \(consola.fullname) Juegos: \(consola.games.count)")
            
        }
        datosdelsitema.sort(by: {($0[0] ) < ($1[0] ) })
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}
