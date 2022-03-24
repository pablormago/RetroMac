//
//  ListaViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 09/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Cocoa
import Commands
import AVKit
import AVFoundation
import GameController
var playingVideo = false
var escrapeandoSistema: Bool = false
var juegosaescrapearensistema = Int()
var juesgosEscrapeados = Int()
var filaSeleccionada = Int()
var contextMenu = NSMenu()
var juegosXml = [[String]]()
var listado = NSTableView()
var myAtrasBtn = NSButton()
var myDelanteBtn = NSButton()


class ListaViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    //override var acceptsFirstResponder: Bool { return true }
    //override func becomeFirstResponder() -> Bool { return true }
    //override func resignFirstResponder() -> Bool { return true }
    
    @IBAction func msSistema(_ sender: Any) {
        print("MAS")
        if botonactual < cuantosSistemas {
            print("Derecha")
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                //self.view.window?.contentViewController = controller
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
                botonactual += 1
                juegosXml = []
                contextMenu.items.removeAll()
                let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                sistemaActual = button?.Fullname! ?? ""
                nombresistemaactual = button!.Sistema ?? ""
                //print(sistemaActual)
                
                controller.selecionSistema(button!)
                
                self.viewDidLoad()
                self.viewDidAppear()
                juegosTableView.reloadData()
                if juegosXml.count > 0 {
                    let indexSet = NSIndexSet(index: 0)
                    juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
                }
                
            }
        }
    }
    @IBOutlet weak var msBtn: NSButton!
    @IBAction func msnSistema(_ sender: Any) {
        print("MENOS")
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            //self.view.window?.contentViewController = controller
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
            botonactual -= 1
            juegosXml = []
            contextMenu.items.removeAll()
            let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
            sistemaActual = button?.Fullname! ?? ""
            nombresistemaactual = button!.Sistema ?? ""
            //print(sistemaActual)
            
            controller.selecionSistema(button!)
            
            self.viewDidLoad()
            self.viewDidAppear()
            juegosTableView.reloadData()
            if juegosXml.count > 0 {
                let indexSet = NSIndexSet(index: 0)
                juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
            }
        }
    }
    @IBOutlet weak var mnsBtn: NSButton!
    @IBOutlet weak var logoSistema: NSImageView!
    @IBOutlet weak var optionsButton: NSButton!
    @IBOutlet weak var popButton: NSPopUpButton!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var scrollDescrip: NSScrollView!
    @IBOutlet var scrollDescripText: NSTextView!
    @IBOutlet weak var playersLabel: NSTextField!
    @IBOutlet weak var genreLabel: NSTextField!
    @IBOutlet weak var publisherLabel: NSTextField!
    @IBOutlet weak var developerLabel: NSTextField!
    @IBOutlet weak var logoImage: NSImageView!
    @IBOutlet weak var screenshotImage: NSImageView!
    @IBOutlet weak var favImagen: NSButton!
    @IBOutlet weak var tituloTextField: NSTextField!
    @IBOutlet weak var gameOptBtn: NSButton!
    
    @IBAction func abrirGameOption(_ sender: Any) {
        
        lazy var sheetViewController: NSViewController = {
            return self.storyboard!.instantiateController(withIdentifier: "OptionsView")
            as! NSViewController
        }()
        SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
    }
    @IBOutlet weak var barraProgress: NSProgressIndicator!
    @IBAction func aceptarTitulo(_ sender: NSButton) {
        
        let indexSet = NSIndexSet(index: juegosTableView.selectedRow)
        juegosXml[juegosTableView.selectedRow][1] = tituloTextField.stringValue
        let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
        allTheGames[mifila!].games[mifilaJuego!].name = tituloTextField.stringValue
        
        xmlJuegosNuevos()
        juegosTableView.reloadData()
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        editarBox.isHidden = true
        abiertaLista = true
        
        
        
        
    }
    @IBAction func cancelEditar(_ sender: Any) {
        abiertaLista = true
        editarBox.isHidden = true
    }
    @IBOutlet weak var editarBox: NSBox!
    @IBOutlet weak var borrarLabel: NSTextField!
    @IBAction func deleteGame(_ sender: NSButton) {
        borrarBox.isHidden = true
        let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
        let indexSet = NSIndexSet(index: juegosTableView.selectedRow)
        let miPath = juegosXml[juegosTableView.selectedRow][0]
        juegosXml.remove(at: juegosTableView.selectedRow)
        juegosTableView.removeRows(at: indexSet as IndexSet, withAnimation: .effectFade)
        let fileDoesExist = FileManager.default.fileExists(atPath: miPath)
        if fileDoesExist {
            do {
                let fileManager = FileManager.default
                try fileManager.removeItem(atPath: miPath)
                infoLabel.stringValue = "JUEGO BORRADO"
                
            }
            catch {
                print("Error")
            }
        }
        xmlJuegosNuevos()
        
        allTheGames[mifila!].games.remove(at: mifilaJuego!)
        abiertaLista = true
        //        juegosTableView.isEnabled = true
        //        juegosTableView.performClick(nil)
    }
    @IBAction func cancelBorrar(_ sender: NSButton) {
        let indexSet = NSIndexSet(index: juegosTableView.selectedRow)
        borrarBox.isHidden = true
        abiertaLista = true
        juegosTableView.isEnabled = true
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        juegosTableView.performClick(nil)
    }
    @IBAction func lanzarJuego(_ sender: Any) {
        onItemClicked()
    }
    @IBAction func abrirAjustes(_ sender: Any) {
        if ventanaModal == "Ninguna"{
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
                as! NSViewController
            }()
            
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
    }
    @IBAction func abrirNetplay(_ sender: Any) {
        if ventanaModal == "Ninguna" {
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
                as! NSViewController
            }()
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
    }
    //
    @IBAction func volverAlMenu(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            if playingVideo == true {
                SingletonState.shared.mySnapPlayer?.player?.pause()
            }
            
            SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
            snapPlayer.player?.pause()
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
            
        }
    }
    
    @IBOutlet weak var borrarBox: NSBox!
    @IBOutlet weak var pdfImage: NSButton!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var scrollerDesc: ScrollingTextView!
    @IBOutlet weak var sistemaLabel: NSTextField!
    @IBOutlet weak var snapPlayer: AVPlayerView!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var juegosTableView: NSTableView!
    @IBOutlet weak var snapShot: NSImageView!
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "OptionsView")
        //return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
        as! NSViewController
    }()
    
    var juegos = [String]()
    //var juegosXml = [[String]]()
    //    var contextMenu = NSMenu()
    var keyIsDown = false
    var cuentaClicks = 0
    @IBAction func abrirOpciones(_ sender: Any) {
        
        SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ventana = "Lista"
        infoLabel.isHidden = true
        SingletonState.shared.mytable = self.juegosTableView
        //SingletonState.shared.myBackPlayer?.player?.pause()
        print("LISTA LOAD")
        view.wantsLayer = true
        // change the background color of the layer
        view.layer?.backgroundColor = CGColor(red: 73/255, green: 74/255, blue: 77/255, alpha: 1)
        listado = juegosTableView
        snapShot.wantsLayer = true
        snapShot.layer?.cornerRadius = 10.0
        snapShot.layer?.masksToBounds = true
        snapPlayer.wantsLayer = true
        snapPlayer.layer!.cornerRadius = 10.0
        snapPlayer.layer!.masksToBounds = true
        myAtrasBtn = mnsBtn
        myDelanteBtn = msBtn
        // Do view setup here.
        
        ///Juegos GAMELIST
        let fileDoesExist = FileManager.default.fileExists(atPath: rompath + "/gamelist.xml")
        print(sistemaActual)
        if fileDoesExist {
            print("HAY XML")
            
        }
        
        for consola in allTheGames {
            if consola.sistema == nombresistemaactual {
                for game in consola.games {
                    //print(game)
                    let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
                    juegosXml.append(mijuego)
                    
                }
            }
        }
        sistemaLabel.stringValue = sistemaActual
        juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
        /// FIN JUEGOS GAMELIST
        //self.popButton.menu = contextMenu
        self.setupMenu()
        //EL PROBLEMA ESTÁ AQUI
        if juegosXml.count > 0 {
            let indexSet = NSIndexSet(index: 0)
            juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        }
        juegosTableView.doubleAction = #selector(onItemClicked)
        pdfImage.action = #selector(abrirPdf)
        favImagen.isHidden = true
        pdfImage.isHidden = true
        
        if juegosXml.count > 0 {
            if juegosXml[0][4] == "" {
                pdfImage.isHidden = true
            }else {
                pdfImage.isHidden = false
            }
            if juegosXml[0][19] == "" {
                favImagen.isHidden = true
            }else {
                favImagen.isHidden = false
            }
        }
        rutaTransformada = rompath
        SingletonState.shared.currentViewController? = self
        print("Tengo: \(GCController.controllers().count) Mandos")
        SingletonState.shared.myJuegosXml = juegosXml
        SingletonState.shared.myBackPlayer?.player?.pause()
        let filaConsola = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        if filaConsola != nil {
            let sistemaABuscar = allTheGames[filaConsola!].sistema
            let home = Bundle.main.bundlePath
            let imagen2 = NSImage(byReferencingFile: home +  "/Contents/Resources/themes/default/logos/" + sistemaABuscar + ".png")!
            logoSistema.imageScaling = .scaleProportionallyDown
            let path =  home +  "/Contents/Resources/themes/default/logos/" + sistemaABuscar + ".png"
            let fileDoesExist = FileManager.default.fileExists(atPath: path)
            if fileDoesExist {
                logoSistema.isHidden = false
                sistemaLabel.isHidden = true
                logoSistema.image = imagen2
            }else {
                logoSistema.isHidden = true
                sistemaLabel.isHidden = false
            }
            
        }
        ///Nombres cargados
        
    }
    
    
    
    override func viewWillDisappear() {
        snapPlayer.player?.pause()
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        print("LISTA APPEAR")
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        snapShot.wantsLayer = true
        snapShot.layer?.cornerRadius = 10.0
        
        screenshotImage.wantsLayer = true
        screenshotImage.shadow = NSShadow()
        screenshotImage.layer!.cornerRadius = 10.0
        screenshotImage.layer!.shadowOpacity = 1.0
        screenshotImage.layer!.shadowColor = NSColor.black.cgColor
        screenshotImage.layer!.shadowOffset = NSMakeSize(0, -3)
        screenshotImage.layer!.shadowRadius = 20
        
        logoImage.wantsLayer = true
        logoImage.shadow = NSShadow()
        logoImage.layer!.cornerRadius = 10.0
        logoImage.layer!.shadowOpacity = 1.0
        logoImage.layer!.shadowColor = NSColor.black.cgColor
        
        logoImage.layer!.shadowOffset = NSMakeSize(0, -3)
        logoImage.layer!.shadowRadius = 20
        //snapShot.layer?.masksToBounds = true
        snapPlayer.wantsLayer = true
        snapPlayer.layer!.cornerRadius = 10.0
        snapPlayer.shadow = NSShadow()
        snapPlayer.layer!.shadowOpacity = 1.0
        snapPlayer.layer!.shadowColor = NSColor.black.cgColor
        snapPlayer.layer!.shadowOffset = NSMakeSize(0, -3)
        snapPlayer.layer!.shadowRadius = 20
        //setupMenu2()
        self.juegosTableView.becomeFirstResponder()
        SingletonState.shared.mySnapPlayer = self.snapPlayer
        cuentaClicks = 1
        ventana = "Lista"
        
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        //SingletonState.shared.myBackPlayer?.player?.pause()
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        sistemaLabel.stringValue = sistemaActual
        
        
    }
    
    
    
    
    @objc public func onItemClicked() {
        //SingletonState.shared.myBackPlayer?.player?.pause()
        let numero = (self.juegosTableView.selectedRow)
        let nombredelarchivo = juegosXml[numero][0].replacingOccurrences(of: rutaApp , with: "")
        let romXml = "\"\(juegosXml[numero][0])\""
        let rompathabuscar = juegosXml[numero][0]
        var comandojuego = juegosXml[numero][20]
        
        
        if comandojuego.contains("RetroArch") {
            gameShader(shader: "")
            noGameOverlay()
            let defaults = UserDefaults.standard
            let shaders = defaults.integer(forKey: "Shaders")
            print("SHADERS \(shaders)")
            if shaders == 1 {
                let juegoABuscar = juegosXml[numero][0]
                let miShader = checkShaders(juego: juegoABuscar)
                gameShader(shader: miShader)
            }
            let marcos = defaults.integer(forKey: "Marcos")
            
            if marcos == 1 {
                if checkBezels(juego: juegosXml[numero][0]) == true {
                    gameOverlay(game: nombredelarchivo)
                }
            }
        }
        
        if comandojuego.contains("citra-qt") {
            let mifilaconfig1 = citraConfig.firstIndex(where: {$0.contains("fullscreen=")})
            if mifilaconfig1 != nil {
                citraConfig[mifilaconfig1!] = "fullscreen=true"
            }
            let mifilaconfig2 = citraConfig.firstIndex(where: {$0.contains("fullscreen\\default=")})
            if mifilaconfig2 != nil {
                citraConfig[mifilaconfig2!] = "fullscreen\\default=false"
            }
            
            writeCitraConfig()
        }
        
        var fila = arrayGamesCores.firstIndex(where: {$0[0] == rompathabuscar})
        if fila != nil {
            comandojuego = arrayGamesCores[fila!][1]
        }
        
        var micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
        //print(micomando.replacingOccurrences(of: "%ROM%", with: romXml))
        var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
        if playingVideo == true {
            SingletonState.shared.mySnapPlayer?.player?.pause()
            snapPlayer.player?.pause()
        }
        print(comando)
        Commands.Bash.system("\(comando)")
        comando=""
        
        let indexSet = NSIndexSet(index: (juegosTableView.selectedRow + -1))
        let indexSet2 = NSIndexSet(index: juegosTableView.selectedRow )
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        juegosTableView.selectRowIndexes(indexSet2 as IndexSet, byExtendingSelection: false)
        
        print("ENTER")
    }
    
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}


