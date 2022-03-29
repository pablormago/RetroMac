//
//  GridScreen.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 17/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa
import Commands
import AVKit
import AVFoundation
var tempViewController = NSViewController()
var myPlayer = AVPlayerView()
var myRatingStar = NSLevelIndicator()
var myPlayersLabel = NSTextField()
var myGameLabel = NSTextField()
var fila = Int()
var columna = Int()
var tempJuegosXml = [[String]]()
var myCollectionView = NSCollectionView()
var myBotonManual = NSButton()
var myBox3DButton = NSButton()
var myConsolaLabel = NSTextField()
var myMasBtn = NSButton()
var myMenosBtn = NSButton()
var myKKController = NSViewController()

class GridScreen: NSViewController {
    
    //MARK: Variables de clase
    var keyIsDown = false
    //var juegosXml = [[String]]()
    var showSectionHeaders = false
    var previewURL: URL?
    let photoItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "photoItemIdentifier")
    
    //MARK: Outlets
    @IBOutlet weak var botonManual: NSButton!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var logoSistema: NSImageView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var gridSistemaLabel: NSTextField!
    @IBOutlet weak var ajustesBtn: NSButton!
    @IBOutlet weak var box3DBtn: NSButton!
    @IBOutlet weak var consolaLabel: NSTextField!
    @IBOutlet weak var infoBox: NSBox!
    @IBOutlet weak var gameLabel: NSTextField!
    @IBOutlet weak var playersLabeñ: NSTextField!
    @IBOutlet weak var ratingStars: NSLevelIndicator!
    @IBOutlet weak var returnBtn: NSButton!
    @IBOutlet weak var lanzarBtn: NSButton!
    @IBOutlet weak var settingsBtn: NSButton!
    @IBOutlet weak var netplayBtn: NSButton!
    @IBOutlet weak var menosBtn: NSButton!
    @IBOutlet weak var masBtn: NSButton!
    
    //MARK: Actions
    @IBAction func lanzarJuegos(_ sender: Any) {
        launchGame()
    }
    @IBAction func abrirAjustes(_ sender: Any) {
        lazy var sheetViewController: NSViewController = {
            return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
            as! NSViewController
        }()
        
        tempViewController = SingletonState.shared.currentViewController!
        SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
    }
    @IBAction func abrirBox3d(_ sender: Any) {
        let miBox = String(juegosXml[columna][23])
        NSWorkspace.shared.openFile(miBox)
    }
    @IBAction func openManual(_ sender: Any) {
        abrirPdf()
    }
    
    @IBAction func openGameSettings(_ sender: Any) {
        if sistemaActual != "Favoritos" {
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "OptionsView")
                as! NSViewController
            }()
            myPlayer.player?.pause()
            tempViewController = SingletonState.shared.currentViewController!
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
        
    }
    
    @IBAction func abrirNetplay(_ sender: Any) {
        lazy var sheetViewController: NSViewController = {
            return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
            as! NSViewController
        }()
        SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
    }
    
    @IBAction func menosSistena(_ sender: Any) {
        if botonactual > 1 {
            print("Izquierda")
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                //self.view.window?.contentViewController = controller
                myPlayer.player?.pause()
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
                myCollectionView.reloadData()
                if juegosXml.count > 0 {
                    let indexPath:IndexPath = IndexPath(item: 0, section: 0)
                    var set = Set<IndexPath>()
                    set.insert(indexPath)
                    myCollectionView.selectItems(at: set, scrollPosition: .top)
                }
            }
        }
    }
    @IBAction func masSistema(_ sender: Any) {
        if botonactual < cuantosSistemas {
            print("Derecha")
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                //self.view.window?.contentViewController = controller
                myPlayer.player?.pause()
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
                myCollectionView.reloadData()
                if juegosXml.count > 0 {
                    let indexPath:IndexPath = IndexPath(item: 0, section: 0)
                    var set = Set<IndexPath>()
                    set.insert(indexPath)
                    myCollectionView.selectItems(at: set, scrollPosition: .top)
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ancho)
        print(alto)
        ventanaModal = "Alguna"
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        scrollView.wantsLayer = true
        scrollView.layer?.cornerRadius = 5
        //collectionView.isHidden = true
        SingletonState.shared.currentViewController? = self
        filtradoPaso1()
        arrayJuegos ()
        configureCollectionView()
        returnBtn.action = #selector(backFunc)
        //collectionView.becomeFirstResponder()
        //lanzarBtn.becomeFirstResponder()
        infoBox.title = "Título"
        ratingStars.frameRotation = 90
        //keyIsDown = false
        myKKController = self
        //MARK: Hacemos globales los controles
        
        myRatingStar = ratingStars
        myPlayersLabel = playersLabeñ
        myCollectionView = collectionView
        myGameLabel = gameLabel
        myBotonManual = botonManual
        myBox3DButton = box3DBtn
        myConsolaLabel = consolaLabel
        myMasBtn = masBtn
        myMenosBtn = menosBtn
        
        if sistemaActual == "Favoritos" {
            consolaLabel.isHidden = false
        } else {
            consolaLabel.isHidden = true
        }
        
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        
        
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        let indexPath:IndexPath = IndexPath(item: 0, section: 0)
        var set = Set<IndexPath>()
        set.insert(indexPath)
        collectionView.selectItems(at: set, scrollPosition: .top)
        ventana = "Grid"
        collectionView.becomeFirstResponder()
        fila = 0
        columna = 0
        myRatingStar.doubleValue = (Double(juegosXml[0][18]) ?? 0) * 5
        myPlayersLabel.stringValue = juegosXml[0][17]
        gameLabel.stringValue = juegosXml[0][1]
        if juegosXml[0][4] != "" {
            botonManual.isHidden = false
        } else {
            botonManual.isHidden = true
        }
        let miBox = juegosXml[columna][23]
        if miBox != "" {
            let imagenURL = URL(fileURLWithPath: miBox)
            var imagen = NSImage(contentsOf: imagenURL)
            box3DBtn.image = imagen
            box3DBtn.isHidden = false
        } else {
            box3DBtn.isHidden = true
        }
        consolaLabel.stringValue = juegosXml[0][22]
        cuentaCargaGrid += 1
        if cuentaCargaGrid == 1 {
            NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (myEvent) -> NSEvent? in
                self.keyUp(with: myEvent)
                return myEvent
            }
            
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (myEvent) -> NSEvent? in
                self.keyDown(with: myEvent)
                return myEvent
            }
        }
        
        ventanaModal = "Ninguna"
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = false
        collectionView.allowsMultipleSelection = false
        collectionView.enclosingScrollView?.borderType = .noBorder
        collectionView.register(NSNib(nibNamed: "PhotoItem", bundle: nil), forItemWithIdentifier: photoItemIdentifier)
        
        configureFlowLayout()
        //configureGridLayout()
    }
    
    
    
    func configureFlowLayout() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        //collectionView.collectionViewLayout = flowLayout
    }
    
    func arrayJuegos (){
        for consola in allTheGames {
            if consola.sistema == nombresistemaactual {
                for game in consola.games {
                    //print(game)
//                    let rutaJuegoRaw = game.path as NSString
//                    let rutaJuego = rutaJuegoRaw.deletingLastPathComponent
//                    let filaNivel = xmlRutasUnique.firstIndex(where: {$0[1] == "0"})
//                    let rutaABuscar = xmlRutasUnique[filaNivel!][0]
                    
                    let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
                    
                    juegosXml.append(mijuego)
                    
                }
            break
            }
        }
        gridSistemaLabel.stringValue = sistemaActual
        juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
        
        
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
                gridSistemaLabel.isHidden = true
                logoSistema.image = imagen2
            }else {
                logoSistema.isHidden = true
                gridSistemaLabel.isHidden = false
            }
            
        }
        
        
    }
    
    
    
}


extension GridScreen: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return juegosXml.count
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        guard let item = collectionView.makeItem(withIdentifier: photoItemIdentifier, for: indexPath) as? PhotoItem else { return NSCollectionViewItem() }
        //        let miRating = (Double(juegosXml[indexPath.item][18]) ?? 0 * 5)
        //        ratingStars.doubleValue = miRating
        let miVideo = juegosXml[indexPath.item][10]
        let imagenURL = URL(fileURLWithPath: juegosXml[indexPath.item][9])
        let imagen2 = NSImage(contentsOf: imagenURL)
        item.imageView?.image = imagen2
        item.playerItem?.isHidden = true
        let videoURL = URL(fileURLWithPath: miVideo)
        let player = AVPlayer(url: videoURL)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        item.gameLabel.stringValue = juegosXml[indexPath.item][1]
        item.playerItem?.player = player
        
        
        item.doubleClickActionHandler = { [weak self] in
            print("LANZA JUEGO")
            self!.launchGame()
            
            
        }
        
        return item
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        
        //        guard let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as? HeaderView else { return NSView() }
        
        //        guard photos[indexPath.section].count > 0, let url = photos[indexPath.section][0].url else { return NSView() }
        
        //        view.label.stringValue = url.deletingLastPathComponent().lastPathComponent + " (\(photos[indexPath.section].count))"
        return view
    }
}



// MARK: - NSCollectionViewDelegateFlowLayout
extension GridScreen: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        guard let indexPath = indexPaths.first else { return }
        columna = indexPath.item
        fila = indexPath.section
        let miRating = (Double(juegosXml[indexPath.item][18]) ?? 0) * 5
        ratingStars.doubleValue = miRating
        myPlayersLabel.stringValue = juegosXml[indexPath.item][17]
        gameLabel.stringValue = juegosXml[indexPath.item][1]
        if juegosXml[indexPath.item][4] != "" {
            botonManual.isHidden = false
        } else {
            botonManual.isHidden = true
        }
        let miBox = juegosXml[indexPath.item][23]
        if miBox != "" {
            let imagenURL = URL(fileURLWithPath: miBox)
            var imagen = NSImage(contentsOf: imagenURL)
            box3DBtn.image = imagen
            box3DBtn.isHidden = false
        } else {
            box3DBtn.isHidden = true
        }
        consolaLabel.stringValue = juegosXml[columna][22]
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 415.0, height: 327)
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        
        return showSectionHeaders ? NSSize(width: 0.0, height: 60.0) : .zero
    }
    @IBAction func backFunc(_ sender: NSButton) {
        
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            myPlayer.player?.pause()
            SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
            controller.view.window?.makeFirstResponder(controller.scrollMain)
            //snapPlayer.player?.pause()
            abiertaLista = false
            ventana = "Principal"
            cuentaboton = botonactual
        }
    }
    
    @objc func launchGame() {
        let numero = columna
        let nombredelarchivo = juegosXml[numero][0].replacingOccurrences(of: rutaApp , with: "")
        let romXml = "\"\(juegosXml[numero][0])\""
        let rompathabuscar = juegosXml[numero][0]
        var comandojuego = juegosXml[numero][20]
        myPlayer.player?.pause()
        
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
            print("CORE CUSTOM")
        } else {
            print("CORE DEFAULT")
        }
        
        var micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
        var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
        print(comando)
        Commands.Bash.system("\(comando)")
        comando=""
        myPlayer.player?.play()
        
        
        print("ENTER")
    }
    
    public func checkShaders (juego: String) -> String {
        var shader = String ()
        var shadersSystem = String()
        var shadersGame = String()
        
        let filaenSystem = arraySystemsShaders.firstIndex(where: {$0[0] == sistemaActual})
        if filaenSystem != nil {
            shadersSystem = arraySystemsShaders[filaenSystem!][2]
        } else {
            shadersSystem = ""
        }
        let filaEnGame = arrayGamesShaders.firstIndex(where: {$0[0] == juego})
        if filaEnGame != nil {
            let miShader = arrayGamesShaders[filaEnGame!][2]
            if miShader == "Ninguno" {
                shadersGame = ""
            } else {
                shadersGame = miShader
            }
            
        }else {
            shadersGame = shadersSystem
        }
        
        if shadersSystem == shadersGame {
            shader = shadersSystem
        }
        
        if shadersSystem != shadersGame  {
            shader = shadersGame
        }
        
        //
        return shader
    }
    
    public func checkBezels (juego: String) -> Bool {
        var bezelsSystem = Bool ()
        var bezelsGame = Bool ()
        var bezels = Bool()
        // MARK: comprobamos si tiene puesto que se lancen los bezels en todos los juegos del sistema
        let filaenSystem = arraySystemsBezels.firstIndex(where: {$0[0] == sistemaActual})
        if filaenSystem != nil {
            print(arraySystemsBezels[filaenSystem!])
            //Si está en el array es que está activado, sino es quer no lo está
            bezelsSystem = true
        } else {
            bezelsSystem = false
        }
        
        // MARK: comprobamos si el juego tiene puesto que se lance su bezel
        let filaenGames = arrayGamesBezels.firstIndex(where: {$0[0] == juego})
        if filaenGames == nil {
            bezelsGame = bezelsSystem
        } else {
            let siONoGameBezel = arrayGamesBezels[filaenGames!][1]
            if siONoGameBezel == "Sí" {
                bezelsGame = true
            } else {
                bezelsGame = false
            }
        }
        
        if bezelsSystem == true && bezelsGame == true {
            bezels = true
        }
        if bezelsSystem == true && bezelsGame == false {
            bezels = false
        }
        if bezelsSystem == false && bezelsGame == false {
            bezels = false
        }
        if bezelsSystem == false && bezelsGame == true {
            bezels = true
        }
        print("\(bezelsSystem) - \(bezelsGame)")
        
        return bezels
    }
    @objc func abrirPdf () {
        print("PDF")
        let miManual = String(juegosXml[columna][4])
        NSWorkspace.shared.openFile(miManual)
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    override func keyDown(with myEvent: NSEvent) {
        
        if keyIsDown == true {
            return
        }
        keyIsDown = true
        
        if myEvent.keyCode == 51 && ventana == "Grid" && ventanaModal == "Ninguna" {
            
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                myPlayer.player?.pause()
                SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
                controller.view.window?.makeFirstResponder(controller.scrollMain)
                //snapPlayer.player?.pause()
                abiertaLista = false
                ventana = "Principal"
                cuentaboton = botonactual
            }
            print("Vuelvo")
        }
        if myEvent.keyCode == 36 && ventana == "Grid" && ventanaModal == "Ninguna" {
            print("LANZO")
            launchGame()
            
        }
    }
    override func keyUp(with myEvent: NSEvent) {
        keyIsDown = false
    }
    
}
