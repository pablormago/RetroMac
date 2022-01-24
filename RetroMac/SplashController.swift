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
        
        let pathXMLinterno = Bundle.main.url(forResource: "es_systems_mac", withExtension: "cfg")
        var datosdelsitema = [[String]]()
        datosdelsitema = []
        tieneRoms = false
        juegosPorConsola = []
        var contador = Int()
        contador = 0
        if let pathXMLinterno = pathXMLinterno, let data = try? Data(contentsOf: pathXMLinterno as URL)
            
        {
            let parser = BookParser(data: data)
            
            
            for book in parser.books
            {
                //print(book.name)
                let miSistema = book.name
                var extensionescuenta = String()
                extensionescuenta = book.extensiones
                let miPath = book.path
                let micomando = book.comando
                let minombre = book.fullname
                let miplataforma = book.platform
                let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
                let miruta = rutaApp2 + book.path /// Es lo mismo que ROMPATH
                ///Comprobar si ha gamelist.xml
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
                    let sistema1: Consola = Consola(sistema: miSistema, fullname: minombre, command: micomando, rompath: miPath, platform: miplataforma, extensions: extensionescuenta, games: juegosGamelistCarga(sistema: migrupo))
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
                                            var migrupo2 = [String]()
                                            migrupo2 = [miSistema, String(contador) , book.extensiones, micomando, minombre]
                                            let sistema1: Consola = Consola(sistema: miSistema, fullname: minombre, command: micomando, rompath: miPath, platform: miplataforma, extensions: book.extensiones, games: juegosGamelistCarga(sistema: migrupo2))
                                            allTheGames.append(sistema1)
                                            DispatchQueue.main.sync {
                                                taskLabel.stringValue = "Cargando \(minombre)"
                                            }
                                            crearGameListInicioCarga(ruta: miruta)
                                            //sistemasTengo.append(book.name)
                                        }else {
                    
                                        }
                }
                }
                
                
            }
        }
        let favoritosSystem: Consola = Consola(sistema: "fav", fullname: "Favoritos", command: "", rompath: "", platform: "", extensions: "", games: favoritos)
        
        allTheGames.append(favoritosSystem)
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
