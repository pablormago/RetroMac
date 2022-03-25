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
var esBoB = Bool()
var rutaTransformada = String()
var myGameController: GCController?
var mainController  = NSViewController()
var retroArchConfig = [[String]]()
var netplayPlays: [PartidaNetplay] = []
var NetCores = [[String]]()
var arrayShaders = [[String]]()
var arrayGamesShaders = [[String]]()
var arraySystemsShaders = [[String]] ()
var arrayGamesBezels = [[String]]()
var arraySystemsBezels = [[String]]()
var citraConfig = [String]()
var pantallaJuegos = String()
var ventanaModal = String()
var escrapeando = false
var cuentaCargaGrid = 0
var cuentaCarga = 0
var cuentaCargaGame = 0
class ViewController: NSViewController {
    var sistema = ""
    var comandoexe = ""
    var anchuraPantall = 0
    var keyIsDown = false
    var cuentaDec = CGFloat()
    //override var acceptsFirstResponder: Bool { return true }
    //override func becomeFirstResponder() -> Bool { return true }
    //override func resignFirstResponder() -> Bool { return true }
    
    @IBOutlet weak var scrollerText: ScrollingTextView!
    @IBOutlet weak var mainBackImage: NSImageView!
    @IBOutlet weak var tog1: NSSwitch!
    @IBOutlet weak var onOff: NSTextField!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var gridBtn: NSButton!
    
    
    @IBAction func enterSystem(_ sender: Any) {
        if cuentaPrincipio  > 0 && ventana == "Principal" {
            print("ENTER LISTA TRUE")
            let button = self.view.viewWithTag(Int(self.cuentaDec)) as? ButtonConsolas
            sistemaActual = button?.Fullname! ?? ""
            //print(sistemaActual)
            if backIsPlaying == true {
                self.backPlayer.player?.pause()
                SingletonState.shared.myBackPlayer?.player?.pause()
            }
            if Int(button!.numeroJuegos!)! > 0 {
                self.selecionSistema(button!)
            }
            
        } else {
            if ventana == "Principal" {
                print("ENTER LISTA FALSE")
                let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                sistemaActual = button?.Fullname! ?? ""
                if backIsPlaying == true {
                    self.backPlayer.player?.pause()
                    SingletonState.shared.myBackPlayer?.player?.pause()
                }
                if Int(button!.numeroJuegos!)! > 0 {
                    self.selecionSistema(button!)
                }
            }
        }
    }
    @IBOutlet weak var enterBtn: NSButton!
    @IBOutlet weak var backPlayer: AVPlayerView!
    @IBOutlet weak var sistemaLabel: NSTextField!
    @IBOutlet weak var rutaRomsLabel: NSTextField!
    @IBOutlet weak var scrollMain: NSScrollView!
    @IBOutlet weak var myImage: NSImageView!
    
    @IBAction func openNetplay(_ sender: Any) {
        lazy var sheetViewController: NSViewController = {
            return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
            as! NSViewController
        }()
        SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
    }
    @IBOutlet weak var netBtn: NSButton!
    @IBOutlet weak var rightBtm: NSButton!
    @IBAction func masMenu(_ sender: Any) {
        if cuentaPrincipio == 0 {
            self.masSistemaKeys()
        }else {
            self.masSistemaListaKeys()
        }
    }
    @IBOutlet weak var leftBtn: NSButton!
    @IBAction func menosMenu(_ sender: Any) {
        if cuentaPrincipio == 0 {
            self.menosSistemaKeys()
        }else {
            self.menosSistemaListaKeys()
        }
    }
    
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
        //return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
        as! NSViewController
    }()
    
    @IBAction func openSettings(_ sender: NSButton)  {
        SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
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
        cuentaCarga += 1
        if cuentaCarga == 1 {
            NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (aEvent) -> NSEvent? in
                self.keyUp(with: aEvent)
                return aEvent
            }
            
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
                self.keyDown(with: aEvent)
                return aEvent
            }
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
        
        
        
    }
    // - MARK: fin de DidAppear
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ventana = "Principal"
        ventanaModal = "Ninguna"
        print("DID LOAD")
        //cargaPartidasNetplay ()
        cuenta = 0
        mainController = self
        SingletonState.shared.mySystemLabel = sistemaLabel
        SingletonState.shared.myBackPlayer = backPlayer
        rutaApp = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        //print(rutaApp)
        onOff.stringValue = "SALIR"
        var totalSistemas = 0
        totalSistemas = allTheGames.count
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
            button.action = #selector(selecionSistema)
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
        cuentaCargaGame += 1
        //MARK: Probar esto:
        if cuentaCargaGame == 1 {
            startWatchingForControllers()
        }
        //startWatchingForControllers()
        self.view.window?.makeFirstResponder(self.scrollMain)
        SingletonState.shared.myscroller = self.scrollMain
        SingletonState.shared.currentViewController = self
        SingletonState.shared.currentViewController!.view.window?.makeFirstResponder(SingletonState.shared.myscroller)
        let defaults = UserDefaults.standard
        pantallaJuegos = defaults.string(forKey: "PantallaJuegos") ?? "Lista"
        
        
        
    }
    
    // MARK: Final de viewDidLoad()
    
    
    
    
    //TECLAS
    
    
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
    @objc func playerItemDidReachEnd2(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    
    @objc public func selecionSistema(_ sender: ButtonConsolas) {
        //GCController.stopWirelessControllerDiscovery()
        //NotificationCenter.default.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        
        if Int(sender.numeroJuegos!)! > 0 {
            //NotificationCenter.default.removeObserver(self)
            backStop()
            if backIsPlaying == true {
                backStop()
            }
            
            sistemaActual = sender.Fullname!
            nombresistemaactual = sender.Sistema!
            rompath = rutaApp + sender.RomsPath!
            print("ROMPATH: \(rompath)")
            rutaTransformada = rompath
            print("RUTA TRANSFORMADA: \(rutaTransformada)")
            systemextensions = sender.Extensiones!.components(separatedBy: " ")
            comandoaejecutar = rutaApp
            comandoaejecutar = comandoaejecutar + sender.Comando!.replacingOccurrences(of: "%CORE%", with: rutaApp)
            botonactual = sender.tag
            abiertaLista = true
            cuentaPrincipio += 1
            juegosXml = []
            if pantallaJuegos == "Lista" {
                if let controller = self.storyboard?.instantiateController(withIdentifier: "ListaView") as? ListaViewController {
                    print("Lista")
                    SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
                    
                }
            } else if pantallaJuegos == "Cuadrícula" {
                if let controller = self.storyboard?.instantiateController(withIdentifier: "GridView") as? GridScreen {
                    print("Grid")
                    backStop()
                    SingletonState.shared.currentViewController?.view.window?.contentViewController = controller

                }
            }
            

        }
        
    }
    
    
    
    func backplay (tag: Int) {
        let button = self.view.viewWithTag(Int(tag)) as? ButtonConsolas
        print("BACKPLAY")
        backIsPlaying = true
        if button?.videos?.count ?? 0 > 0 {
            let miVideo = button?.videos?.randomElement()
            print(miVideo)
            if miVideo != "" {
                //print("Mivideo: \(miVideo)")
                let videoURL = URL(fileURLWithPath: miVideo!)
                let player2 = AVPlayer(url: videoURL)
                SingletonState.shared.myBackPlayer!.player = player2
                SingletonState.shared.myBackPlayer!.player!.play()
                backIsPlaying = true
                player2.actionAtItemEnd = .pause
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd2(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
            }
        }
    }
    
    func backStop () {
        SingletonState.shared.myBackPlayer!.player?.pause()
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
/// FINAL DE LA CLASE

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
    let baseCitra = "cp -r " + home +  "/Contents/Resources/Base/.config/citra-emu ~/.config/citra-emu"
    //Commands.Bash.system("\(baseCitra)")
    
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

struct PartidaNetplay {
    let id: Int?
    let username: String?
    let country: String?
    let game_Name: String?
    let game_Crc: String?
    let core_Name: String?
    let core_Version: String?
    let subsystem_Name: String?
    let retroarch_Version: String?
    let frontend: String?
    let ip: String?
    let port: String?
    let mitm_Ip: String?
    let mitm_Port: String?
    let mitm_Session: String?
    let host_Method: Int?
    let has_Password: String?
    let has_SpectatePassword: String?
    let connectable: String?
    let isRetroarch: String?
    let created: String?
    let updated: String?
    let enabled: String?
    let comando: String?
    let gamePath: String?
    let isRelay: String?
}
