//
//  ViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 01/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//


import Cocoa
import Commands

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
    
    @IBOutlet weak var rutaRomsLabel: NSTextField!
    @IBOutlet weak var scrollMain: NSScrollView!
    @IBOutlet weak var myImage: NSImageView!
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
        as! NSViewController
    }()
    
    @IBAction func openSettings(_ sender: NSButton)  {
        
        
//        if let controller = self.storyboard?.instantiateController(withIdentifier: "ListaView") as? ViewController {
//            controller.dismiss(self)
//            ventana = "Principal"
//
//        }
        
        self.presentAsSheet(sheetViewController)
        
        //Función para abrir ventana de ajustes
        
        
        
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
        let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
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
            //print(scrollMain.contentView.bounds.origin.x)
            if abiertaLista == false {
                //scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }else {
                
                //print("entro")
                //cuentaboton = botonactual
                let trozoamover = (560 * botonactual) - 280
                let cachito = trozoamover - mitadPantalla
                //print(botonactual)
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }
            //cuentaboton = (Int (anchuraPantall / 560))
            //let button = self.view.viewWithTag(Int(cuentaboton)) as? NSButton
            //button!.isHighlighted = true
            //button?.highlight(true)
        }
        
        ///TECLAS
        cuentaDec = CGFloat(botonactual)
        // *** /FullScreen ***
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //print("DID LOAD")
        cuenta = 0
        //scrollerText.setup(string: "ESTO ES UNA PRUEBA ESTO ES UNA PRUEBAESTO ES UNA PRUEBAESTO ES UNA PRUEBA")
        
        //view.window?.isOpaque = false
        //view.window?.backgroundColor = NSColor (red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
        
        
        rutaRomsLabel.stringValue = rompath
        let Xemu = "/users/Shared/Xemu"
        let myGroup = DispatchGroup()
        myGroup.enter()
        //// Do your task
        var isDir:ObjCBool = true
        let theProjectPath = Xemu
        if !FileManager.default.fileExists(atPath: theProjectPath, isDirectory: &isDir) {
            copiarBase()
        } else {
            //print("Existe")
        }
        myGroup.leave() //// When your task completes
        myGroup.notify(queue: DispatchQueue.main) {
        }
        rutaApp = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        //print(rutaApp)
        onOff.stringValue = "SALIR"
        let totalSistemas = cuentaSistemas()
        let totalAnchuraMenu = ((totalSistemas+1) * 560)
        //Parsear Sistemas
        let pathXMLinterno = Bundle.main.url(forResource: "es_systems_mac", withExtension: "cfg")
        let documentView = NSView(frame: NSRect(x: 0,y: 0,width: totalAnchuraMenu,height: 178))
        if let pathXMLinterno = pathXMLinterno, let data = try? Data(contentsOf: pathXMLinterno as URL)
        {
            
            let parser = BookParser(data: data)
            var counter = 0
            for book in parser.books
                
            {
                let offset = CGFloat(counter * 560)
                let button = ButtonConsolas(frame: NSRect(x: offset, y: 0, width: 560, height: 178 ))
                button.tag = counter+1
                button.title = book.name
                let home = Bundle.main.bundlePath
                let imagen2 = NSImage(byReferencingFile: home +  "/Contents/Resources/themes/default/logos/" + book.name + ".png")!
                button.imageScaling = .scaleProportionallyDown
                let path =  home +  "/Contents/Resources/themes/default/logos/" + book.name + ".png"
                let fileDoesExist = FileManager.default.fileExists(atPath: path)
                if fileDoesExist {
                    button.image = imagen2
                }
                button.Sistema = book.name
                button.Comando = book.comando
                button.RomsPath = book.path
                button.Extensiones = book.extensiones
                button.Platform = book.platform
                button.Theme = book.theme
                button.Fullname = book.fullname
                button.target = self
                button.action = #selector(ViewController.selecionSistema)
                button.isBordered = false
                //button.layer?.backgroundColor = NSColor.red.cgColor
                //var miruta = rutaApp + book.path
                //var isDir:ObjCBool = true
                
                /// COMPROBAMOS SI TIENE ROMS ***********************
                
                
                for sistema in sistemasTengo {
                    
                    if sistema == book.name{
                        documentView.addSubview(button)
                        counter += 1
                        break
                    }
                    
                }
                
                /// COMPROBAMOS SI TIENE ROMS ***********************
                
                scrollMain.documentView = documentView
                
            }
            
            cuantosSistemas = counter
            ventana = "Principal"
            //onOff.stringValue = rutaApp
        }
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
            }else {
                cuentaboton = botonactual
                scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                scrollMain.isHidden = false
            }
            
            //let button = self.view.viewWithTag(Int(cuentaboton)) as? NSButton
            //button!.isHighlighted = true
            //button?.highlight(true)
        }
        cuentaDec = CGFloat(botonactual)
    }
    
    
    //TECLAS
    override func keyDown(with event: NSEvent) {
        if keyIsDown == true {
            return
        }
        
        if abiertaLista == false {
            
            if event.keyCode == 49  {
                
                //print("SPACEBAR")
                let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                sistemaActual = button?.Fullname! ?? ""
                //print(sistemaActual)
                selecionSistema(button!)
                
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
                        //cuentaboton = (Int (anchuraPantall / 560))
                        //let button = self.view.viewWithTag(Int(cuentaboton)) as? NSButton
                        //button!.isHighlighted = true
                        //button?.highlight(true)
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
                        
                        
                        //print("Derecho Mover")
                        cuentaboton = botonactual
                        let trozoamover = (560 * botonactual) - 280
                        let cachito = trozoamover - mitadPantalla
                        //print(botonactual)
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        scrollMain.isHidden = false
                        
                        //cuentaboton = (Int (anchuraPantall / 560))
                        //let button = self.view.viewWithTag(Int(cuentaboton)) as? NSButton
                        //button!.isHighlighted = true
                        //button?.highlight(true)
                        print ("CUENTABOTON: \(cuentaboton)")
                        print ("BOTONACTUAL: \(botonactual)")
                    }
               
                }
                
            }
            
        }
        else if abiertaLista == true {
            
            
            if event.keyCode == 49  {
                
                //print("SPACEBAR")
                let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                sistemaActual = button?.Fullname! ?? ""
                //print(sistemaActual)
                selecionSistema(button!)
                
                
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
        
        ///TECLAS
        //cuentaDec = CGFloat(botonactual)
        
        
    }
    
    
    @objc func selecionSistema(_ sender: ButtonConsolas) {
        
        sistemaActual = sender.Fullname! 
        //print (sender.Comando! )
        //print (sender.Sistema! )
        rompath = rutaApp + sender.RomsPath!
        systemextensions = sender.Extensiones!.components(separatedBy: " ")
        comandoaejecutar = rutaApp
        comandoaejecutar = comandoaejecutar + sender.Comando!.replacingOccurrences(of: "%CORE%", with: rutaApp)
        botonactual = sender.tag
        //crearGameList(ruta: rompath)
        print(sistemaActual)
        if let controller = self.storyboard?.instantiateController(withIdentifier: "ListaView") as? ListaViewController {
            abiertaLista = true
            self.view.window?.contentViewController = controller
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
                let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: element) )
                let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: element) )
                let marqueeNode = XMLElement(name: "marquee")
                let releasedateNode = XMLElement(name: "releasedate")
                let developerNode = XMLElement(name: "developer")
                let publisherNode = XMLElement(name: "publisher")
                let genreNode = XMLElement(name: "genre")
                let langNode = XMLElement(name: "lang")
                let playersNode = XMLElement(name: "players")
                let ratingNode = XMLElement(name: "rating")
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
                gameNode.addChild(releasedateNode)
                gameNode.addChild(developerNode)
                gameNode.addChild(publisherNode)
                gameNode.addChild(genreNode)
                gameNode.addChild(langNode)
                gameNode.addChild(playersNode)
                gameNode.addChild(ratingNode)
                
                
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
    let home = Bundle.main.bundlePath
    //let Xemu = "cp -r " + APPpathStr +  "/BaseMac/Shared/Xemu  /Users/Shared/Xemu"
    let baseXemu =  "cp -r " + home +  "/Contents/Resources/Base/Shared/Xemu /Users/Shared/Xemu"
    let baseRetro = "cp -r " + home +  "/Contents/Resources/Base/Documents/Retroarch  ~/Documents"
    let baseAppSupport = "cp -r " + home +  "/Contents/Resources/Base/ApplicationSupport/ ~/'Library/Application Support'"
    Commands.Bash.system("\(baseXemu)")
    Commands.Bash.system("\(baseRetro)")
    Commands.Bash.system("\(baseAppSupport)")
    
}

func buscaVideo (juego: String) ->String {
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
    let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: rompath as String)!
    //Comprobamos Video
    while let element = enumerator.nextObject() as? String {
        if element.contains(name) && element.hasSuffix(".mp4") {
            tieneVideo = true
            miVideo = rompath + "/" + element
            break
        }
        else {
            miVideo = ""
            tieneVideo = false
        }
    }
    
    return miVideo
}

func buscaImage (juego: String) -> String {
    var tieneSnap = false
    var miFoto = ""
    let fileManager = FileManager.default
    let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: rompath as String)!
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
        
        if element.contains(name){
            if (element.hasSuffix(".png") || element.hasSuffix(".jpg") || element.hasSuffix(".jpeg")) && !element.contains("marquee"){
                tieneSnap = true
                miFoto = rompath + "/" + element
                break
            }
        }
        else {
            miFoto = ""
            tieneSnap = false
        }
    }
    
    return miFoto
    
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

