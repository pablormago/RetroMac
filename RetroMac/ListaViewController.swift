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
        //view.wantsLayer = true
        // change the background color of the layer
        //view.layer?.backgroundColor = CGColor(red: 73/255, green: 74/255, blue: 77/255, alpha: 1)
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
        let miImagen = String(juegosXml[miFila][9])
        let miVideo = String(juegosXml[miFila][10])
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
            Commands.Bash.system("\(comando)")
            comando=""
            
            let indexSet = NSIndexSet(index: (juegosTableView.selectedRow + -1))
            let indexSet2 = NSIndexSet(index: juegosTableView.selectedRow )
            juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
            juegosTableView.selectRowIndexes(indexSet2 as IndexSet, byExtendingSelection: false)
            
            print("ENTER")
            
        }
        if event.keyCode == 51  {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
            }
            print("Backspace")
        }
        if event.keyCode == 124  {
            print("Derecha")
        }
        if event.keyCode == 123 {
            print("Izquierda")
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
            print("Total: \(juegosXml.count) Juegos en XML")
            juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
            sistemaLabel.stringValue = sistemaActual
        }else{
            print("ERROR GARGANDO gamelist.xml en: \(String(describing: pathXMLinterno2))")
        }
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
}
