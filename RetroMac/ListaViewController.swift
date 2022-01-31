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
var playingVideo = false
var escrapeandoSistema: Bool = false
var juegosaescrapearensistema = Int()
var juesgosEscrapeados = Int()

class ListaViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    override var acceptsFirstResponder: Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    
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
    @IBOutlet weak var borrarBox: NSBox!
    @IBOutlet weak var pdfImage: NSButton!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var scrollerDesc: ScrollingTextView!
    @IBOutlet weak var sistemaLabel: NSTextField!
    @IBOutlet weak var snapPlayer: AVPlayerView!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var juegosTableView: NSTableView!
    @IBOutlet weak var snapShot: NSImageView!
    
    
    var juegos = [String]()
    var juegosXml = [[String]]()
    
    var keyIsDown = false
    
    let contextMenu = NSMenu()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.isHidden = true
        //        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (qEvent) -> NSEvent? in
        //            self.keyUp(with: qEvent)
        //            return qEvent
        //        }
        //
        //        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (qEvent) -> NSEvent? in
        //            self.keyDown(with: qEvent)
        //            return qEvent
        //        }
        //print(view.window?.firstResponder)
        print("LISTA LOAD")
        view.wantsLayer = true
        // change the background color of the layer
        view.layer?.backgroundColor = CGColor(red: 73/255, green: 74/255, blue: 77/255, alpha: 1)
        setupMenu()
        snapShot.wantsLayer = true
        snapShot.layer?.cornerRadius = 10.0
        snapShot.layer?.masksToBounds = true
        snapPlayer.wantsLayer = true
        snapPlayer.layer!.cornerRadius = 10.0
        snapPlayer.layer!.masksToBounds = true
        // Do view setup here.
        
        
        //Cargar nombres de archivos en carpeta dentro de la tabla SIN GAMELIST
        //        for extensiones in systemextensions {
        //
        //
        //            let fileManager = FileManager.default
        //            let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: rompath as String)!
        //            while let element = enumerator.nextObject() as? String {
        //                if element.hasSuffix(extensiones) { // checks the extension
        //                    juegos.append(element)
        //                }
        //            }
        //            juegos.sort()
        //        }
        /// FIN JUEGOS SIN GAMELIST
        
        ///Juegos GAMELIST
        let fileDoesExist = FileManager.default.fileExists(atPath: rompath + "/gamelist.xml")
        print(sistemaActual)
        if fileDoesExist {
            print("HAY XML")
            //juegosGamelist()
            
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
        
        
        
        ///Nombres cargados
        
    }
    func numberOfRows(in juegosTableView: NSTableView) -> Int {
        
        return juegosXml.count
        
    }
    
    func tableView(_ juegosTableview: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let vw = juegosTableview.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        ///AÑADIR JUEGO A LISTA CON GAMELIST
        vw.textField?.stringValue = juegosXml[row][1]
        ///AÑADIR JUEGO A LISTA SIN GAMELIST
        //vw.textField?.stringValue = juegos[row]
        //vw.textField?.font = NSFont(name: "Arial", size: 20)
        
        return vw
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        infoLabel.isHidden = true
        guard juegosTableView.selectedRow != -1 else {return}
        //infoLabel.stringValue = "INFO"
        let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
        imageSelected(path: pathLogo!  )
        
        //        //CARGAR IMAGENES Y VIDEOS
        let miFila = juegosTableView.selectedRow
        let miDesc = String(juegosXml[miFila][2]).replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\t", with: " ")
        let miMap = String(juegosXml[miFila][3])
        let miManual = String(juegosXml[miFila][4])
        let miNews = String(juegosXml[miFila][5])
        let miTittleShot = String(juegosXml[miFila][6])
        let miFanArt = String(juegosXml[miFila][7])
        let miThumbNail = String(juegosXml[miFila][8])
        let miImagen = String(juegosXml[miFila][9])
        let miVideo = String(juegosXml[miFila][10])
        let miMarquee = String(juegosXml[miFila][11])
        let miRelaseDate = String(juegosXml[miFila][12])
        let miDeveloper = String(juegosXml[miFila][13])
        let miPublisher = String(juegosXml[miFila][14])
        let miGenre = String(juegosXml[miFila][15])
        let miLang = String(juegosXml[miFila][16])
        let miPlayers = String(juegosXml[miFila][17])
        let miRating = String(juegosXml[miFila][18])
        let miFav = String(juegosXml[miFila][19])
        let miComando = String(juegosXml[miFila][20])
        let miCore = String(juegosXml[miFila][21])
        let miSystem = String(juegosXml[miFila][22])
        let miBox = String(juegosXml[miFila][23])
        
        dateLabel.stringValue = miRelaseDate
        publisherLabel.stringValue = miPublisher
        developerLabel.stringValue = miDeveloper
        genreLabel.stringValue = miGenre
        playersLabel.stringValue = miPlayers
        //print(miCore)
        //print(miSystem)
        scrollerDesc.font = NSFont(name: "Arial", size: 20)
        scrollerDesc.delay = 1
        scrollerDesc.speed = 2
        scrollerDesc.setup(string: miDesc.replacingOccurrences(of: "\n", with: " "))
        
        
        
        if  miTittleShot != "" {
            let imagenURL = URL(fileURLWithPath: miImagen)
            imageSelected(path: imagenURL)
        } else {
            let imagenURL = URL(fileURLWithPath: miImagen)
            imageSelected(path: imagenURL)
            
        }
        
        if miBox != "" {
            let imagenURL2 = URL(fileURLWithPath: miBox)
            var imagen2 = NSImage(contentsOf: imagenURL2)
            screenshotImage.isHidden = false
            if imagen2 != nil {
                screenshotImage.image = imagen2
            } else {
                screenshotImage.isHidden = true
                let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
                let imagen2  = NSImage(contentsOf: pathLogo!)
                screenshotImage.image = imagen2
            }
        }else {
            let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
            let imagen2  = NSImage(contentsOf: pathLogo!)
            screenshotImage.image = imagen2
            screenshotImage.isHidden = true
        }
        
        if  miMarquee != "" {
            
            let imagenURL2 = URL(fileURLWithPath: miMarquee)
            var imagen2 = NSImage(contentsOf: imagenURL2)
            if imagen2 != nil {
                logoImage.isHidden = false
                logoImage.image = imagen2
            }else{
                let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
                imagen2  = NSImage(contentsOf: pathLogo!)
                logoImage.image = imagen2
                logoImage.isHidden = true
            }
        }else {
            let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
            let imagen2  = NSImage(contentsOf: pathLogo!)
            logoImage.image = imagen2
            logoImage.isHidden = true
        }
        
        if miVideo != nil && miVideo != "" {
            let videoURL = URL(fileURLWithPath: miVideo)
            let player2 = AVPlayer(url: videoURL)
            snapPlayer.player = player2
            snapPlayer.player?.play()
            player2.actionAtItemEnd = .none
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player2.currentItem)
            
            playingVideo = true
        }else{
            let noVideo = Bundle.main.path(forResource: "NoVideo", ofType:"mp4")
            let videoURL = URL(fileURLWithPath: noVideo!)
            let player2 = AVPlayer(url: videoURL)
            snapPlayer.player = player2
            snapPlayer.player?.play()
            player2.actionAtItemEnd = .none
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player2.currentItem)
            playingVideo = true
        }
        if miManual == "" {
            pdfImage.isHidden = true
        }else {
            pdfImage.isHidden = false
        }
        if miFav == "" {
            favImagen.isHidden = true
            contextMenu.items[1].submenu?.items[2].isHidden = true
            contextMenu.items[1].submenu?.items[1].isHidden = false
        }else {
            favImagen.isHidden = false
            contextMenu.items[1].submenu?.items[2].isHidden = false
            contextMenu.items[1].submenu?.items[1].isHidden = true
        }
        scrollDescripText.string = miDesc
        abiertaLista = true
        //print("Tengo Fav:\(miFav)")
        
    }
    
    func imageSelected(path: URL) {
        if path != nil  {
            let imagen = NSImage(contentsOf: path)
            if imagen != nil {
                snapShot.image = imagen
            }
        }
    }
    
    
    
    override func viewDidAppear() {
        ventana = "Lista"
        print("LISTA APPEAR")
        
        
        //        if !self.view.window!.isZoomed{
        //            //self.view.window?.zoom(self)
        //        }
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
        
        self.juegosTableView.becomeFirstResponder()
        
        
        //snapPlayer.layer!.masksToBounds = true
        // *** /FullScreen ***
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        sistemaLabel.stringValue = sistemaActual
    }
    
    override func keyDown(with event: NSEvent) {
        
        if keyIsDown == true {
            return
        }
        keyIsDown = true
        
        
        
        
        
        if event.keyCode == 36  && abiertaLista == true && ventana == "Lista" {
            
            let numero = (juegosTableView.selectedRow)
            let romXml = "\"\(juegosXml[numero][0])\""
            var micomando = rutaApp + juegosXml[numero][20].replacingOccurrences(of: "%CORE%", with: rutaApp)
            //print(micomando.replacingOccurrences(of: "%ROM%", with: romXml))
            var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
            if playingVideo == true {
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
        else if event.keyCode == 51 && abiertaLista == true {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
            }
            print("Backspace")
        }else if event.keyCode == 53 && abiertaLista == true {
            
            //DispatchQueue.global(qos: .utility).async { [unowned self] in
            if sistemaActual != "Favoritos" {
                infoLabel.stringValue = "Buscando Juego..."
                self.buscaJuego()
            }
            
            //self.escrapeartodos()
            //}
        }else if event.keyCode == 49 && abiertaLista == true {
            
        }
        
        if event.keyCode == 124 && abiertaLista == true {
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
        if event.keyCode == 123 && abiertaLista == true {
            if botonactual > 1 {
                print("Izquierda")
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
            
        }
        
        
        
    }
    
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
    
    
    @IBAction func backFunc(_ sender: NSButton) {
        print("ES: \(view.window?.firstResponder)")
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            self.view.window?.contentViewController = controller
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
        }
    }
    
    @objc private func abrirPdf(){
        print("PDF")
        let miFila = juegosTableView.selectedRow
        let miManual = String(juegosXml[miFila][4])
        print(miManual)
        NSWorkspace.shared.openFile(miManual)
    }
    
    @objc private func onItemClicked() {
        let numero = (juegosTableView.selectedRow)
        let romXml = "\"\(juegosXml[numero][0])\""
        var micomando = rutaApp + juegosXml[numero][20].replacingOccurrences(of: "%CORE%", with: rutaApp)
        //print(micomando.replacingOccurrences(of: "%ROM%", with: romXml))
        var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
        if playingVideo == true {
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
    
    func juegosGamelist() {
        var juegosnuevos = 0
        let pathXMLinterno2 = NSURL(string:  "file://" + rompath + "/gamelist.xml")
        if let pathXMLinterno2 = pathXMLinterno2, let data2 = try? Data(contentsOf: pathXMLinterno2 as URL )
        {
            let parser2 = GameParser(data: data2)
            for game in parser2.games
            {
                var datosJuego = [String]()
                let miJuego = siRutaRelativa(ruta: String(game.path))
                let miNombre = String(game.name)
                let miDescripcion = String(game.desc)
                let miMapa = siRutaRelativa(ruta:String(game.map))
                let miManual = siRutaRelativa(ruta:String(game.manual))
                let miNews = siRutaRelativa(ruta:String(game.news))
                let miTittleShot = siRutaRelativa(ruta:String(game.tittleshot))
                let miFanArt = siRutaRelativa(ruta:String(game.fanart))
                let miThumbnail = siRutaRelativa(ruta:String(game.thumbnail))
                let miImage = siRutaRelativa(ruta:String(game.image))
                let miVideo = siRutaRelativa(ruta:String(game.video))
                let miMarquee = siRutaRelativa(ruta:String(game.marquee))
                let miReleaseData = String(game.releasedata)
                let miDeveloper = String(game.developer)
                let miPublisher = String(game.publisher)
                let miGenre = String(game.genre)
                let miLang = String(game.lang)
                let miPlayers = String(game.players)
                let miRating = String(game.rating)
                let miFav = String(game.fav)
                let miBox = String(game.box)
                
                datosJuego = [String(miJuego) , miNombre, miDescripcion, String(miMapa), String(miManual), miNews, String(miTittleShot), String(miFanArt), String(miThumbnail), String(miImage), String(miVideo), String(miMarquee), miReleaseData, miDeveloper, miPublisher, miGenre, miLang, miPlayers, miRating , miFav, miBox ]
                
                juegosXml.append(datosJuego)
                
                
            }
            
        }else{
            print("ERROR GARGANDO gamelist.xml en: \(String(describing: pathXMLinterno2))")
        }
        print("Nuevos: ")
        for extensiones in systemextensions {
            
            
            let fileManager = FileManager.default
            let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: rompath as String)!
            while let element = enumerator.nextObject() as? String {
                if element.hasSuffix(extensiones) { // checks the extension
                    
                    var rutacompleta = rompath + "/" + element
                    var encuentra = false
                    for juego in juegosXml {
                        if juego[0] == rutacompleta {
                            encuentra = true
                            break
                        }else {
                            encuentra = false
                        }
                    }
                    
                    if encuentra == false {
                        juegosnuevos += 1
                        ///AÑADIR FUNCION PARA AÑADIR JUEGO AL XML
                        var datosJuegoNoXml = [String]()
                        datosJuegoNoXml = [rutacompleta , String(element), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ]
                        juegosXml.append(datosJuegoNoXml)
                    }
                    
                }
            }
            
        }
        if juegosnuevos >= 1 {
            xmlJuegosNuevos()
        }
        print("Total: \(juegosXml.count) Juegos en XML")
        juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
        sistemaLabel.stringValue = sistemaActual
        
    }
    
    func siRutaRelativa(ruta: String) -> String {
        var rutaAbsoluta = ""
        if ruta.hasPrefix("./") {
            rutaAbsoluta = rompath + String(String(ruta).dropFirst())
        }else{
            rutaAbsoluta = ruta
        }
        return rutaAbsoluta
    }
    
    func gameListAsString() -> String{
        ///Carga un XML como STRING
        let pathXML = NSURL(string:  "file://" + rompath + "/gamelist.xml")
        var miXML = ""
        if var pathXML = pathXML, let dataS = try? String(contentsOf: pathXML as URL )
        {
            miXML = dataS
        }else{
        }
        return miXML
    }
    
    func cargarImagen (fila: Int) -> String {
        var miImagen = ""
        miImagen = juegosXml[fila][2]
        return miImagen
    }
    
    
    
    func xmlJuegosNuevos(){
        print("Crear XML añadiendo Juegos Nuevos")
        let nuevoGamelist = rompath + "/gamelist.xml"
        let root = XMLElement(name: "gameList")
        let xml = XMLDocument(rootElement: root)
        for juego in juegosXml {
            let gameNode = XMLElement(name: "game")
            root.addChild(gameNode)
            let pathNode = XMLElement(name: "path", stringValue: juego[0])
            let filename = juego[1]
            let name = (filename as NSString).deletingPathExtension
            let nameNode = XMLElement(name: "name", stringValue: name)
            let descNode = XMLElement(name: "desc", stringValue: juego[2])
            let mapNode = XMLElement(name: "map", stringValue: juego[3])
            let manualNode = XMLElement(name: "manual", stringValue: juego[4])
            let newsNode = XMLElement(name: "news",  stringValue: juego[5])
            let tittleshotNode = XMLElement(name: "tittleshot", stringValue: juego[6])
            let fanartNode = XMLElement(name: "fanart", stringValue: juego[7])
            let thumbnailNode = XMLElement(name: "thumbnail", stringValue: juego[8])
            //let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: juego[1]) )
            let imageNode = XMLElement(name: "image", stringValue: juego[9] )
            //let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: juego[1]) )
            let videoNode = XMLElement(name: "video", stringValue: juego[10] )
            let marqueeNode = XMLElement(name: "marquee", stringValue: juego[11])
            let releasedateNode = XMLElement(name: "releasedate",  stringValue: juego[12])
            let developerNode = XMLElement(name: "developer", stringValue: juego[13])
            let publisherNode = XMLElement(name: "publisher", stringValue: juego[14])
            let genreNode = XMLElement(name: "genre", stringValue: juego[15])
            let langNode = XMLElement(name: "lang", stringValue: juego[16])
            let playersNode = XMLElement(name: "players", stringValue: juego[17])
            let ratingNode = XMLElement(name: "rating", stringValue: juego[18])
            let favNode = XMLElement(name: "fav", stringValue: juego[19])
            let boxNode = XMLElement(name: "box", stringValue: juego[23])
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
        let xmlData = xml.xmlData(options: .nodePrettyPrint)
        
        print("TOTAL: \(juegosXml.count) Juegos en Total")
        do{
            try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
        }catch {}
    }
    
    @objc func buscaJuego(){
        if playingVideo == true {
            snapPlayer.player?.pause()
        }
        infoLabel.isHidden = false
        escrapeandoSistema = false
        juegosTableView.isEnabled = false
        print("Escrapeo - 1")
        infoLabel.stringValue = "Buscando Juego..."
        //mkdir -p foo
        var rutaacrear = rompath + "/media"
        var comando = "mkdir -p \(rutaacrear)"
        Commands.Bash.system("\(comando)")
        var misystemid = String()
        for sistema in systemsIds {
            
            if sistema[0] == nombresistemaactual {
                misystemid = sistema[1]
                break
            }
        }
        
        let defaults = UserDefaults.standard
        let SSUser = defaults.string(forKey: "SSUser") ?? ""
        let SSPassword = defaults.string(forKey: "SSPassword") ?? ""
        let numero = (juegosTableView.selectedRow)
        var nombre = ""
        var miputonombre = ""
        //Si el sistema es MAME
        if misystemid == "75" {
            
            var juegoMame = juegosXml[numero][1]
            if juegoMame.contains("/") {
                let index2 = juegoMame.range(of: "/", options: .backwards)?.lowerBound
                let substring2 = juegoMame.substring(from: index2! )
                let result1 = String(substring2.dropFirst())
                juegoMame = result1
                print("JUEGO /: \(juegoMame)")
            }
            for juego in titulosMame {
                print("Tengo: \(juego[0])")
                if juego[0] == juegoMame {
                    print("EL JUEGO: \(juego[0])")
                    nombre = juego[1]
                    break
                }
            }
        }else {
            nombre = juegosXml[numero][1]
        }
        
        //
        
        if nombre.contains("/") {
            let index2 = nombre.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = nombre.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            nombre = result1
            print("NOMBRE CON /: \(nombre)")
        }
        nombre = nombre.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s?\\[[\\w\\s]*\\]", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s(\\[.+\\]|\\(.+\\))", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s?\\[[\\w\\s]*\\]", with: "", options: .regularExpression)
        miputonombre = nombre
        if miputonombre.contains("/") {
            let index3 = miputonombre.range(of: "/", options: .backwards)?.lowerBound
            let substring3 = miputonombre.substring(from: index3! )
            let result2 = String(substring3.dropFirst())
            miputonombre = result2
            print("NOMBRE CON /: \(miputonombre)")
        }
        miputonombre = miputonombre.trimmingCharacters(in: .whitespaces)
        nombre = nombre.replacingOccurrences(of: ".", with: "")
        
        nombre = nombre.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var nombreplano = juegosXml[numero][1].replacingOccurrences(of: " ", with: "")
        
        var miId = String()
        var idSistema = String()
        let datasource = "https://www.screenscraper.fr/api2/jeuRecherche.php?devid=" + userDev + "&devpassword=" + userpass + "&softname=RetroMac&output=json&ssid=\(SSUser)&sspassword=\(SSPassword)&systemeid=\(misystemid)&recherche=\(nombre)"
        print(datasource)
        print(nombre)
        print(miputonombre)
        print(nombreplano)
        DispatchQueue.background(background: {
            // do something in background
            guard let url = URL(string: datasource) else {
                return
            }
            guard let data = try? String(contentsOf: url) else {
                DispatchQueue.main.sync {
                    abiertaLista = true
                    self.juegosTableView.isEnabled = true
                    self.infoLabel.stringValue = "ERROR de conexión"
                    self.view.window?.makeFirstResponder(self.juegosTableView)
                    
                }
                return
            }
            
            
            var feed: JSON?
            let newFeed = JSON(parseJSON: data)
            feed = newFeed
            var encontrada = false
            //print(miputonombre)
            for (index,subJson):(String, JSON) in feed! {
                
                if index == "response" {
                    for (node, object):(String, JSON) in subJson {
                        
                        if node == "jeux" {
                            
                            for (tercero, subsubJson):(String, JSON) in object{
                                //print(subsubJson["id"].stringValue)
                                
                                let cuantos = Int(subsubJson["noms"].count)
                                if cuantos > 0 {
                                    for i in 0...cuantos - 1 {
                                        var nombreEncontrado = subsubJson["noms"][i]["text"].rawString()!
                                        print("Encuentro: \(nombreEncontrado)")
                                        print("Buscaba: \(miputonombre)")
                                        
                                        if miputonombre.caseInsensitiveCompare(nombreEncontrado) == ComparisonResult.orderedSame {
                                            print("COJONUDO")
                                            miId = subsubJson["id"].stringValue
                                            encontrada = true
                                            break
                                        }
                                        if nombreEncontrado == miputonombre {
                                            
                                        }
                                    }
                                }
                                
                                
                                
                                //                                if ((subsubJson["noms"].rawString())?.contains(miputonombre))! {
                                //                                    print("EUREKA")
                                //
                                //                                }
                            }
                        }
                        if encontrada == true {break}
                    }
                }
                if encontrada == true {break}
            }
            if nombreplano.contains("/") {
                let index2 = nombreplano.range(of: "/", options: .backwards)?.lowerBound
                let substring2 = nombreplano.substring(from: index2! )
                let result1 = String(substring2.dropFirst())
                nombreplano = result1
            }
            if miId != ""{
                print("ID: \(miId)")
                //DispatchQueue.main.sync {
                print(idSistema)
                
                DispatchQueue.main.sync {
                    self.infoLabel.stringValue = "Juego ENCONTRADO, escrapeando..."
                    self.scrapearJuego(juego: miId, sistema: misystemid, nombrejuego: nombreplano, filajuego: numero)
                }
                
                
                //}
                
            }else{
                print("Juego no encontrado")
                DispatchQueue.main.sync {
                    self.infoLabel.stringValue = "Juego no encontrado"
                    abiertaLista = true
                    self.juegosTableView.isEnabled = true
                    self.view.window?.makeFirstResponder(self.juegosTableView)
                }
                
                
            }
        }, completion:{
            
            // when background job finished, do something in main thread
        })
        
        
        
    }
    
    func habilitarTabla (){
        abiertaLista = true
        self.juegosTableView.isEnabled = true
        self.view.window?.makeFirstResponder(self.juegosTableView)
        self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
        
        
    }
    func habilitarTabla2 (){
        abiertaLista = true
        backButton.isEnabled = true
        self.juegosTableView.isEnabled = true
        self.view.window?.makeFirstResponder(self.juegosTableView)
        self.infoLabel.stringValue = "SISTEMA ESCRAPEADO"
    }
    
    @objc func scrapearJuego (juego: String, sistema: String, nombrejuego: String, filajuego: Int){
        print("Escrapeo - 2")
        var cuenta = 0
        var mifeed: JSON?
        let defaults = UserDefaults.standard
        let SSuser = defaults.string(forKey: "SSUser") ?? ""
        let SSPassword = defaults.string(forKey: "SSPassword") ?? ""
        let datasource = "https://www.screenscraper.fr/api2/jeuInfos.php?devid=\(userDev)&devpassword=\(userpass)&softname=RetroMac&output=json&ssid=\(SSuser)&sspassword=\(SSPassword)&gameid=\(juego)"
        
        var descJuego = ""
        var playersJuego = ""
        var generoJuego = ""
        var desarroladorJuego = ""
        var screenshotJuego = ""
        var videoJuego = ""
        var manualJuego = ""
        var fanartJuego = ""
        var fechaJuego = ""
        var editorJuego = ""
        var tittleshotJuego = ""
        var marqueeJuego = ""
        var sistemaJuegoSS = ""
        var logoJuego = ""
        var box2dJuego = ""
        var box3dJuego = ""
        
        //DispatchQueue.global(qos: .background).async {
        // do your job here
        DispatchQueue.background(background: {
            // do something in background
            guard let url = URL(string: datasource) else {
                
                return
                
            }
            
            guard let data = try? String(contentsOf: url) else {
                
                return
            }
            let newFeed = JSON(parseJSON: data)
            mifeed = newFeed
        }, completion:{
            for (index,subJson):(String, JSON) in mifeed! {
                if index == "response" {
                    for (index2,subJson2):(String, JSON) in subJson{
                        if index2 == "jeu" {
                            for (index3, sJson):(String, JSON) in subJson2 {
                                //print(index3 + "-> \(sJson)")
                                for (index4, sJson2):(String, JSON) in sJson{
                                    //print (index3 + "-> \(index4) ->\(sJson2)")
                                    if index3 == "developpeur" && index4 == "text" {
                                        desarroladorJuego = sJson2.stringValue
                                        //print("Desarrrolador: " + desarroladorJuego)
                                    }
                                    if index3 == "joueurs" && index4 == "text" {
                                        playersJuego = sJson2.stringValue
                                        //print("Jugadores: " + playersJuego)
                                    }
                                    if index3 == "editeur" && index4 == "text" {
                                        editorJuego = sJson2.stringValue
                                        //print("Editor: " + editorJuego)
                                    }
                                    if index3 == "genres" {
                                        for (index5, sJson3):(String, JSON) in sJson2 {
                                            //print (index5 + " -> \(sJson3)")
                                            for (index6, sJson4):(String, JSON) in sJson3 {
                                                //print (index5 + "-> \(index6) -> \(sJson4)")
                                                if sJson4["langue"].stringValue == "es" {
                                                    //print("Genero: " + sJson4["text"].stringValue)
                                                    generoJuego = sJson4["text"].stringValue
                                                }
                                            }
                                        }
                                    }
                                    if index3 == "synopsis" {
                                        var encuentrame = false
                                        for (index5, sJson3):(String, JSON) in sJson {
                                            
                                            if sJson3["langue"].stringValue == "es" {
                                                descJuego = sJson3["text"].stringValue.replacingOccurrences(of: "\n", with: " ")
                                                //print("Descripcion: \(descJuego)")
                                                encuentrame = true
                                            }
                                            if encuentrame == true{
                                                break
                                            }
                                            
                                        }
                                        if encuentrame == true{
                                            break
                                        }
                                    }
                                    if index3 == "dates" {
                                        var encuentra = false
                                        for (index5, sJson3):(String, JSON) in sJson {
                                            
                                            if sJson3["region"].stringValue != "jp" {
                                                fechaJuego = sJson3["text"].stringValue
                                                print("Fecha: \(fechaJuego)")
                                                encuentra = true
                                            }else if sJson3["region"].stringValue == "jp" {
                                                fechaJuego = sJson3["text"].stringValue
                                                print("Fecha: \(fechaJuego)")
                                                encuentra = true
                                            }
                                            if encuentra == true{
                                                break
                                            }
                                        }
                                        if encuentra == true{
                                            break
                                        }
                                    }
                                    ///Buscar la plataforma interna del juego en SS
                                    if index3 == "systeme" {
                                        var encuentra = false
                                        for (index5, sJson3):(String, JSON) in sJson {
                                            if index5 == "id" {
                                                sistemaJuegoSS = sJson3.stringValue
                                                //print(sistemaJuegoSS)
                                                encuentra = true
                                                
                                            }
                                            //sistemaJuegoSS = sJson3["id"].stringValue
                                            //print(index5)
                                            //encuentra = true
                                            
                                            if encuentra == true{
                                                break
                                            }
                                        }
                                        if encuentra == true{
                                            break
                                        }
                                    }
                                    ///
                                    if index3 == "medias" {
                                        var encuentrass = false
                                        for (index5, sJson3):(String, JSON) in sJson {
                                            
                                            
                                            if sJson3["type"].stringValue == "ss" {
                                                screenshotJuego = sJson3["url"].stringValue
                                                //print("Screenshot: \(screenshotJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "video" {
                                                videoJuego = sJson3["url"].stringValue
                                                //print("Video: \(videoJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "fanart" {
                                                fanartJuego = sJson3["url"].stringValue
                                                //print("Fanart: \(fanartJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "sstitle" {
                                                tittleshotJuego = sJson3["url"].stringValue
                                                //print("TittleShot: \(tittleshotJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "screenmarquee" {
                                                marqueeJuego = sJson3["url"].stringValue
                                                //print("Marquee: \(marqueeJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "manuel" && sJson3["region"].stringValue == "us"{
                                                manualJuego = sJson3["url"].stringValue
                                                //print("Manual: \(manualJuego)")
                                                
                                                
                                            }
                                            if sJson3["type"].stringValue == "wheel" && (sJson3["region"] == "us" || sJson3["region"] == "eu" || sJson3["region"] == "wor") {
                                                logoJuego = sJson3["url"].stringValue
                                                //print("MINIMarquee: \(miniMarqueeJuego)")
                                                
                                            }else if sJson3["type"].stringValue == "wheel" && sJson3["region"] == "jp" {
                                                
                                                logoJuego = sJson3["url"].stringValue
                                                //print("MINIMarquee: \(miniMarqueeJuego)")
                                            }
                                            
                                            if sJson3["type"].stringValue == ("box-2D") && (sJson3["region"] == "us" || sJson3["region"] == "eu" || sJson3["region"] == "ss"){
                                                box2dJuego = sJson3["url"].stringValue
                                                //print("MINIMarquee: \(miniMarqueeJuego)")
                                                print("3d: \(box2dJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == ("box-3D") && (sJson3["region"] == "us" || sJson3["region"] == "eu" || sJson3["region"] == "ss"){
                                                box3dJuego = sJson3["url"].stringValue
                                                print("3d: \(box3dJuego)")
                                                encuentrass = true
                                            }
                                            
                                            if encuentrass == true{
                                                break
                                            }
                                        }
                                        if encuentrass == true{
                                            break
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
            var marqueeDescarga = ""
            if logoJuego == "" {
                marqueeDescarga = marqueeJuego
            }else {
                marqueeDescarga = logoJuego
                print("TIENE LOGO")
            }
            var boxDescarga = ""
            
            if box3dJuego == "" {
                boxDescarga = box2dJuego
                print("TIENE 2D")
            }else {
                boxDescarga = box3dJuego
                print("TIENE 3D")
            }
            
            
            
            if screenshotJuego != "" {
                cuenta += 1
            }
            if videoJuego != "" {
                cuenta += 1
            }
            if fanartJuego != "" {
                cuenta += 1
            }
            if tittleshotJuego != "" {
                cuenta += 1
            }
            
            if manualJuego != "" {
                cuenta += 1
            }
            if marqueeDescarga != "" {
                cuenta += 1
            }
            if boxDescarga != "" {
                cuenta += 1
            }
            
            print("El juego tiene \(cuenta) medias")
            
            var cuentadescarga = 0
            
            //DispatchQueue.global(qos: .background).async {
            DispatchQueue.background(delay: 0.0, background: {
                ///ScreenShot
                if screenshotJuego != "" {
                    //self.descargaMedia(tipo: "png", url: screenshotJuego, nombre: nombrejuego)
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego).\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: screenshotJuego)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                
                ///Video
                ///self.descargaMedia(tipo: "mp4", url: videoJuego, nombre: nombrejuego)
                if videoJuego != "" {
                    ///https://https://www.screenscraper.fr/medias/147/150935/video.mp4
                    //var kk = "https://www.screenscraper.fr/api2/mediaVideoJeu.php?devid=\(userDev)&devpassword=\(userpass)&softname=RetroMac&ssid=\(SSuser)&sspassword=\(SSPassword)&systemeid=\(sistemaJuegoSS)&jeuid=\(juego)&media=video"
                    
                    //let videoURL = "https://www.screenscraper.fr/medias/\(sistemaJuegoSS)/\(juego)/video.mp4"
                    //print(videoURL)
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego).\("mp4")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: videoJuego)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                ///MANUAL
                
                if manualJuego != "" {
                    //self.descargaMedia(tipo: "pdf", url: manualJuego, nombre: nombrejuego)
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego).\("pdf")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: manualJuego)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                ///FanArt
                if fanartJuego != "" {
                    //self.descargaMedia(tipo: "png", url: fanartJuego, nombre: nombrejuego + "_fanart")
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)_fanart.\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: fanartJuego)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                //TittleShot
                if tittleshotJuego != "" {
                    //self.descargaMedia(tipo: "png", url: tittleshotJuego, nombre: nombrejuego + "_tittleshot")
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)_tittleshot.\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: tittleshotJuego)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                ///MARQUEE
                
                
                if marqueeDescarga != "" {
                    
                    //self.descargaMedia(tipo: "png", url: marqueeJuego, nombre: nombrejuego + "_marquee")
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)_marquee.\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: marqueeDescarga)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                
                //BOX
                
                
                
                if boxDescarga != "" {
                    
                    //self.descargaMedia(tipo: "png", url: marqueeJuego, nombre: nombrejuego + "_marquee")
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)_box.\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: boxDescarga)
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    
                    let request = URLRequest(url:fileURL!)
                    print(request)
                    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                        if let tempLocalUrl = tempLocalUrl, error == nil {
                            // Success
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                print("Successfully downloaded. Status code: \(statusCode)")
                            }
                            
                            do {
                                try? FileManager.default.removeItem(at: destinationFileUrl!)
                                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl!)
                                DispatchQueue.main.sync {
                                    cuentadescarga += 1
                                    
                                    if cuentadescarga == cuenta {
                                        if escrapeandoSistema == false {
                                            self.habilitarTabla()
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == Double(self.juegosXml.count){
                                                self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(self.juegosXml.count)"
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            } catch (let writeError) {
                                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                            }
                            
                        } else {
                            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                        }
                    }
                    task.resume()
                }
                
                // do something in background
            }, completion:{
                ///ACTUALIZAR EL ARRAY DE JUEGOS
                self.juegosXml[filajuego][2] = descJuego.replacingOccurrences(of: "\n", with: " ")
                self.juegosXml[filajuego][3] = self.juegosXml[filajuego][3]
                if manualJuego != "" {
                    self.juegosXml[filajuego][4] = rompath + "/media/" + nombrejuego + ".pdf"
                }else {
                    
                    self.juegosXml[filajuego][4] = ""
                }
                self.juegosXml[filajuego][5] = self.juegosXml[filajuego][5]
                if tittleshotJuego != "" {
                    self.juegosXml[filajuego][6] = rompath + "/media/"  + nombrejuego + "_tittleshot.png"
                }else {
                    self.juegosXml[filajuego][6] = ""
                }
                if fanartJuego != "" {
                    self.juegosXml[filajuego][7] = rompath + "/media/"  + nombrejuego + "_fanart.png"
                }else {
                    self.juegosXml[filajuego][7] = ""
                }
                if screenshotJuego != "" {
                    self.juegosXml[filajuego][8] = rompath + "/media/" + nombrejuego + ".png"
                    self.juegosXml[filajuego][9] = rompath + "/media/"  + nombrejuego + ".png"
                } else {
                    self.juegosXml[filajuego][8] = ""
                    self.juegosXml[filajuego][9] = ""
                }
                if videoJuego != "" {
                    self.juegosXml[filajuego][10] = rompath + "/media/" + nombrejuego + ".mp4"
                } else {
                    self.juegosXml[filajuego][10] = ""
                }
                if marqueeJuego != "" {
                    self.juegosXml[filajuego][11] = rompath + "/media/"  + nombrejuego + "_marquee.png"
                } else {
                    self.juegosXml[filajuego][11] = ""
                }
                
                self.juegosXml[filajuego][12] = fechaJuego
                self.juegosXml[filajuego][13] = desarroladorJuego
                self.juegosXml[filajuego][14] = desarroladorJuego
                self.juegosXml[filajuego][15] = generoJuego
                self.juegosXml[filajuego][16] = self.juegosXml[filajuego][16]
                self.juegosXml[filajuego][17] = playersJuego
                self.juegosXml[filajuego][18] = self.juegosXml[filajuego][18]
                self.juegosXml[filajuego][19] = self.juegosXml[filajuego][19]
                self.juegosXml[filajuego][23] = rompath + "/media/"  + nombrejuego + "_box.png"
                self.xmlJuegosNuevos()
                //DispatchQueue.main.sync {}
                
                
                let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
                let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == self.juegosXml[filajuego][0]})
                
                
                allTheGames[mifila!].games[mifilaJuego!].description = self.juegosXml[filajuego][2]
                allTheGames[mifila!].games[mifilaJuego!].map = self.juegosXml[filajuego][3]
                allTheGames[mifila!].games[mifilaJuego!].manual = self.juegosXml[filajuego][4]
                allTheGames[mifila!].games[mifilaJuego!].tittleshot = self.juegosXml[filajuego][6]
                allTheGames[mifila!].games[mifilaJuego!].fanart = self.juegosXml[filajuego][7]
                allTheGames[mifila!].games[mifilaJuego!].thumbnail = self.juegosXml[filajuego][8]
                allTheGames[mifila!].games[mifilaJuego!].image = self.juegosXml[filajuego][9]
                allTheGames[mifila!].games[mifilaJuego!].video = self.juegosXml[filajuego][10]
                allTheGames[mifila!].games[mifilaJuego!].marquee = self.juegosXml[filajuego][11]
                allTheGames[mifila!].games[mifilaJuego!].releasedate = self.juegosXml[filajuego][12]
                allTheGames[mifila!].games[mifilaJuego!].developer = self.juegosXml[filajuego][13]
                allTheGames[mifila!].games[mifilaJuego!].publisher = self.juegosXml[filajuego][14]
                allTheGames[mifila!].games[mifilaJuego!].genre = self.juegosXml[filajuego][15]
                allTheGames[mifila!].games[mifilaJuego!].lang = self.juegosXml[filajuego][16]
                allTheGames[mifila!].games[mifilaJuego!].players = self.juegosXml[filajuego][17]
                allTheGames[mifila!].games[mifilaJuego!].rating = self.juegosXml[filajuego][18]
                allTheGames[mifila!].games[mifilaJuego!].fav = self.juegosXml[filajuego][19]
                allTheGames[mifila!].games[mifilaJuego!].box = self.juegosXml[filajuego][23]
                
                
                // Movemos fila para actualizar
                
                
                
                //                let indexSet = NSIndexSet(index: (self.juegosTableView.selectedRow + -1))
                //                let indexSet2 = NSIndexSet(index: self.juegosTableView.selectedRow )
                //                self.juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
                //                self.juegosTableView.selectRowIndexes(indexSet2 as IndexSet, byExtendingSelection: false)
                //                self.infoLabel.stringValue = "Juego ESCRAPEADO!!"
                // when background job finished, do something in main thread
            })
            
            
            //}
            
            
            //}
            // when background job finished, do something in main thread
        })
        
        
        
        
        //}
        
        
        
        
        
        
    }
    
    
    
    func buscaJuegoS(numerojuego: Int){
        if playingVideo == true {
            snapPlayer.player?.pause()
        }
        
        print("Escrapeo - 1")
        abiertaLista = false
        DispatchQueue.main.sync {
            self.juegosTableView.isEnabled = false
            self.infoLabel.isHidden = false
        }
        
        escrapeandoSistema = true
        //mkdir -p foo
        var rutaacrear = rompath + "/media"
        var comando = "mkdir -p \(rutaacrear)"
        Commands.Bash.system("\(comando)")
        var misystemid = String()
        for sistema in systemsIds {
            
            if sistema[0] == nombresistemaactual {
                misystemid = sistema[1]
                break
            }
        }
        juegosaescrapearensistema = juegosXml.count
        
        let defaults = UserDefaults.standard
        let SSUser = defaults.string(forKey: "SSUser") ?? ""
        let SSPassword = defaults.string(forKey: "SSPassword") ?? ""
        let numero = numerojuego
        var nombre = ""
        var miputonombre = ""
        //Si el sistema es MAME
        if misystemid == "75" {
            
            var juegoMame = juegosXml[numero][1]
            if juegoMame.contains("/") {
                let index2 = juegoMame.range(of: "/", options: .backwards)?.lowerBound
                let substring2 = juegoMame.substring(from: index2! )
                let result1 = String(substring2.dropFirst())
                juegoMame = result1
                print("JUEGO /: \(juegoMame)")
            }
            for juego in titulosMame {
                print("Tengo: \(juego[0])")
                if juego[0] == juegoMame {
                    print("EL JUEGO: \(juego[0])")
                    nombre = juego[1]
                    break
                }
            }
        }else {
            nombre = juegosXml[numero][1]
        }
        //nombre = juegosXml[numerojuego][1]
        if nombre.contains("/") {
            let index2 = nombre.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = nombre.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            nombre = result1
            print("NOMBRE CON /: \(nombre)")
        }
        nombre = nombre.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s?\\[[\\w\\s]*\\]", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s(\\[.+\\]|\\(.+\\))", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: "\\s?\\[[\\w\\s]*\\]", with: "", options: .regularExpression)
        nombre = nombre.replacingOccurrences(of: ".", with: "")
        miputonombre = nombre
        nombre = nombre.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var nombreplano = juegosXml[numerojuego][1].replacingOccurrences(of: " ", with: "")
        
        var miId = String()
        var idSistema = String()
        let datasource = "https://www.screenscraper.fr/api2/jeuRecherche.php?devid=" + userDev + "&devpassword=" + userpass + "&softname=RetroMac&output=json&ssid=\(SSUser)&sspassword=\(SSPassword)&systemeid=\(misystemid)&recherche=\(nombre)"
        print(datasource)
        
        // do your job here
        guard let url = URL(string: datasource) else {
            
            return
            
        }
        guard let data = try? String(contentsOf: url) else {
            DispatchQueue.main.sync {
                abiertaLista = true
                self.juegosTableView.isEnabled = true
                self.infoLabel.stringValue = "ERROR de conexión"
                self.view.window?.makeFirstResponder(self.juegosTableView)
                
            }
            return
        }
        
        
        var feed: JSON?
        let newFeed = JSON(parseJSON: data)
        feed = newFeed
        var encontrada = false
        //print(miputonombre)
        for (index,subJson):(String, JSON) in feed! {
            
            if index == "response" {
                for (node, object):(String, JSON) in subJson {
                    
                    if node == "jeux" {
                        
                        for (tercero, subsubJson):(String, JSON) in object{
                            //print(subsubJson["id"].stringValue)
                            let cuantos = Int(subsubJson["noms"].count)
                            if cuantos > 0 {
                                for i in 0...cuantos - 1 {
                                    var nombreEncontrado = subsubJson["noms"][i]["text"].rawString()!
                                    print("Encuentro: \(nombreEncontrado)")
                                    print("Buscaba: \(miputonombre)")
                                    
                                    if miputonombre.caseInsensitiveCompare(nombreEncontrado) == ComparisonResult.orderedSame {
                                        print("COJONUDO")
                                        miId = subsubJson["id"].stringValue
                                        encontrada = true
                                        break
                                    }
                                    if nombreEncontrado == miputonombre {
                                        
                                    }
                                }
                            }
                        }
                    }
                    if encontrada == true {break}
                }
            }
            if encontrada == true {break}
        }
        if nombreplano.contains("/") {
            let index2 = nombreplano.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = nombreplano.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            nombreplano = result1
        }
        if miId != ""{
            juesgosEscrapeados += 1
            print("ID: \(miId)")
            
            print(idSistema)
            if idSistema != "" {
                self.scrapearJuego(juego: miId, sistema: idSistema, nombrejuego: nombreplano, filajuego: numerojuego)
                
            } else {
                self.scrapearJuego(juego: miId, sistema: misystemid, nombrejuego: nombreplano, filajuego: numerojuego)
                
            }
            
            
            
        }else{
            print("Juego no encontrado")
            
            self.infoLabel.stringValue = "Juego no encontrado"
            juesgosEscrapeados += 1
            if escrapeandoSistema == false {
                habilitarTabla()
            }
            
        }
        
        
        
        
    }
    
    @objc func escrapeartodos(){
        barraProgress.minValue = 0
        barraProgress.maxValue = Double(juegosXml.count)
        backButton.isEnabled = false
        abiertaLista = false
        juegosTableView.isEnabled = false
        self.infoLabel.stringValue = "ESCRAPEANDO \(juegosXml.count) JUEGOS"
        DispatchQueue.background(delay: 0.0, background: {
            self.juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
            let kk = self.juegosXml.count
            for a in 0..<kk {
                self.buscaJuegoS(numerojuego: a)
                
                if a == (kk - 1) {
                    abiertaLista = true
                    //                    self.backButton.isEnabled = true
                    //                    self.juegosTableView.isEnabled = true
                    //                    self.juegosTableView.becomeFirstResponder()
                    //                    self.juegosTableView.cell?.performClick((Any).self)
                }else{
                    abiertaLista = false
                }
            }
            //            for (index, juego)  in self.juegosXml.enumerated() {
            //
            //                //print(index)
            //            }
            //self.infoLabel.stringValue = "** JUEGOS ESCRAPEADOS **"
        })
        
        
    }
    
    func crearItemsMenu() -> [NSMenuItem]{
        
        ///Menu ITEMS de Scrapear
        
        var arrayMenu = [NSMenuItem]()
        
        let scrapGame = NSMenuItem(title: "Scrapear Juego", action: #selector(buscaJuego), keyEquivalent: "")
        let scrapSystem = NSMenuItem(title: "Scrapear Sistema (Experimental)", action: #selector(escrapeartodos), keyEquivalent: "")
        let scrapAll = NSMenuItem(title: "Scrapear Todos los Sistemas", action: nil, keyEquivalent: "")
        let scrapSubmenu = NSMenu()
        scrapSubmenu.addItem(scrapGame)
        scrapSubmenu.addItem(scrapSystem)
        scrapSubmenu.addItem(scrapAll)
        let scrapItem = NSMenuItem(title: "Scrapear", action: nil, keyEquivalent: "")
        if sistemaActual != "Favoritos" {
            scrapItem.submenu = scrapSubmenu
        }
        
        
        /// Menu ITEMS de Juego
        
        let renameGame = NSMenuItem(title: "Cambiar Nombre del Juego", action: #selector(enableBoxEditar), keyEquivalent: "")
        let favGame = NSMenuItem(title: "Añadir Juego a Favoritos", action: #selector(favGames), keyEquivalent: "")
        let unfavGame = NSMenuItem(title: "Eliminar Juego de Favoritos", action: #selector(unfavGames), keyEquivalent: "")
        let searchGame = NSMenuItem(title: "Buscar Juego", action: nil, keyEquivalent: "")
        let delGame = NSMenuItem(title: "Borrar Juego", action: #selector(EnableBoxBorrar), keyEquivalent: "")
        
        let gameSubmenu = NSMenu()
        
        gameSubmenu.addItem(renameGame)
        gameSubmenu.addItem(favGame)
        gameSubmenu.addItem(unfavGame)
        gameSubmenu.addItem(searchGame)
        gameSubmenu.addItem(delGame)
        
        let gameItem = NSMenuItem(title: "Juego", action: nil, keyEquivalent: "")
        //if sistemaActual != "Favoritos" {
        gameItem.submenu = gameSubmenu
        //}
        
        /// Menu ITEMS de sistema
        
        let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController
        let button = controller!.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
        
        var cuentaCores = button?.cores?.count
        let sistemaItem = NSMenuItem(title: "Cores del Sistema", action: nil, keyEquivalent: "")
        if button?.cores != nil {
            
            let cambiarItem = NSMenuItem(title: "Cambiar Core", action: nil, keyEquivalent: "")
            let misCores = button?.cores
            
            let coreSubmenu = NSMenu()
            for a in 0..<cuentaCores! {
                
                var core = misCores![a][1]
                var tooltip = misCores![a][2]
                var comando: String =  (button?.Comando)!
                if comando.contains(core) {
                    core = core + "✔️"
                }
                
                let coreItem = NSMenuItem(title: core, action: #selector(coresistema), keyEquivalent: "")
                coreItem.toolTip = tooltip
                coreSubmenu.addItem(coreItem)
            }
            cambiarItem.submenu = coreSubmenu
            sistemaItem.submenu = coreSubmenu
            
        }
        
        arrayMenu.append(scrapItem)
        arrayMenu.append(gameItem)
        
        if button?.cores != nil {
            if button?.cores?.count ?? 0 > 1 {
                arrayMenu.append(sistemaItem)
            }
            
        }
        
        
        return arrayMenu
    }
    
    func setupMenu() {
        
        let items = crearItemsMenu()
        items.forEach {contextMenu.addItem($0)}
        self.view.menu = contextMenu
    }
    
    @objc func EnableBoxBorrar () {
        //juegosTableView.isEnabled = false
        abiertaLista = false
        borrarBox.isHidden = false
        var mijuego = juegosXml[juegosTableView.selectedRow][1]
        borrarLabel.stringValue = "⚠️⚠️¿Estás seguro de borrar el juego \(mijuego) de tu DISCO DURO??⚠️⚠️🤔"
        
    }
    
    @objc func enableBoxEditar(){
        abiertaLista = false
        editarBox.isHidden = false
        tituloTextField.stringValue = juegosXml[juegosTableView.selectedRow][1]
    }
    
    @objc func favGames(){
        let mifila = juegosTableView.selectedRow
        juegosXml[mifila][19] = "FAV"
        let mifilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
        allTheGames[mifilaAll!].games[mifilaJuego!].fav = "FAV"
        xmlJuegosNuevos()
        let miJuego = juegosXml[juegosTableView.selectedRow][0]
        let miNombre = juegosXml[juegosTableView.selectedRow][1]
        let miDescripcion = juegosXml[juegosTableView.selectedRow][2]
        let miMapa = juegosXml[juegosTableView.selectedRow][3]
        let miManual = juegosXml[juegosTableView.selectedRow][4]
        let miNews = juegosXml[juegosTableView.selectedRow][5]
        let miTittleShot = juegosXml[juegosTableView.selectedRow][6]
        let miFanArt = juegosXml[juegosTableView.selectedRow][7]
        let miThumbnail = juegosXml[juegosTableView.selectedRow][8]
        let miImage = juegosXml[juegosTableView.selectedRow][9]
        let miVideo = juegosXml[juegosTableView.selectedRow][10]
        let miMarquee = juegosXml[juegosTableView.selectedRow][11]
        let miReleaseData = juegosXml[juegosTableView.selectedRow][12]
        let miDeveloper = juegosXml[juegosTableView.selectedRow][13]
        let miPublisher = juegosXml[juegosTableView.selectedRow][14]
        let miGenre = juegosXml[juegosTableView.selectedRow][15]
        let miLang = juegosXml[juegosTableView.selectedRow][16]
        let miPlayers = juegosXml[juegosTableView.selectedRow][17]
        let miRating = juegosXml[juegosTableView.selectedRow][18]
        let miFav = juegosXml[juegosTableView.selectedRow][19]
        let miComando = juegosXml[juegosTableView.selectedRow][20]
        let miCore = juegosXml[juegosTableView.selectedRow][21]
        let miSystem = juegosXml[juegosTableView.selectedRow][22]
        let miBox = juegosXml[juegosTableView.selectedRow][23]
        //Actualizar aaray de favoritos
        
        var datosDeMiJuego: Juego = Juego(path: String(miJuego), name: miNombre, description: miDescripcion, map: String(miMapa), manual: String(miManual), news: miNews, tittleshot: String(miTittleShot), fanart: String(miFanArt), thumbnail: String(miThumbnail), image: String(miImage), video: String(miVideo), marquee: String(miMarquee), releasedate: miReleaseData, developer: miDeveloper, publisher: miPublisher, genre: miGenre, lang: miLang, players: miPlayers, rating: miRating, fav: miFav, comando: miComando, core: miCore, system: miSystem, box: miBox)
        
        let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
        
        allTheGames[mifilafav!].games.append(datosDeMiJuego)
        favImagen.isHidden = false
        contextMenu.items[1].submenu?.items[2].isHidden = false
        contextMenu.items[1].submenu?.items[1].isHidden = true
        
    }
    
    @objc func unfavGames(){
        if sistemaActual != "Favoritos" {
            let mifila = juegosTableView.selectedRow
            juegosXml[mifila][19] = ""
            let mifilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
            let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
            allTheGames[mifilaAll!].games[mifilaJuego!].fav = ""
            let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
            let miJuegoFav = allTheGames[mifilafav!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
            allTheGames[mifilafav!].games.remove(at: miJuegoFav!)
            xmlJuegosNuevos()
            favImagen.isHidden = true
            contextMenu.items[1].submenu?.items[2].isHidden = true
            contextMenu.items[1].submenu?.items[1].isHidden = false
        }else {
            
            let mifila = juegosTableView.selectedRow
            var miarray = [[String]]()
            juegosXml[mifila][19] = ""
            let miSystem = String(juegosXml[mifila][22])
            let mifilaAll = allTheGames.firstIndex(where: {$0.sistema == miSystem})
            let miRomPath = allTheGames[mifilaAll!].rompath
            let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
            allTheGames[mifilaAll!].games[mifilaJuego!].fav = ""
            for game in allTheGames[mifilaAll!].games {
                
                let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core]
                miarray.append(mijuego)
                
            }
            
            let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
            let miJuegoFav = allTheGames[mifilafav!].games.firstIndex(where: {$0.path == juegosXml[juegosTableView.selectedRow][0]})
            allTheGames[mifilafav!].games.remove(at: miJuegoFav!)
            xmlJuegosNuevosFav(systema: miRomPath, arrayNuevo: miarray)
            let indexSet = NSIndexSet(index: juegosTableView.selectedRow)
            juegosTableView.removeRows(at: indexSet as IndexSet, withAnimation: .effectFade)
            favImagen.isHidden = true
            contextMenu.items[1].submenu?.items[2].isHidden = true
            contextMenu.items[1].submenu?.items[1].isHidden = false
            
            
            
        }
        
        
        
        
        
    }
    
    @objc func escrapearSistema() {
        var miFilaTable = 0
        infoLabel.stringValue = "Escrapeando \(juegosXml.count) juegos"
        
        for game in self.juegosXml{
            let miSeleccion = NSIndexSet(index: miFilaTable)
            self.juegosTableView.selectRowIndexes(miSeleccion as IndexSet, byExtendingSelection: false)
            self.buscaJuego()
            self.infoLabel.stringValue = "Escrapeados \(miFilaTable + 1) /\(self.juegosXml.count) Juegos"
            miFilaTable += 1
        }
        
        
        //infoLabel.stringValue = "\(sistemaActual) ESCRAPEADO"
    }
    
    func xmlJuegosNuevosFav(systema: String, arrayNuevo: [[String]]){
        print("Crear XML añadiendo Juegos Nuevos")
        let nuevoGamelist = rutaApp  + systema + "/gamelist.xml"
        let root = XMLElement(name: "gameList")
        let xml = XMLDocument(rootElement: root)
        for juego in arrayNuevo {
            let gameNode = XMLElement(name: "game")
            root.addChild(gameNode)
            let pathNode = XMLElement(name: "path", stringValue: juego[0])
            let filename = juego[1]
            let name = (filename as NSString).deletingPathExtension
            let nameNode = XMLElement(name: "name", stringValue: name)
            let descNode = XMLElement(name: "desc", stringValue: juego[2])
            let mapNode = XMLElement(name: "map", stringValue: juego[3])
            let manualNode = XMLElement(name: "manual", stringValue: juego[4])
            let newsNode = XMLElement(name: "news",  stringValue: juego[5])
            let tittleshotNode = XMLElement(name: "tittleshot", stringValue: juego[6])
            let fanartNode = XMLElement(name: "fanart", stringValue: juego[7])
            let thumbnailNode = XMLElement(name: "thumbnail", stringValue: juego[8])
            //let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: juego[1]) )
            let imageNode = XMLElement(name: "image", stringValue: juego[9] )
            //let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: juego[1]) )
            let videoNode = XMLElement(name: "video", stringValue: juego[10] )
            let marqueeNode = XMLElement(name: "marquee", stringValue: juego[11])
            let releasedateNode = XMLElement(name: "releasedate",  stringValue: juego[12])
            let developerNode = XMLElement(name: "developer", stringValue: juego[13])
            let publisherNode = XMLElement(name: "publisher", stringValue: juego[14])
            let genreNode = XMLElement(name: "genre", stringValue: juego[15])
            let langNode = XMLElement(name: "lang", stringValue: juego[16])
            let playersNode = XMLElement(name: "players", stringValue: juego[17])
            let ratingNode = XMLElement(name: "rating", stringValue: juego[18])
            let favNode = XMLElement(name: "fav", stringValue: juego[19])
            let coreNode = XMLElement(name: "core", stringValue: juego[21])
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
            gameNode.addChild(favNode)
            gameNode.addChild(coreNode)
        }
        let xmlData = xml.xmlData(options: .nodePrettyPrint)
        
        print("TOTAL: \(arrayNuevo.count) Juegos en Total")
        do{
            try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
        }catch {}
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @objc func coresistema (_ sender: NSMenuItem) {
        
        var newComand = sender.toolTip!
        print(newComand)
        var FilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        var FilaSystems = allTheSystems.firstIndex(where: {$0.nombrelargo == sistemaActual})
        print(FilaSystems)
        allTheSystems[FilaSystems!].comando = newComand
        allTheGames[FilaAll!].command = newComand
        for a in 0..<allTheGames[FilaAll!].games.count {
            allTheGames[FilaAll!].games[a].comando = newComand
        }
        for numero in 0..<juegosXml.count {
            juegosXml[numero][20] = newComand
        }
        escribeSistemas()
        
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


