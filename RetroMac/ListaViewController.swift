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

class ListaViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var scrollerDesc: ScrollingTextView!
    @IBOutlet weak var sistemaLabel: NSTextField!
    @IBOutlet weak var snapPlayer: AVPlayerView!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var juegosTableView: NSTableView!
    @IBOutlet weak var snapShot: NSImageView!
    var juegos = [String]()
    var juegosXml = [[String]]()
    
    var keyIsDown = false
    var playingVideo = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LISTA LOAD")
        view.wantsLayer = true
        // change the background color of the layer
        view.layer?.backgroundColor = CGColor(red: 73/255, green: 74/255, blue: 77/255, alpha: 1)
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
        
        if fileDoesExist {
            print("HAY XML")
            juegosGamelist()
            
        }
        
        /// FIN JUEGOS GAMELIST
        
        
        if juegosXml.count > 0 {
            let indexSet = NSIndexSet(index: 0)
            juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        }
        
        juegosTableView.doubleAction = #selector(onItemClicked)
        
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
        
        guard juegosTableView.selectedRow != -1 else {return}
        let pathLogo = Bundle.main.url(forResource: "logo", withExtension: "jpeg")
        imageSelected(path: pathLogo!  )
        
        //        //CARGAR IMAGENES Y VIDEOS
        let miFila = juegosTableView.selectedRow
        let miDesc = String(juegosXml[miFila][2])
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
        
        scrollerDesc.font = NSFont(name: "Arial", size: 20)
        scrollerDesc.delay = 1
        scrollerDesc.speed = 2
        scrollerDesc.setup(string: miDesc.replacingOccurrences(of: "\n", with: " "))
        
        if miImagen != nil && miImagen != "" {
            let imagenURL = URL(fileURLWithPath: miImagen)
            imageSelected(path: imagenURL)
        }
        if miVideo != nil && miVideo != "" {
            let videoURL = URL(fileURLWithPath: miVideo)
            let player2 = AVPlayer(url: videoURL)
            snapPlayer.player = player2
            snapPlayer.player?.play()
            playingVideo = true
        }else{
            let noVideo = Bundle.main.path(forResource: "NoVideo", ofType:"mp4")
            let videoURL = URL(fileURLWithPath: noVideo!)
            let player2 = AVPlayer(url: videoURL)
            snapPlayer.player = player2
            snapPlayer.player?.play()
        }
        abiertaLista = true
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
        
        print("LISTA APPEAR")
        if !self.view.window!.isZoomed{
            //self.view.window?.zoom(self)
        }
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        
        self.view.window?.setFrame(mirect, display: true)
        // *** /FullScreen ***
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let mirect = NSRect(x: 0, y: 0, width: ancho, height: alto)
        self.view.window?.setFrame(mirect, display: true)
        
    }
    
    override func keyDown(with event: NSEvent) {
        
        if keyIsDown == true {
            return
        }
        keyIsDown = true
        
        
        
        
        
        if event.keyCode == 36  && abiertaLista == true {
            
            let numero = (juegosTableView.selectedRow)
            let romXml = "\"\(juegosXml[numero][0])\""
            var comando = comandoaejecutar.replacingOccurrences(of: "%ROM%", with: romXml)
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
        if event.keyCode == 51 && abiertaLista == true {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
            }
            print("Backspace")
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
                    let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
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
                    let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
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
        
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            self.view.window?.contentViewController = controller
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
        }
    }
    
    @objc private func onItemClicked() {
        let numero = (juegosTableView.selectedRow)
        let romXml = "\"\(juegosXml[numero][0])\""
        var comando = comandoaejecutar.replacingOccurrences(of: "%ROM%", with: romXml)
        if playingVideo == true {
            snapPlayer.player?.pause()
        }
        Commands.Bash.system("\(comando)")
        comando=""
        
        let indexSet = NSIndexSet(index: (juegosTableView.selectedRow + -1))
        let indexSet2 = NSIndexSet(index: juegosTableView.selectedRow )
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        juegosTableView.selectRowIndexes(indexSet2 as IndexSet, byExtendingSelection: false)
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
                let miNews = String(game.news)
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
                
                datosJuego = [String(miJuego) , miNombre, miDescripcion, String(miMapa), String(miManual), miNews, String(miTittleShot), String(miFanArt), String(miThumbnail), String(miImage), String(miVideo), String(miMarquee), miReleaseData, miDeveloper, miPublisher, miGenre, miLang, miPlayers, miRating ]
                
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
                        datosJuegoNoXml = [rutacompleta , String(element), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ]
                        juegosXml.append(datosJuegoNoXml)
                    }
                    
                }
            }
            
        }
        if juegosnuevos > 1 {
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
        var nuevoGamelist = rompath + "/gamelist.xml"
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
        let xmlData = xml.xmlData(options: .nodePrettyPrint)
        
        print("TOTAL: \(juegosXml.count) Juegos en Total")
        do{
            try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
        }catch {}
    }
}
