//
//  listScreenTable.swift
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
    
    func numberOfRows(in juegosTableView: NSTableView) -> Int {
        
        return juegosXml.count
        
    }
    
    
    
    func tableView(_ juegosTableview: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let vw = juegosTableview.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        ///AÑADIR JUEGO A LISTA CON GAMELIST
        vw.textField?.stringValue = juegosXml[row][1]
        
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
        columna = miFila
        print(juegosXml[miFila])
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
           NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
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
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
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
        
        itemsPorJuego()
        
        
        
    }
}
