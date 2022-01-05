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
        pdfImage.action = #selector(abrirPdf)
        pdfImage.isEnabled = false
        
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
        infoLabel.stringValue = "INFO"
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
        if miManual == "" {
            pdfImage.isEnabled = false
        }else {
            pdfImage.isEnabled = true
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
        else if event.keyCode == 51 && abiertaLista == true {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
            }
            print("Backspace")
        }else if event.keyCode == 53 && abiertaLista == true {
            infoLabel.stringValue = "Buscando Juego..."
            //DispatchQueue.global(qos: .utility).async { [unowned self] in
            self.buscaJuego()
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
        NSWorkspace.shared.openFile(miManual)
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
    
    func buscaJuego(){
        print("Escrapeo - 1")
        
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
        nombre = juegosXml[numero][1]
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
                                        print(nombreEncontrado)
                                        print(miputonombre)
                                        if nombreEncontrado == miputonombre {
                                            print("COJONUDO")
                                            miId = subsubJson["id"].stringValue
                                            encontrada = true
                                            break
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
                    
                }
                
                
            }
        }, completion:{
            
            // when background job finished, do something in main thread
        })
        //DispatchQueue.global(qos: .background).async {
        // do your job here
        
        //            DispatchQueue.main.async {
        //                // update ui here
        //            }
        //}
        
        
        
    }
    
    func scrapearJuego (juego: String, sistema: String, nombrejuego: String, filajuego: Int){
        print("Escrapeo - 2")
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
                                        print("Desarrrolador: " + desarroladorJuego)
                                    }
                                    if index3 == "joueurs" && index4 == "text" {
                                        playersJuego = sJson2.stringValue
                                        print("Jugadores: " + playersJuego)
                                    }
                                    if index3 == "editeur" && index4 == "text" {
                                        editorJuego = sJson2.stringValue
                                        print("Editor: " + editorJuego)
                                    }
                                    if index3 == "genres" {
                                        for (index5, sJson3):(String, JSON) in sJson2 {
                                            //print (index5 + " -> \(sJson3)")
                                            for (index6, sJson4):(String, JSON) in sJson3 {
                                                //print (index5 + "-> \(index6) -> \(sJson4)")
                                                if sJson4["langue"].stringValue == "es" {
                                                    print("Genero: " + sJson4["text"].stringValue)
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
                                                print("Descripcion: \(descJuego)")
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
                                            
                                            if sJson3["region"].stringValue == "eu" {
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
                                    if index3 == "medias" {
                                        var encuentrass = false
                                        for (index5, sJson3):(String, JSON) in sJson {
                                            
                                            if sJson3["type"].stringValue == "ss" {
                                                screenshotJuego = sJson3["url"].stringValue
                                                print("Screenshot: \(screenshotJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "video" {
                                                videoJuego = sJson3["url"].stringValue
                                                print("Video: \(videoJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "fanart" {
                                                fanartJuego = sJson3["url"].stringValue
                                                print("Fanart: \(fanartJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "sstitle" {
                                                tittleshotJuego = sJson3["url"].stringValue
                                                print("TittleShot: \(tittleshotJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "screenmarquee" {
                                                marqueeJuego = sJson3["url"].stringValue
                                                print("Marquee: \(marqueeJuego)")
                                                
                                            }
                                            if sJson3["type"].stringValue == "manuel" && sJson3["region"].stringValue == "us"{
                                                manualJuego = sJson3["url"].stringValue
                                                print("Manual: \(manualJuego)")
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
            
            //DispatchQueue.global(qos: .background).async {
            DispatchQueue.background(delay: 10.0, background: {
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
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)._tittleshot\("png")"
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
                if marqueeJuego != "" {
                    //self.descargaMedia(tipo: "png", url: marqueeJuego, nombre: nombrejuego + "_marquee")
                    let myFilePathString = "file://" + rompath + "/media" + "/\(nombrejuego)_marquee.\("png")"
                    let midestino = URL(string: myFilePathString)
                    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = midestino
                    
                    //Create URL to the source file you want to download
                    let fileURL = URL(string: marqueeJuego)
                    
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
                self.juegosXml[filajuego][4] = rompath + "/media/" + nombrejuego + ".pdf"
                self.juegosXml[filajuego][5] = self.juegosXml[filajuego][5]
                self.juegosXml[filajuego][6] = rompath + "/media/"  + nombrejuego + "_tittleshot.png"
                self.juegosXml[filajuego][7] = rompath + "/media/"  + nombrejuego + "_fanart.png"
                self.juegosXml[filajuego][8] = rompath + "/media/" + nombrejuego + ".png"
                self.juegosXml[filajuego][9] = rompath + "/media/"  + nombrejuego + ".png"
                self.juegosXml[filajuego][10] = rompath + "/media/" + nombrejuego + ".mp4"
                self.juegosXml[filajuego][11] = rompath + "/media/"  + nombrejuego + "_marquee.png"
                self.juegosXml[filajuego][12] = fechaJuego
                self.juegosXml[filajuego][13] = desarroladorJuego
                self.juegosXml[filajuego][14] = desarroladorJuego
                self.juegosXml[filajuego][15] = generoJuego
                self.juegosXml[filajuego][16] = self.juegosXml[filajuego][16]
                self.juegosXml[filajuego][17] = playersJuego
                self.juegosXml[filajuego][18] = self.juegosXml[filajuego][18]
                self.xmlJuegosNuevos()
                //DispatchQueue.main.sync {
                self.infoLabel.stringValue = "Juego ESCRAPEADO!!"
                // when background job finished, do something in main thread
            })
            
            
            //}
            
            
            //}
            // when background job finished, do something in main thread
        })
        
        
        
        
        //}
        
        
        
        
        
        
    }
    
    func descargaMedia (tipo: String, url: String, nombre: String){
        let myFilePathString = "file://" + rompath + "/media" + "/\(nombre).\(tipo)"
        let midestino = URL(string: myFilePathString)
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = midestino
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: url)
        
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
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    func buscaJuegoS(numerojuego: Int){
        print("Escrapeo - 1")
        
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
        //let numero = (juegosTableView.selectedRow)
        var nombre = ""
        var miputonombre = ""
        nombre = juegosXml[numerojuego][1]
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
                            miId = subsubJson["id"].stringValue
                            if ((subsubJson["noms"].rawString())?.contains(miputonombre))! {
                                print("EUREKA")
                                encontrada = true
                                break
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
            
            
        }
        //            DispatchQueue.main.async {
        //                // update ui here
        //            }
        
        
        
        
    }
    
    func escrapeartodos(){
        for (index, juego)  in juegosXml.enumerated() {
            buscaJuegoS(numerojuego: index)
            //print(index)
        }
        infoLabel.stringValue = "** JUEGOS ESCRAPEADOS **"
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


