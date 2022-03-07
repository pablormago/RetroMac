//
//  listScreenFunctions.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 2/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa
import Commands
import AVKit
import AVFoundation
import GameController

extension ListaViewController {
    
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
    
    func xmlJuegosNuevosFav(systema: String, arrayNuevo: [[String]]){
        print("Crear XML añadiendo Juegos Nuevos")
        let nuevoGamelist = rutaApp  + systema + "/gamelist.xml"
        let root = XMLElement(name: "gameList")
        let xml = XMLDocument(rootElement: root)
        for juego in arrayNuevo {
            let gameNode = XMLElement(name: "game")
            root.addChild(gameNode)
            let pathNode = XMLElement(name: "path", stringValue: rutaARelativa(ruta: juego[0]))
            let filename = juego[1]
            let name = (filename as NSString).deletingPathExtension
            let nameNode = XMLElement(name: "name", stringValue: name)
            let descNode = XMLElement(name: "desc", stringValue: juego[2])
            let mapNode = XMLElement(name: "map", stringValue: juego[3])
            let manualNode = XMLElement(name: "manual", stringValue: rutaARelativa(ruta: juego[4]))
            let newsNode = XMLElement(name: "news",  stringValue: rutaARelativa(ruta: juego[5]))
            let tittleshotNode = XMLElement(name: "tittleshot", stringValue: rutaARelativa(ruta: juego[6]))
            let fanartNode = XMLElement(name: "fanart", stringValue: rutaARelativa(ruta: juego[7]))
            let thumbnailNode = XMLElement(name: "thumbnail", stringValue: rutaARelativa(ruta: juego[8]))
            //let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: juego[1]) )
            let imageNode = XMLElement(name: "image", stringValue: rutaARelativa(ruta: juego[9]) )
            //let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: juego[1]) )
            let videoNode = XMLElement(name: "video", stringValue: rutaARelativa(ruta: juego[10]) )
            let marqueeNode = XMLElement(name: "marquee", stringValue: rutaARelativa(ruta: juego[11]))
            let releasedateNode = XMLElement(name: "releasedate",  stringValue: juego[12])
            let developerNode = XMLElement(name: "developer", stringValue: juego[13])
            let publisherNode = XMLElement(name: "publisher", stringValue: juego[14])
            let genreNode = XMLElement(name: "genre", stringValue: juego[15])
            let langNode = XMLElement(name: "lang", stringValue: juego[16])
            let playersNode = XMLElement(name: "players", stringValue: juego[17])
            let ratingNode = XMLElement(name: "rating", stringValue: juego[18])
            let favNode = XMLElement(name: "fav", stringValue: juego[19])
            let coreNode = XMLElement(name: "core", stringValue: juego[21])
            let boxNode = XMLElement(name: "box", stringValue: rutaARelativa(ruta: juego[23]))
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
            //gameNode.addChild(coreNode)
            gameNode.addChild(boxNode)
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
    
    
    
    func recargar() {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            //self.view.window?.contentViewController = controller
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
            juegosXml = []
            contextMenu.items.removeAll()
            let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
            sistemaActual = button?.Fullname! ?? ""
            nombresistemaactual = button!.Sistema ?? ""
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
    
    
    func imageSelected(path: URL) {
        if path != nil  {
            let imagen = NSImage(contentsOf: path)
            if imagen != nil {
                snapShot.image = imagen
            }
        }
    }
    
    @IBAction func backFunc(_ sender: NSButton) {
        //print("ES: \(view.window?.firstResponder)")
        //NotificationCenter.default.removeObserver(self)
        
        if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
            SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
            controller.view.window?.makeFirstResponder(controller.scrollMain)
            snapPlayer.player?.pause()
            abiertaLista = true
            ventana = "Principal"
            cuentaboton = botonactual
        }
    }
    
    @objc public func abrirPdf(){
        print("PDF")
        let miFila = juegosTableView.selectedRow
        let miManual = String(juegosXml[miFila][4])
        print(miManual)
        NSWorkspace.shared.openFile(miManual)
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
            if siONoGameBezel == "SI" {
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
            if miShader == "NINGUNO" {
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
    
}
