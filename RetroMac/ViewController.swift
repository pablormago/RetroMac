//
//  ViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 01/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//


import Cocoa
import Commands
import AVKit
import AVFoundation
import GameController

var rutaApp = ""
var rompath = ""
var systemextensions  = [String]()
var comandoaejecutar = ""
var ventana = ""
var botonactual = Int()
var cuentaboton = Int()
var abiertaLista = false
var anchura = Float()
var altura = Float()
var tieneRoms = false
var sistemasTengo = [String]()
var cuenta = CGFloat()
var sistemaActual = String()
var ancho = CGFloat()
var alto = CGFloat()
var cuantosSistemas = 0
var JuegosTotales = [[[String]]]()
var userDev = "pablormago"
var userpass = "YEb7khyiOvI"
var app = "RetroMac"
var systemsIds = [[String]]()
var nombresistemaactual = String()
var abiertaHome = true
var titulosMame = [[String]]()
var juegosPorConsola = [[String]]()
var juegosXml2 = [[String]]()
var allTheGames: [Consola] = []
var extensionesTemp = [String]()
var cuentaPrincipio = 0
var favoritos: [Juego] = []
var arrayVideos = [String]()
var arrayVideosFav = [String]()
var backIsPlaying = false
var allTheSystems: [ConsolaRaw] = []
var arrayGamesCores = [[String]]()
var buscarLocal = Bool()
var juegosaEscrapear = Double()

class ViewController: NSViewController {
    var sistema = ""
    var comandoexe = ""
    var anchuraPantall = 0
    
    
    var keyIsDown = false
    var cuentaDec = CGFloat()
    override var acceptsFirstResponder: Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    
    @IBOutlet weak var scrollerText: ScrollingTextView!
    @IBOutlet weak var mainBackImage: NSImageView!
    @IBOutlet weak var tog1: NSSwitch!
    @IBOutlet weak var onOff: NSTextField!
    @IBOutlet weak var settingsButton: NSButton!
    
    @IBOutlet weak var backPlayer: AVPlayerView!
    @IBOutlet weak var sistemaLabel: NSTextField!
    @IBOutlet weak var rutaRomsLabel: NSTextField!
    @IBOutlet weak var scrollMain: NSScrollView!
    @IBOutlet weak var myImage: NSImageView!
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
            as! NSViewController
    }()
    
    @IBAction func openSettings(_ sender: NSButton)  {
        self.presentAsModalWindow(sheetViewController)
        //self.presentAsModalWindow(sheetViewController)
    }
    
    
    @IBAction func switchToggle(_ sender: NSSwitch) {
        
        let state = sender.state
        if state.rawValue == 1 {
            onOff.stringValue = "SALIR"
        }
        else {
            onOff.stringValue = "SALIR"
            //Cerrar App
            NSApplication.shared.terminate(self)
        }
    }
    
    
    
    
    
    
    override func viewDidAppear() {
        
        scrollMain.isHidden = true
        let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        let path2 =  rutaApp2 +  "/BOBwin.exe"
        let fileDoesExist = FileManager.default.fileExists(atPath: path2)
        print("Existe")
        var pathLogo = Bundle.main.url(forResource: "logo_retro", withExtension: "jpeg")
        if fileDoesExist {
            pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
        }else {
            pathLogo = Bundle.main.url(forResource: "logo_retro", withExtension: "jpeg")
        }
        //let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
        //let pathLogo = Bundle.main.url(forResource: "logo_retro", withExtension: "jpeg")
        let imagen = NSImage(contentsOf: pathLogo!)!
        myImage.image = imagen
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (aEvent) -> NSEvent? in
            self.keyUp(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
        
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        
        print("DID APPEAR")
        
        
        if let screen = NSScreen.main {
            let rect = screen.frame
            let width = rect.size.width
            let mitadPantalla = Int (width / 2)
            anchuraPantall = Int(width)
            
            if abiertaLista == false {
                
                scrollMain.isHidden = false
                
            }else {
                
                
                let trozoamover = (560 * botonactual) - 280
                let cachito = trozoamover - mitadPantalla
                //print(botonactual)
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }
            
        }
        
        ///TECLAS
        cuentaDec = CGFloat(botonactual)
        self.view.window?.makeFirstResponder(self.scrollMain)
        scrollMain.wantsLayer = true
        scrollMain.layer?.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        
       // - MARK: Controllers
        
        var controllers = GCController.controllers()
        if controllers.count != 0 {
            let myController = controllers[0] as GCController
            myController.playerIndex = .index1
            if myController.extendedGamepad != nil {
                NSLog("Gamepad conectado")
            }
        }else {
            NSLog("No hay Gamepads conectados")
        }
       
    }
    // - MARK: fin de DidAppear
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ventana = "Principal"
        print("DID LOAD")
        cuenta = 0
        //        titulosMame = mamelista() as! [[String]]
        //        llenaSistemasIds()
        
        //        if cuentaPrincipio == 0 {
        //            cuentaJuegosEnSistemas()
        //        }
        
        
        //view.window?.isOpaque = false
        //view.window?.backgroundColor = NSColor (red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
        
        rutaApp = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        //print(rutaApp)
        onOff.stringValue = "SALIR"
        var totalSistemas = 0
        totalSistemas = cuentaSistemas()
        print(cuentaSistemas())
        let totalAnchuraMenu = ((totalSistemas+1) * 560)
        //Parsear Sistemas
        scrollMain.layer?.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        ///Carga desde allTheGames
        var counter = 0
        let documentView = NSView(frame: NSRect(x: 0,y: 0,width: totalAnchuraMenu,height: 178))
        for consola in allTheGames {
            
            let offset = CGFloat(counter * 560)
            let button = ButtonConsolas(frame: NSRect(x: offset, y: 0, width: 560, height: 178 ))
            button.tag = counter+1
            button.title = consola.sistema
            let home = Bundle.main.bundlePath
            let imagen2 = NSImage(byReferencingFile: home +  "/Contents/Resources/themes/default/logos/" + consola.sistema + ".png")!
            button.imageScaling = .scaleProportionallyDown
            let path =  home +  "/Contents/Resources/themes/default/logos/" + consola.sistema + ".png"
            let fileDoesExist = FileManager.default.fileExists(atPath: path)
            if fileDoesExist {
                button.image = imagen2
            }
            button.Sistema = consola.sistema
            button.Comando = consola.command
            button.RomsPath = consola.rompath
            button.Extensiones = consola.extensions
            button.Platform = consola.platform
            //button.Theme = book.theme
            button.Fullname = consola.fullname
            button.numeroJuegos = String(consola.games.count)
            button.videos = consola.videos
            button.cores = consola.cores
            button.target = self
            button.action = #selector(ViewController.selecionSistema)
            button.isBordered = false
            documentView.addSubview(button)
            counter += 1
        }
        cuantosSistemas = counter
        ventana = "Principal"
        scrollMain.documentView = documentView
        ///Fin carga desde allTheGames
        if let screen = NSScreen.main {
            
            let rect = screen.frame
            let width = rect.size.width
            let height = rect.size.height
            ancho = width
            alto = height
            let mitadPantalla = Int (width / 2)
            let cuantos = Int (width / 560)
            let trozoamover = (560 * cuantos) - 280
            let cachito = trozoamover - mitadPantalla
            anchuraPantall = Int(width)
            cuentaboton = (Int (anchuraPantall / 560))
            print("EL BOTON")
            print(cuentaboton)
            //print(scrollMain.contentView.bounds.origin.x)
            if abiertaLista == false {
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
                botonactual = cuentaboton
                backplay (tag: botonactual)
                
            }else {
                cuentaboton = botonactual
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
                backplay (tag: cuentaboton)
            }
            
        }
        cuentaDec = CGFloat(botonactual)
        //cargar array de juegos-cores
        let defaults = UserDefaults.standard
        arrayGamesCores = (defaults.array(forKey: "juegosCores") as? [[String]]) ?? []
        
        
        
        
        self.view.window?.makeFirstResponder(self.scrollMain)
        
    }
    
    
    //TECLAS
    override func keyDown(with event: NSEvent) {
        if keyIsDown == true {
            return
        }
        
        if abiertaLista == false {
            
            if event.keyCode == 36  {
                if ventana == "Principal" {
                    //print("SPACEBAR" 49)
                    let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
                    //print(sistemaActual)
                    if Int(button!.numeroJuegos!)! > 0 {
                        selecionSistema(button!)
                    }
                    
                }
                
                
            }
            else if event.keyCode == 124  {
                
                
                if botonactual < cuantosSistemas {
                    botonactual += 1
                    
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        
                        
                        //print("Derecho Mover")
                        cuentaboton = botonactual
                        let trozoamover = (560 * botonactual) - 280
                        let cachito = trozoamover - mitadPantalla
                        //print(botonactual)
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        scrollMain.isHidden = false
                        print ("CUENTABOTON: \(cuentaboton)")
                        print ("BOTONACTUAL: \(botonactual)")
                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        
                        backplay (tag: botonactual)
                    }
                }
                
                
                
            }
            else if event.keyCode == 123 {
                //print ("CURSOR IZQUIERDO")
                
                if botonactual > 1 {
                    botonactual -= 1
                    
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        cuentaboton = botonactual
                        let trozoamover = (560 * botonactual) - 280
                        let cachito = trozoamover - mitadPantalla
                        //print(botonactual)
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        scrollMain.isHidden = false
                        print ("CUENTABOTON: \(cuentaboton)")
                        print ("BOTONACTUAL: \(botonactual)")
                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        
                        backplay (tag: botonactual)
                    }
                    
                }
                
            }
            
        }
        else if abiertaLista == true {
            
            
            if event.keyCode == 36  {
                if ventana == "Principal" {
                    //print("SPACEBAR" 49)
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
                    //print(sistemaActual)
                    if Int(button!.numeroJuegos!)! > 0 {
                        selecionSistema(button!)
                    }
                    
                }
                
                
                
            }
            else if event.keyCode == 124  {
                //print ("CURSOR DERECHO")
                if Int(cuentaDec) < cuantosSistemas {
                    cuentaDec += 1
                    //print(cuentaDec)
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        
                        
                        //print("entro")
                        cuentaboton = botonactual
                        let trozoamover = (560 * Int(cuentaDec)) - 280
                        let cachito = trozoamover - mitadPantalla
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        //                            let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                        //                            sistemaLabel.stringValue = button!.numeroJuegos! + " juegos"
                        let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        backplay (tag: Int(cuentaDec))
                        
                        
                    }
                }
                
                
            }
            else if event.keyCode == 123 {
                //print ("CURSOR IZQUIERDO")
                if cuentaDec > 1 {
                    cuentaDec -= 1
                    //print(cuentaDec)
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        
                        
                        //print("entro")
                        cuentaboton = botonactual
                        let trozoamover = (560 * Int(cuentaDec)) - 280
                        let cachito = trozoamover - mitadPantalla
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        
                        let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        
                        backplay (tag: Int(cuentaDec))
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        scrollMain.wantsLayer = true
        scrollMain.layer?.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        //NSApplication.shared.windows.first?.styleMask.insert(.fullScreen)
        //NSApplication.shared.windows.first?.styleMask.insert(.miniaturizable)
        //NSApplication.shared.windows.first?.styleMask.insert(.fullSizeContentView)
        
        //self.view.window?.styleMask = [.titled,.closable, .fullSizeContentView, .resizable]
        if let screen = NSScreen.main {
            let rect = screen.frame
            let width = rect.size.width
            let mitadPantalla = Int (width / 2)
            anchuraPantall = Int(width)
            //print(scrollMain.contentView.bounds.origin.x)
            if abiertaLista == false {
                //scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }else {
                
                //print("entro")
                cuentaboton = botonactual
                let trozoamover = (560 * botonactual) - 280
                let cachito = trozoamover - mitadPantalla
                //print(botonactual)
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }
            cuentaboton = (Int (anchuraPantall / 560))
            //let button = self.view.viewWithTag(Int(cuentaboton)) as? NSButton
            //button!.isHighlighted = true
            //button?.highlight(true)
        }
        
        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
        if button!.numeroJuegos == nil {
            button?.numeroJuegos = "0"
        }
        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos! ?? "0") Juegos "
        
        
        
        
        
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    
    @objc func selecionSistema(_ sender: ButtonConsolas) {
        if Int(sender.numeroJuegos!)! > 0 {
            if backIsPlaying == true {
                backPlayer.player?.pause()
            }
            sistemaActual = sender.Fullname!
            nombresistemaactual = sender.Sistema!
            rompath = rutaApp + sender.RomsPath!
            systemextensions = sender.Extensiones!.components(separatedBy: " ")
            comandoaejecutar = rutaApp
            comandoaejecutar = comandoaejecutar + sender.Comando!.replacingOccurrences(of: "%CORE%", with: rutaApp)
            botonactual = sender.tag
            
            if let controller = self.storyboard?.instantiateController(withIdentifier: "ListaView") as? ListaViewController {
                abiertaLista = true
                cuentaPrincipio += 1
                self.view.window?.contentViewController = controller
            }
        }
        
    }
    func backplay (tag: Int) {
        let button = self.view.viewWithTag(Int(tag)) as? ButtonConsolas
        //backIsPlaying = true
        if button?.videos?.count ?? 0 > 0 {
            let miVideo = button?.videos?.randomElement()
            if miVideo != "" {
                print("Mivideo: \(miVideo)")
                let videoURL = URL(fileURLWithPath: miVideo!)
                let player2 = AVPlayer(url: videoURL)
                backPlayer.player = player2
                backPlayer.player?.play()
                backIsPlaying = true
                player2.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(playerItemDidReachEnd(notification:)),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: player2.currentItem)
            }
        }
        
        
        
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
/// FINAL DE LA CLASE

func crearGameListInicio (ruta: String){
    var counter = 0
    var nuevoGamelist = ruta + "/gamelist.xml"
    let root = XMLElement(name: "gameList")
    let xml = XMLDocument(rootElement: root)
    
    //print(xml.xmlString)
    for extensiones in systemextensions {
        
        let fileManager = FileManager.default
        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(extensiones) { // checks the extension
                counter += 1
                let gameNode = XMLElement(name: "game")
                root.addChild(gameNode)
                let pathNode = XMLElement(name: "path", stringValue: rompath + "/" + element)
                let filename = element
                let name = (filename as NSString).deletingPathExtension
                let nameNode = XMLElement(name: "name", stringValue: name)
                let descNode = XMLElement(name: "desc")
                let mapNode = XMLElement(name: "map")
                let manualNode = XMLElement(name: "manual")
                let newsNode = XMLElement(name: "news")
                let tittleshotNode = XMLElement(name: "tittleshot")
                let fanartNode = XMLElement(name: "fanart")
                let thumbnailNode = XMLElement(name: "thumbnail")
                let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: element, ruta: ruta) )
                let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: element,ruta: ruta) )
                let marqueeNode = XMLElement(name: "marquee")
                let releasedateNode = XMLElement(name: "releasedate")
                let developerNode = XMLElement(name: "developer")
                let publisherNode = XMLElement(name: "publisher")
                let genreNode = XMLElement(name: "genre")
                let langNode = XMLElement(name: "lang")
                let playersNode = XMLElement(name: "players")
                let ratingNode = XMLElement(name: "rating")
                let favNode = XMLElement(name: "fav")
                let boxNode = XMLElement(name: "box")
                ///AÑADIMOS LOS NODOS
                gameNode.addChild(pathNode)
                gameNode.addChild(nameNode)
                gameNode.addChild(descNode)
                gameNode.addChild(mapNode)
                gameNode.addChild(manualNode)
                gameNode.addChild(newsNode)
                gameNode.addChild(tittleshotNode)
                gameNode.addChild(fanartNode)
                gameNode.addChild(thumbnailNode)
                gameNode.addChild(imageNode)
                gameNode.addChild(videoNode)
                gameNode.addChild(marqueeNode)
                gameNode.addChild(boxNode)
                gameNode.addChild(releasedateNode)
                gameNode.addChild(developerNode)
                gameNode.addChild(publisherNode)
                gameNode.addChild(genreNode)
                gameNode.addChild(langNode)
                gameNode.addChild(playersNode)
                gameNode.addChild(ratingNode)
                gameNode.addChild(favNode)
                
                
            }
        }
        
    }
    let xmlData = xml.xmlData(options: .nodePrettyPrint)
    
    print("TOTAL: \(counter) Juegos")
    do{
        try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
    }catch {}
    
    
}




func cuentaSistemas() -> NSInteger {
    //print("ENTRO A CONTAR")
    let pathXMLinterno = Bundle.main.url(forResource: "es_systems_mac", withExtension: "cfg")
    sistemasTengo = []
    tieneRoms = false
    if let pathXMLinterno = pathXMLinterno, let data = try? Data(contentsOf: pathXMLinterno as URL)
        
    {
        let parser = BookParser(data: data)
        
        for book in parser.books
        {
            let miruta = rutaApp + book.path /// Es lo mismo que ROMPATH
            ///Comprobar si ha gamelist.xml
            let fileDoesExist = FileManager.default.fileExists(atPath: miruta + "/gamelist.xml")
            if fileDoesExist {
                ///Si existe, lo añadimos al array de sistemas
                sistemasTengo.append(book.name)
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
                        //print("ROMS ENCONTRADAS")
                        systemextensions = extensionescuenta
                        rompath = miruta
                        //print(systemextensions)
                        crearGameListInicio(ruta: miruta)
                        sistemasTengo.append(book.name)
                    }else {
                        
                    }
                }
            }
            
            
        }
    }
    
    sistemasTengo.sort()
    return sistemasTengo.count
}
fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
    var isdirectory : ObjCBool = true
    let exists = FileManager.default.fileExists(atPath: path, isDirectory:  &isdirectory)
    return exists && isdirectory.boolValue
}

func copiarBase(){
    
    print("COPIANDO BASE")
    let home = Bundle.main.bundlePath
    //let Xemu = "cp -r " + APPpathStr +  "/BaseMac/Shared/Xemu  /Users/Shared/Xemu"
    let baseXemu =  "cp -r " + home +  "/Contents/Resources/Base/Shared/Xemu /Users/Shared/Xemu"
    let baseRetro = "cp -r " + home +  "/Contents/Resources/Base/Documents/Retroarch  ~/Documents"
    let baseAppSupport = "cp -r " + home +  "/Contents/Resources/Base/ApplicationSupport/ ~/'Library/Application Support'"
    Commands.Bash.system("\(baseXemu)")
    Commands.Bash.system("\(baseRetro)")
    Commands.Bash.system("\(baseAppSupport)")
    
}

func buscaVideo (juego: String, ruta: String) ->String {
    var tieneVideo = false
    var miVideo = ""
    //let nombreabuscar = juegos[juegosTableView.selectedRow]
    //                    //print(nombreabuscar)
    var name = (juego as NSString).deletingPathExtension
    if name.contains("/") {
        let index2 = name.range(of: "/", options: .backwards)?.lowerBound
        let substring2 = name.substring(from: index2! )
        let result1 = String(substring2.dropFirst())
        name = result1
    }
    else {
        
    }
    let fileManager = FileManager.default
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        //print("RUTA: \(ruta)")
        //Comprobamos Video
        while let element = enumerator.nextObject() as? String {
            if (element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")) ) && element.hasSuffix(".mp4") {
                tieneVideo = true
                //print("EL ROMPATH ES: \(rompath)")
                miVideo = ruta + "/" + element
                break
            }
            else {
                miVideo = ""
                tieneVideo = false
            }
        }
        return miVideo
    } else {
        return ""
    }
    
    
    
}

func buscaImage (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miFoto = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if (element.hasSuffix(".png") || element.hasSuffix(".jpg") || element.hasSuffix(".jpeg") ) && !element.contains("marquee") && !element.contains("box") && !element.contains("fanart") && !element.contains("tittleshot"){
                    tieneSnap = true
                    miFoto = ruta + "/" + element
                    break
                }
            }
            else {
                miFoto = ""
                tieneSnap = false
            }
        }
        
        return miFoto
    } else {
        return ""
    }
    
    
}








class ButtonConsolas: NSButton {
    
    var Sistema: String?
    var Fullname: String?
    var Comando: String?
    var RomsPath: String?
    var Platform: String?
    var Extensiones: String?
    var Theme: String?
    var id: Int?
    var numeroJuegos: String?
    var videos: [String]?
    var cores: [[String]]?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

struct Juego {
    let path: String
    var name: String
    var description: String
    var map: String
    var manual: String
    var news: String
    var tittleshot: String
    var fanart: String
    var thumbnail: String
    var image: String
    var video: String
    var marquee: String
    var releasedate: String
    var developer: String
    var publisher: String
    var genre: String
    var lang: String
    var players: String
    var rating: String
    var fav: String
    var comando: String
    var core: String
    var system: String
    var box: String
}
struct Consola {
    let sistema: String
    let fullname: String
    var command: String
    let rompath: String
    let platform: String
    let extensions: String
    var games: [Juego]
    var videos: [String]
    var cores: [[String]]
}

struct ConsolaRaw {
    let nombrecorto: String
    let nombrelargo: String
    var comando: String
    let rompath: String
    let platform: String
    let extensions: String
    let theme: String
    let emuladores: [[String]]
    
}
