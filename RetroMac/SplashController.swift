//
//  SplashController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 12/01/2022.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa

class SplashController: NSViewController {
    
    var version = "2.1"
    @IBOutlet weak var botonFondo: NSButton!
    @IBOutlet weak var taskLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        taskLabel.stringValue = "Cargando Sistemas"
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
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("RetroMac")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
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
            if fileManager.fileExists(atPath: filePath) {
                existeconfig = true
                print("ESTÁ")
                
            } else {
                existeconfig = false
                print("NO ESTÁ")
                do {
                    guard let sourcePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") else {
                        return
                    }
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let sourceUrl = URL(fileURLWithPath: sourcePath)
                    let destination = documentsDirectory.appendingPathComponent("RetroMac/es_systems_mac.cfg", isDirectory: false)
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
                guard FileManager.default.fileExists(atPath: (filePath)) else {
                    preconditionFailure("file expected at \(filePath) is missing")
                }
                
                // open the file for reading
                // note: user should be prompted the first time to allow reading from this location
                guard let filePointer:UnsafeMutablePointer<FILE> = fopen(filePath,"r") else {
                    preconditionFailure("Could not open file at \(filePath)")
                }
                
                // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
                var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
                
                // see the official Swift documentation for more information on the `defer` statement
                // https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_defer-statement
                defer {
                    // remember to close the file when done
                    fclose(filePointer)
                    
                    // The buffer should be freed by even if getline() failed.
                    lineByteArrayPointer?.deallocate()
                }
                
                // the smallest multiple of 16 that will fit the byte array for this line
                var lineCap: Int = 0
                
                // initial iteration
                var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
                
                
                while (bytesRead > 0) {
                    
                    // note: this translates the sequence of bytes to a string using UTF-8 interpretation
                    let lineAsString = String.init(cString:lineByteArrayPointer!)
                    retroversion = lineAsString
                    break
                }
                if retroversion == version {
                    existeRetro = true
                    
                }else {
                    existeRetro = false
                    let str = version
                    let filename = getDocumentsDirectory().appendingPathComponent("/Retroarch/RetroMac.txt")
                    
                    do {
                        try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    }
                    do {
                        guard let sourcePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") else {
                            return
                        }
                        
                        //try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let sourceUrl = URL(fileURLWithPath: sourcePath)
                        let destination = documentsDirectory.appendingPathComponent("RetroMac/es_systems_mac.cfg", isDirectory: false)
                        try FileManager.default.removeItem(at: destination)
                        try fileManager.copyItem(at: sourceUrl, to: destination)
                    } catch {
                        print("ERROR")
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
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
//                do {
//                    guard let sourcePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") else {
//                        return
//                    }
//
//                    //try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
//                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let sourceUrl = URL(fileURLWithPath: sourcePath)
//                    let destination = documentsDirectory.appendingPathComponent("RetroMac/es_systems_mac.cfg", isDirectory: false)
//                    try fileManager.copyItem(at: sourceUrl, to: destination)
//                } catch {
//                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//                }
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        
        let Xemu = "/users/Shared/Xemu"
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
        
        
        DispatchQueue.background(background: {
            
            titulosMame = mamelista() as! [[String]]
            llenaSistemasIds()
            readRetroArchConfig ()
            readCitraConfig ()
            shadersList ()
            // - MARK: cargar array de juegos-cores, juegos-shaders y systems-shaders, etc
            
            let defaults = UserDefaults.standard
            arrayGamesCores = (defaults.array(forKey: "juegosCores") as? [[String]]) ?? []
            arrayGamesShaders = (defaults.array(forKey: "juegosShaders")as? [[String]]) ?? []
            arraySystemsShaders = (defaults.array(forKey: "systemsShaders")as? [[String]]) ?? []
            arrayGamesBezels = (defaults.array(forKey: "juegosBezels")as? [[String]]) ?? []
            arraySystemsBezels = (defaults.array(forKey: "systemsBezels")as? [[String]]) ?? []
            self.cuentaJuegosEnSistemas()
        }, completion:{
            
            
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
                            let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: miruta as String)!
                            while let element = enumerator.nextObject() as? String {
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
