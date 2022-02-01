//
//  SplashController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 12/01/2022.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa

class SplashController: NSViewController {

    
    @IBOutlet weak var botonFondo: NSButton!
    @IBOutlet weak var taskLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                    //try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
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
                
            } else {
               existeRetro = false
                print("NO ESTÁ")
                let str = "1.3"
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
                    
                    let migrupo = [miSistema, String(contador) , extensionescuenta, micomando, minombre]
                    
                    /// MARK - Datos de la Struct:
                    //                struct Consola {
                    //                    let sistema: String
                    //                    let fullname: String
                    //                    let command: String
                    //                    let rompath: String
                    //                    let platform: String
                    //                    let extensions: String
                    //                    let games: [Juego]
                    //                }
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
                                            crearGameListInicioCarga(ruta: miruta)
                                            var migrupo2 = [String]()
                                            migrupo2 = [miSistema, String(contador) , book.extensiones, micomando, minombre]
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
