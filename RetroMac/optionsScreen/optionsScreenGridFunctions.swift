//
//  optionsScreenGridFunctions.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 1/4/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import Cocoa
import Commands
extension OptionsViewController {
    
    @objc func scrapearJuegoGrid (juego: String, sistema: String, nombrejuego: String, filajuego: Int, RutaJuego: String){
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
                                            
                                            
                                            if sJson3["type"].stringValue == "ss" || sJson3["type"].stringValue == "ss"{
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
                                            if (sJson3["type"].stringValue == "wheel-hd" || sJson3["type"].stringValue == "wheel") && (sJson3["region"] == "us" || sJson3["region"] == "eu" || sJson3["region"] == "wor") {
                                                logoJuego = sJson3["url"].stringValue
                                                //print("MINIMarquee: \(miniMarqueeJuego)")
                                                
                                            }else if (sJson3["type"].stringValue == "wheel-hd" || sJson3["type"].stringValue == "wheel") && sJson3["region"] == "jp" {
                                                
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
                                            //self.habilitarTabla()
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            //myCollectionView.reloadData()
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            //myCollectionView.reloadData()
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear{
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                                            self.infoLabel.stringValue = "JUEGO ESCRAPEADO"
                                            //myCollectionView.reloadData()
                                            cargaItemColumna()
                                            escrapeando = false
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear{
                                                escrapeando = false
                                                self.infoLabel.stringValue = "ESCRAPEO TERMINADO"
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(rawJuegosXml.count)"
                                                
                                                
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
                ///ACTUALIZAR EL ARRAY DE JUEGOS rawJuegosXml
                let filaRawJuegos = rawJuegosXml.firstIndex(where: {$0[0] == RutaJuego})
                //MARK: TAS QUEDAO AQUI
                if nombreEscrapeado != "" {
                    //rawJuegosXml[filaRawJuegos!][1] = nombreEscrapeado
                    //print("NOMBRE OK: \(nombreEscrapeado)")
                }
                rawJuegosXml[filaRawJuegos!][2] = descJuego.replacingOccurrences(of: "\n", with: " ")
                rawJuegosXml[filaRawJuegos!][3] = rawJuegosXml[filaRawJuegos!][3]
                if manualJuego != "" {
                    rawJuegosXml[filaRawJuegos!][4] = rompath + "/media/" + nombrejuego + ".pdf"
                }else {
                    
                    rawJuegosXml[filaRawJuegos!][4] = ""
                }
                rawJuegosXml[filaRawJuegos!][5] = rawJuegosXml[filaRawJuegos!][5]
                if tittleshotJuego != "" {
                    rawJuegosXml[filaRawJuegos!][6] = rompath + "/media/"  + nombrejuego + "_tittleshot.png"
                }else {
                    rawJuegosXml[filaRawJuegos!][6] = ""
                }
                if fanartJuego != "" {
                    rawJuegosXml[filaRawJuegos!][7] = rompath + "/media/"  + nombrejuego + "_fanart.png"
                }else {
                    rawJuegosXml[filaRawJuegos!][7] = ""
                }
                if screenshotJuego != "" {
                    rawJuegosXml[filaRawJuegos!][8] = rompath + "/media/" + nombrejuego + ".png"
                    rawJuegosXml[filaRawJuegos!][9] = rompath + "/media/"  + nombrejuego + ".png"
                } else {
                    rawJuegosXml[filaRawJuegos!][8] = ""
                    rawJuegosXml[filaRawJuegos!][9] = ""
                }
                if videoJuego != "" {
                    rawJuegosXml[filaRawJuegos!][10] = rompath + "/media/" + nombrejuego + ".mp4"
                } else {
                    rawJuegosXml[filaRawJuegos!][10] = ""
                }
                if marqueeJuego != "" {
                    rawJuegosXml[filaRawJuegos!][11] = rompath + "/media/"  + nombrejuego + "_marquee.png"
                } else {
                    rawJuegosXml[filaRawJuegos!][11] = ""
                }
                
                rawJuegosXml[filaRawJuegos!][12] = fechaJuego
                rawJuegosXml[filaRawJuegos!][13] = desarroladorJuego
                rawJuegosXml[filaRawJuegos!][14] = desarroladorJuego
                rawJuegosXml[filaRawJuegos!][15] = generoJuego
                rawJuegosXml[filaRawJuegos!][16] = rawJuegosXml[filaRawJuegos!][16]
                rawJuegosXml[filaRawJuegos!][17] = playersJuego
                rawJuegosXml[filaRawJuegos!][18] = rawJuegosXml[filaRawJuegos!][18]
                rawJuegosXml[filaRawJuegos!][19] = rawJuegosXml[filaRawJuegos!][19]
                rawJuegosXml[filaRawJuegos!][23] = rompath + "/media/"  + nombrejuego + "_box.png"
                self.xmlJuegosNuevosGrid()
                //DispatchQueue.main.sync {}
                
                
                let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
                let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == rawJuegosXml[filaRawJuegos!][0]})
                if nombreEscrapeado != "" {
                    //allTheGames[mifila!].games[mifilaJuego!].name = nombreEscrapeado
                }
                
                allTheGames[mifila!].games[mifilaJuego!].description = rawJuegosXml[filaRawJuegos!][2]
                allTheGames[mifila!].games[mifilaJuego!].map = rawJuegosXml[filaRawJuegos!][3]
                allTheGames[mifila!].games[mifilaJuego!].manual = rawJuegosXml[filaRawJuegos!][4]
                allTheGames[mifila!].games[mifilaJuego!].tittleshot = rawJuegosXml[filaRawJuegos!][6]
                allTheGames[mifila!].games[mifilaJuego!].fanart = rawJuegosXml[filaRawJuegos!][7]
                allTheGames[mifila!].games[mifilaJuego!].thumbnail = rawJuegosXml[filaRawJuegos!][8]
                allTheGames[mifila!].games[mifilaJuego!].image = rawJuegosXml[filaRawJuegos!][9]
                allTheGames[mifila!].games[mifilaJuego!].video = rawJuegosXml[filaRawJuegos!][10]
                allTheGames[mifila!].games[mifilaJuego!].marquee = rawJuegosXml[filaRawJuegos!][11]
                allTheGames[mifila!].games[mifilaJuego!].releasedate = rawJuegosXml[filaRawJuegos!][12]
                allTheGames[mifila!].games[mifilaJuego!].developer = rawJuegosXml[filaRawJuegos!][13]
                allTheGames[mifila!].games[mifilaJuego!].publisher = rawJuegosXml[filaRawJuegos!][14]
                allTheGames[mifila!].games[mifilaJuego!].genre = rawJuegosXml[filaRawJuegos!][15]
                allTheGames[mifila!].games[mifilaJuego!].lang = rawJuegosXml[filaRawJuegos!][16]
                allTheGames[mifila!].games[mifilaJuego!].players = rawJuegosXml[filaRawJuegos!][17]
                allTheGames[mifila!].games[mifilaJuego!].rating = rawJuegosXml[filaRawJuegos!][18]
                allTheGames[mifila!].games[mifilaJuego!].fav = rawJuegosXml[filaRawJuegos!][19]
                allTheGames[mifila!].games[mifilaJuego!].box = rawJuegosXml[filaRawJuegos!][23]
                
                //MARK: Falta actulizar el array testJuegosXml
                if escrapeandoSistema == false {
                    //MARK: si es solo un juego, actualizamos solo el juego en el nivel
                    if nombreEscrapeado != "" {
                        //testJuegosXml[columna][1] = nombreEscrapeado
                    }
                    testJuegosXml[columna][2] = descJuego.replacingOccurrences(of: "\n", with: " ")
                    testJuegosXml[columna][3] = testJuegosXml[columna][3]
                    if manualJuego != "" {
                        testJuegosXml[columna][4] = rompath + "/media/" + nombrejuego + ".pdf"
                    }else {
                        
                        testJuegosXml[columna][4] = ""
                    }
                    testJuegosXml[columna][5] = testJuegosXml[columna][5]
                    if tittleshotJuego != "" {
                        testJuegosXml[columna][6] = rompath + "/media/"  + nombrejuego + "_tittleshot.png"
                    }else {
                        testJuegosXml[columna][6] = ""
                    }
                    if fanartJuego != "" {
                        testJuegosXml[columna][7] = rompath + "/media/"  + nombrejuego + "_fanart.png"
                    }else {
                        testJuegosXml[columna][7] = ""
                    }
                    if screenshotJuego != "" {
                        testJuegosXml[columna][8] = rompath + "/media/" + nombrejuego + ".png"
                        testJuegosXml[columna][9] = rompath + "/media/"  + nombrejuego + ".png"
                    } else {
                        testJuegosXml[columna][8] = ""
                        testJuegosXml[columna][9] = ""
                    }
                    if videoJuego != "" {
                        testJuegosXml[columna][10] = rompath + "/media/" + nombrejuego + ".mp4"
                    } else {
                        testJuegosXml[columna][10] = ""
                    }
                    if marqueeJuego != "" {
                        testJuegosXml[columna][11] = rompath + "/media/"  + nombrejuego + "_marquee.png"
                    } else {
                        testJuegosXml[columna][11] = ""
                    }
                    
                    testJuegosXml[columna][12] = fechaJuego
                    testJuegosXml[columna][13] = desarroladorJuego
                    testJuegosXml[columna][14] = desarroladorJuego
                    testJuegosXml[columna][15] = generoJuego
                    testJuegosXml[columna][16] = testJuegosXml[columna][16]
                    testJuegosXml[columna][17] = playersJuego
                    testJuegosXml[columna][18] = testJuegosXml[columna][18]
                    testJuegosXml[columna][19] = testJuegosXml[columna][19]
                    testJuegosXml[columna][23] = rompath + "/media/"  + nombrejuego + "_box.png"
                    
                    
                    
                } else {
                    
                    //MARK: Si es TODO el sistema, cargamos el viewcontroller desde cero
                }
            })
            
        })
        
    }
    
    func xmlJuegosNuevosGrid(){
        print("Crear XML añadiendo Juegos Nuevos")
        let nuevoGamelist = rompath + "/gamelist.xml"
        let root = XMLElement(name: "gameList")
        let xml = XMLDocument(rootElement: root)
        for juego in rawJuegosXml {
            let gameNode = XMLElement(name: "game")
            root.addChild(gameNode)
            let pathNode = XMLElement(name: "path", stringValue: rutaARelativa(ruta: juego[0]))
            
            let filename = juego[1]
            let name = (filename as NSString).deletingPathExtension
            let nameNode = XMLElement(name: "name", stringValue: name)
            let descNode = XMLElement(name: "desc", stringValue: juego[2])
            let mapNode = XMLElement(name: "map", stringValue: rutaARelativa(ruta: juego[3]))
            let manualNode = XMLElement(name: "manual", stringValue: rutaARelativa(ruta: juego[4]))
            let newsNode = XMLElement(name: "news",  stringValue: rutaARelativa(ruta: juego[5]))
            let tittleshotNode = XMLElement(name: "tittleshot", stringValue: rutaARelativa(ruta: juego[6]))
            let fanartNode = XMLElement(name: "fanart", stringValue: rutaARelativa(ruta: juego[7]))
            let thumbnailNode = XMLElement(name: "thumbnail", stringValue: rutaARelativa(ruta: juego[8]))
            //let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: juego[1]) )
            let imageNode = XMLElement(name: "image", stringValue: rutaARelativa(ruta: juego[9]))
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
        print("TOTAL: \(rawJuegosXml.count) Juegos en Total")
        do{
            try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
        }catch {}
    }
    
    func buscaJuegoSGrid(numerojuego: Int){
        
        print("Escrapeo - 1")
        abiertaLista = false
        
        DispatchQueue.main.sync {
            
            self.infoLabel.isHidden = false
        }
        escrapeando = true
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
        juegosaescrapearensistema = rawJuegosXml.count
        
        let defaults = UserDefaults.standard
        let SSUser = defaults.string(forKey: "SSUser") ?? ""
        let SSPassword = defaults.string(forKey: "SSPassword") ?? ""
        let numero = numerojuego
        var nombre = ""
        var miputonombre = ""
        //Si el sistema es MAME
        if misystemid == "75" {
            
            var juegoMame = rawJuegosXml[numero][1]
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
            nombre = rawJuegosXml[numero][1]
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
        
        var nombreplano = rawJuegosXml[numerojuego][1].replacingOccurrences(of: " ", with: "")
        
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
                self.infoLabel.stringValue = "ERROR de conexión"
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
                                        nombreEscrapeado = ""
                                        nombreEscrapeado = nombreEncontrado
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
                self.scrapearJuegoGrid(juego: miId, sistema: idSistema, nombrejuego: nombreplano, filajuego: numerojuego, RutaJuego: rawJuegosXml[numero][0])
                
            } else {
                self.scrapearJuegoGrid(juego: miId, sistema: misystemid, nombrejuego: nombreplano, filajuego: numerojuego, RutaJuego: rawJuegosXml[numero][0])
                
            }
            
            
            
        }else{
            print("Juego no encontrado")
            
            
            juesgosEscrapeados += 1
            juegosaEscrapear -= 1.0
            DispatchQueue.main.sync {
                self.barraProgress.maxValue -= 1.0
            }
            if escrapeandoSistema == false {
                self.infoLabel.stringValue = "Juego no encontrado"
                //                habilitarTabla()
            }
            if escrapeandoSistema == true {
                if juesgosEscrapeados == rawJuegosXml.count {
                    DispatchQueue.main.sync {
                        infoLabel.stringValue = "SISTEMA ESCRAPEADO"
                    }
                    
                }
            }
            
        }
    }
}
