//
//  optionsScreenFunctions.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 3/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa
import Commands

extension OptionsViewController {
    
    @objc func buscaJuegoGrid(){
       
        infoLabel.isHidden = false
        escrapeandoSistema = false
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
        let numero = columna
        
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
                    //self.juegosTableView.isEnabled = true
                    self.infoLabel.stringValue = "ERROR de conexión"
                    //self.view.window?.makeFirstResponder(self.juegosTableView)
                    
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
                            
                        outerLoop: for (tercero, subsubJson):(String, JSON) in object{
                                //print(subsubJson["id"].stringValue)
                                
                                let cuantos = Int(subsubJson["noms"].count)
                                print("NOMBRES: \(Int(subsubJson["noms"].count))")
                                if cuantos > 0 {
                                    for i in 0...cuantos - 1 {
                                        var nombreEncontrado = subsubJson["noms"][i]["text"].rawString()!
                                        print("Encuentro: \(nombreEncontrado)")
                                        print("Buscaba: \(miputonombre)")
                                        
                                        if miputonombre.caseInsensitiveCompare(nombreEncontrado) == ComparisonResult.orderedSame {
                                            print("COJONUDO")
                                            miId = subsubJson["id"].stringValue
                                            encontrada = true
                                            break outerLoop
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
                    //self.juegosTableView.isEnabled = true
                    //self.view.window?.makeFirstResponder(self.juegosTableView)
                }
                
                
            }
        }, completion:{
            
            // when background job finished, do something in main thread
        })
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear {
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear{
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                                        }else{
                                            
                                            self.barraProgress.increment(by: 1)
                                            
                                            
                                            
                                            if self.barraProgress.doubleValue == juegosaEscrapear{
                                                //self.habilitarTabla2()
                                            }else {
                                                
                                                self.infoLabel.stringValue = "Escrapeados \(Int(self.barraProgress.doubleValue)) juegos de \(juegosXml.count)"
                                                
                                                
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
                juegosXml[filajuego][2] = descJuego.replacingOccurrences(of: "\n", with: " ")
                juegosXml[filajuego][3] = juegosXml[filajuego][3]
                if manualJuego != "" {
                    juegosXml[filajuego][4] = rompath + "/media/" + nombrejuego + ".pdf"
                }else {
                    
                    juegosXml[filajuego][4] = ""
                }
                juegosXml[filajuego][5] = juegosXml[filajuego][5]
                if tittleshotJuego != "" {
                    juegosXml[filajuego][6] = rompath + "/media/"  + nombrejuego + "_tittleshot.png"
                }else {
                    juegosXml[filajuego][6] = ""
                }
                if fanartJuego != "" {
                    juegosXml[filajuego][7] = rompath + "/media/"  + nombrejuego + "_fanart.png"
                }else {
                    juegosXml[filajuego][7] = ""
                }
                if screenshotJuego != "" {
                    juegosXml[filajuego][8] = rompath + "/media/" + nombrejuego + ".png"
                    juegosXml[filajuego][9] = rompath + "/media/"  + nombrejuego + ".png"
                } else {
                    juegosXml[filajuego][8] = ""
                    juegosXml[filajuego][9] = ""
                }
                if videoJuego != "" {
                    juegosXml[filajuego][10] = rompath + "/media/" + nombrejuego + ".mp4"
                } else {
                    juegosXml[filajuego][10] = ""
                }
                if marqueeJuego != "" {
                    juegosXml[filajuego][11] = rompath + "/media/"  + nombrejuego + "_marquee.png"
                } else {
                    juegosXml[filajuego][11] = ""
                }
                
                juegosXml[filajuego][12] = fechaJuego
                juegosXml[filajuego][13] = desarroladorJuego
                juegosXml[filajuego][14] = desarroladorJuego
                juegosXml[filajuego][15] = generoJuego
                juegosXml[filajuego][16] = juegosXml[filajuego][16]
                juegosXml[filajuego][17] = playersJuego
                juegosXml[filajuego][18] = juegosXml[filajuego][18]
                juegosXml[filajuego][19] = juegosXml[filajuego][19]
                juegosXml[filajuego][23] = rompath + "/media/"  + nombrejuego + "_box.png"
                self.xmlJuegosNuevos()
                //DispatchQueue.main.sync {}
                
                
                let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
                let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == juegosXml[filajuego][0]})
                
                
                allTheGames[mifila!].games[mifilaJuego!].description = juegosXml[filajuego][2]
                allTheGames[mifila!].games[mifilaJuego!].map = juegosXml[filajuego][3]
                allTheGames[mifila!].games[mifilaJuego!].manual = juegosXml[filajuego][4]
                allTheGames[mifila!].games[mifilaJuego!].tittleshot = juegosXml[filajuego][6]
                allTheGames[mifila!].games[mifilaJuego!].fanart = juegosXml[filajuego][7]
                allTheGames[mifila!].games[mifilaJuego!].thumbnail = juegosXml[filajuego][8]
                allTheGames[mifila!].games[mifilaJuego!].image = juegosXml[filajuego][9]
                allTheGames[mifila!].games[mifilaJuego!].video = juegosXml[filajuego][10]
                allTheGames[mifila!].games[mifilaJuego!].marquee = juegosXml[filajuego][11]
                allTheGames[mifila!].games[mifilaJuego!].releasedate = juegosXml[filajuego][12]
                allTheGames[mifila!].games[mifilaJuego!].developer = juegosXml[filajuego][13]
                allTheGames[mifila!].games[mifilaJuego!].publisher = juegosXml[filajuego][14]
                allTheGames[mifila!].games[mifilaJuego!].genre = juegosXml[filajuego][15]
                allTheGames[mifila!].games[mifilaJuego!].lang = juegosXml[filajuego][16]
                allTheGames[mifila!].games[mifilaJuego!].players = juegosXml[filajuego][17]
                allTheGames[mifila!].games[mifilaJuego!].rating = juegosXml[filajuego][18]
                allTheGames[mifila!].games[mifilaJuego!].fav = juegosXml[filajuego][19]
                allTheGames[mifila!].games[mifilaJuego!].box = juegosXml[filajuego][23]
                
                
            })
            
        })
        
    }
    
    func xmlJuegosNuevos(){
        print("Crear XML añadiendo Juegos Nuevos")
        let nuevoGamelist = rompath + "/gamelist.xml"
        let root = XMLElement(name: "gameList")
        let xml = XMLDocument(rootElement: root)
        for juego in juegosXml {
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
        print("TOTAL: \(juegosXml.count) Juegos en Total")
        do{
            try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
        }catch {}
    }
    
    
    @objc func escrapeartodos(){
        
        barraProgress.minValue = 0
        juegosaEscrapear = Double(juegosXml.count)
        barraProgress.maxValue = Double(juegosXml.count)
        
        abiertaLista = false
        
        self.infoLabel.stringValue = "ESCRAPEANDO \(juegosXml.count) JUEGOS"
        DispatchQueue.background(delay: 0.0, background: {
            juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
            let kk = juegosXml.count
            for a in 0..<kk {
                self.buscaJuegoS(numerojuego: a)
                
                if a == (kk - 1) {
                    abiertaLista = true
                }else{
                    abiertaLista = false
                }
            }
        })
        
        
    }
    
    func buscaJuegoS(numerojuego: Int){
        //        if playingVideo == true {
        //            SingletonState.shared.mySnapPlayer?.player?.pause()
        //            snapPlayer.player?.pause()
        //        }
        
        print("Escrapeo - 1")
        abiertaLista = false
        DispatchQueue.main.sync {
            
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
                if juesgosEscrapeados == juegosXml.count {
                    infoLabel.stringValue = "SISTEMA ESCRAPEADO"
                }
            }
            
        }
    }
    
    func getFav(){
        if juegosXml[columna][19] == "FAV" {
            favGameBtn.title = "Borrar Juego de Favoritos"
        } else {
            favGameBtn.title = "Añadir Juego a Favoritos"
        }
    }
    
    func getSystemCores () {
        
        let filaConsola = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        if filaConsola != nil {
            let consola = allTheGames[filaConsola!]
            var cuentaCores = consola.cores.count
            var numeroactivo = Int()
            if consola.cores != nil {
                let misCores = consola.cores
                for a in 0..<cuentaCores {
                    var core = misCores[a][1]
                    var tooltip = misCores[a][2]
                    var comando: String =  (consola.command)
                    if comando.contains(core + "_libretro.dylib") {
                        core = core + " ✅"
                        numeroactivo = a
                    }
                    systemCoreList.menu?.addItem(withTitle: core, action: nil, keyEquivalent: "")
                    systemCoreList.menu?.items[a].toolTip = tooltip
                }
             }
            
            systemCoreList.selectItem(at: numeroactivo)
        }
        
    }
    
    func getSystemShaders() {
        var shaderABuscar = String()
        var activo = Int()
        let filaArraySystemShaders = arraySystemsShaders.firstIndex(where: {$0[0] == sistemaActual})
        if filaArraySystemShaders == nil {
            shaderABuscar = "Ninguno"
        } else {
            shaderABuscar = arraySystemsShaders[filaArraySystemShaders!][1]
        }
        var nombre = String()
        if shaderABuscar == "Ninguno" {
            systemShaderList.menu?.addItem(withTitle: "Ninguno ✅", action: nil, keyEquivalent: "")
            systemShaderList.item(at: 0)?.toolTip = "Ninguno"
            for a in 0..<arrayShaders.count{
                let ruta = arrayShaders[a][0]
                nombre = arrayShaders[a][1]
                systemShaderList.menu?.addItem(withTitle: nombre, action: nil, keyEquivalent: "")
                systemShaderList.menu?.items[a + 1].toolTip = ruta
            }
            systemShaderList.selectItem(at: 0)
        } else {
            systemShaderList.menu?.addItem(withTitle: "Ninguno", action: nil, keyEquivalent: "")
            systemShaderList.item(at: 0)?.toolTip = "Ninguno"
            for a in 0..<arrayShaders.count{
                let ruta = arrayShaders[a][0]
                nombre = arrayShaders[a][1]
                if nombre == shaderABuscar {
                    nombre = nombre + " ✅"
                    activo = a
                }
                
                systemShaderList.menu?.addItem(withTitle: nombre, action: nil, keyEquivalent: "")
                systemShaderList.menu?.items[a + 1].toolTip = ruta
            }
            systemShaderList.selectItem(at: activo + 1)
        }
    }
    
    
    
    func getGameCore(){
        let filaConsola = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        if filaConsola != nil {
            let consola = allTheGames[filaConsola!]
            let cuentaCores = consola.cores.count
            var numeroactivo = Int()
            if consola.cores.count > 0 {
                let misCores = consola.cores
                let juegoABuscar = juegosXml[columna][0]
                var coreAbuscar = String()
                let filaGamesCores = arrayGamesCores.firstIndex(where: {$0[0] == juegoABuscar})
                if filaGamesCores == nil {
                    coreAbuscar = "Automático"
                    gameCoreList.menu?.items[0].title = (gameCoreList.menu?.items[0].title)! + " ✅"
                    gameCoreList.menu?.items[0].toolTip = "Automático"
                    for a in 0..<cuentaCores {
                        var core = misCores[a][1]
                        let tooltip = misCores[a][2]
                        gameCoreList.menu?.addItem(withTitle: core, action: nil, keyEquivalent: "")
                        gameCoreList.menu?.items[a + 1].toolTip = tooltip
                    }
                    gameCoreList.selectItem(at: 0)
                } else {
                    coreAbuscar = arrayGamesCores[filaGamesCores!][1]
                    gameCoreList.menu?.items[0].toolTip = "Automático"
                    for a in 0..<cuentaCores {
                        var core = misCores[a][1]
                        let tooltip = misCores[a][2]
                        if coreAbuscar.contains(core + "_libretro.dylib") {
                            core = core + " ✅"
                            numeroactivo = a
                        }
                        gameCoreList.menu?.addItem(withTitle: core, action: nil, keyEquivalent: "")
                        gameCoreList.menu?.items[a + 1].toolTip = tooltip
                    }
                    gameCoreList.selectItem(at: numeroactivo + 1)
                }
                
            }
            
            
        }
    }
    
    func getGameShaders () {
        var shaderABuscar = String()
        let mijuego = juegosXml[columna][0]
        let miFilaJuego = arrayGamesShaders.firstIndex(where: {$0[0] == mijuego})
        var miShader = String()
        var activo = Int()
        
        if miFilaJuego != nil {
            miShader = arrayGamesShaders[miFilaJuego!][2] //La ruta del Shader
        } else {
            miShader = "Automático"
        }
        
        if miShader == "Automático" {
            gameShaderList.menu?.items[0].title = "Automático ✅"
            
            for a in 0..<arrayShaders.count{
                let ruta = arrayShaders[a][0]
                var nombre = arrayShaders[a][1]
                gameShaderList.menu?.addItem(withTitle: nombre, action: nil, keyEquivalent: "")
                gameShaderList.menu?.items[a + 2].toolTip = ruta
            }
            gameShaderList.selectItem(at: 0)
        }
        
        if miShader == "Ninguno" {
            gameShaderList.menu?.items[1].title = "Ninguno ✅"
            for a in 0..<arrayShaders.count{
                let ruta = arrayShaders[a][0]
                var nombre = arrayShaders[a][1]
                gameShaderList.menu?.addItem(withTitle: nombre, action: nil, keyEquivalent: "")
                gameShaderList.menu?.items[a + 2].toolTip = ruta
            }
            gameShaderList.selectItem(at: 1)
        }
        
        if (miShader != "Automático" && miShader != "Ninguno") {
            for a in 0..<arrayShaders.count{
                let ruta = arrayShaders[a][0]
                var nombre = arrayShaders[a][1]
                if ruta == miShader {
                    nombre = nombre + " ✅"
                    activo = a
                }
                gameShaderList.menu?.addItem(withTitle: nombre, action: nil, keyEquivalent: "")
                gameShaderList.menu?.items[a + 2].toolTip = ruta
            }
            gameShaderList.selectItem(at: activo + 2)
        }
        gameShaderList.menu?.items[0].toolTip = "Automático"
        gameShaderList.menu?.items[1].toolTip = "Ninguno"
    }
    
    func getSystemBezels (){
        let filaConsola = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        if filaConsola != nil {
            let filaEnArrayBezels = arraySystemsBezels.firstIndex(where: {$0[0] == sistemaActual})
            if filaEnArrayBezels == nil {
                systemBezelsList.item(at: 1)?.title = systemBezelsList.item(at: 1)!.title + " ✅"
                systemBezelsList.selectItem(at: 1)
            } else {
                systemBezelsList.item(at: 0)?.title = systemBezelsList.item(at: 0)!.title + " ✅"
                systemBezelsList.selectItem(at: 0)
            }
        }
    }
    
    func getGameBezels (){
        let miJuego = juegosXml[columna][0]
        let filaEnArrayBezels = arrayGamesBezels.firstIndex(where: {$0[0] == miJuego})
        if filaEnArrayBezels == nil {
            gameBezelsList.item(at: 0)?.title = gameBezelsList.item(at: 0)!.title + " ✅"
            gameBezelsList.selectItem(at: 0)
        } else {
            if arrayGamesBezels[filaEnArrayBezels!][1] == "Sí" {
                gameBezelsList.item(at: 1)?.title = gameBezelsList.item(at: 1)!.title + " ✅"
                gameBezelsList.selectItem(at: 1)
            } else {
                gameBezelsList.item(at: 2)?.title = gameBezelsList.item(at: 2)!.title + " ✅"
                gameBezelsList.selectItem(at: 2)
            }
        }
    }
    
    func saveOptions (){
        // MARK: Cogemos los valores de las opciones del sistema:
        let systemCore = systemCoreList.selectedItem?.toolTip!
        let systemShader = systemShaderList.selectedItem?.toolTip!
        let systemShaderName = systemShaderList.selectedItem?.title.replacingOccurrences(of: " ✅", with: "")
        let systemBezel = systemBezelsList.selectedItem?.title.replacingOccurrences(of: " ✅", with: "")
        
        // MARK: Cogemos los valores de las opciones del juego:
        let gameCore = gameCoreList.selectedItem?.toolTip!
        let gameShader = gameShaderList.selectedItem?.toolTip!
        let gameShaderName = gameShaderList.selectedItem?.title.replacingOccurrences(of: " ✅", with: "")
        let gameBezel = gameBezelsList.selectedItem?.title.replacingOccurrences(of: " ✅", with: "")
        
        // MARK: guardamos el core del sistema:
        let FilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let FilaSystems = allTheSystems.firstIndex(where: {$0.nombrelargo == sistemaActual})
        let newComand = systemCore
        
        allTheSystems[FilaSystems!].comando = newComand!
        allTheGames[FilaAll!].command = newComand!
        for a in 0..<allTheGames[FilaAll!].games.count {
            allTheGames[FilaAll!].games[a].comando = newComand!
        }
        for numero in 0..<juegosXml.count {
            juegosXml[numero][20] = newComand!
        }
        escribeSistemas()
        // MARK: guardamos el shader del sistema, o ponemos "Ninguno"

        let sistema = sistemaActual
        let nombre = systemShaderName!.replacingOccurrences(of: " ✅", with: "")
        let ruta = systemShader
        let migrupo = [sistema , nombre, ruta!] as [String]
        if nombre == "Ninguno" {
            let filaABuscar = arraySystemsShaders.firstIndex(where: {$0[0] == sistema})
            if filaABuscar != nil {
                arraySystemsShaders.remove(at: filaABuscar!)
                let defaults = UserDefaults.standard
                defaults.set(arraySystemsShaders, forKey: "systemsShaders")
            } else {
                //NO hacemos nada
            }

        } else {
            if arraySystemsShaders.firstIndex(where: {$0[0] == sistema}) != nil {
                let filaABuscar = arraySystemsShaders.firstIndex(where: {$0[0] == sistema})
                arraySystemsShaders[filaABuscar!][1] = nombre
                arraySystemsShaders[filaABuscar!][2] = ruta!
            } else {
                arraySystemsShaders.append(migrupo)
            }
            let defaults = UserDefaults.standard
            defaults.set(arraySystemsShaders, forKey: "systemsShaders")
        }

        //MARK: Guardamos el core del juego o ponemos automático
        if gameCore == "Automático" {
            let mipath = juegosXml[columna][0]
            let filaArray = arrayGamesCores.firstIndex(where: {$0[0] == mipath})
            if filaArray != nil {
                arrayGamesCores.remove(at: filaArray!)
                let defaults = UserDefaults.standard
                defaults.set(arrayGamesCores, forKey: "juegosCores")
            }else {
                //No está en el array, no hacemos nada
            }
        } else {
            let newComand = gameCore
            let mipath = juegosXml[columna][0]
            let migrupo = [mipath, newComand!]
            let filaArray = arrayGamesCores.firstIndex(where: {$0[0] == mipath})
            if filaArray != nil {
                arrayGamesCores.remove(at: filaArray!)
                arrayGamesCores.append(migrupo)

            }else {
                print("no está")
                arrayGamesCores.append(migrupo)
            }
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesCores, forKey: "juegosCores")
        }

        //MARK: Guardamos el shader del juego o lo ponemos en Automático o Ninguno
        if gameShader == "Automático" {
            print("Automático")
            let rutajuego = juegosXml[columna][0]
            let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego})
            if filaABuscar != nil {
                arrayGamesShaders.remove(at: filaABuscar!)
                let defaults = UserDefaults.standard
                defaults.set(arrayGamesShaders, forKey: "juegosShaders")
            } else {

            }

        }
        if gameShader == "Ninguno" {
            let rutajuego = juegosXml[columna][0]
            let migrupo = [rutajuego, "Ninguno", "Ninguno"] as [String]
            if arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego}) != nil {
                let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego})
                arrayGamesShaders[filaABuscar!][1] = "Ninguno"
                arrayGamesShaders[filaABuscar!][2] = "Ninguno"
            }else {
                arrayGamesShaders.append(migrupo)
            }
            print(arrayGamesShaders)
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesShaders, forKey: "juegosShaders")
        }
        if gameShader != "Automático" && gameShader != "Ninguno"{

            print("NO Automático")
            let rutajuego = juegosXml[columna][0]
            let migrupo = [rutajuego, gameShaderName!, gameShader!] as [String]
            print(migrupo)
            if arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego}) != nil {
                let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego})
                arrayGamesShaders.remove(at: filaABuscar!)
                arrayGamesShaders.append(migrupo)
                
            }else {
                arrayGamesShaders.append(migrupo)
            }
            print(arrayGamesShaders)
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesShaders, forKey: "juegosShaders")
        }
        //MARK: Guardamos el valor de los bezels del sistema:
        if systemBezel == "Sí" {
            let filaAbuscar = arraySystemsBezels.firstIndex(where: {$0[0] == sistemaActual})
            if filaAbuscar != nil {
            } else {
                let miGrupo = [sistema, "Sí"]
                arraySystemsBezels.append(miGrupo)
            }
            
            let defaults = UserDefaults.standard
            defaults.set(arraySystemsBezels, forKey: "systemsBezels")
        } else {
            let filaAbuscar = arraySystemsBezels.firstIndex(where: {$0[0] == sistemaActual})
            if filaAbuscar != nil {
                arraySystemsBezels.remove(at: filaAbuscar!)
            } else {
            }
            let defaults = UserDefaults.standard
            defaults.set(arraySystemsBezels, forKey: "systemsBezels")
        }
        
        //MARK: Guardamos el valor de los bezels del juego:
        if gameBezel == "Automático"{
            let mijuego = juegosXml[columna][0]
            let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
            if filaenArray != nil {
                arrayGamesBezels.remove(at: filaenArray!)
            }
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        }
        if gameBezel == "Sí" {
            let mijuego = juegosXml[columna][0]
            let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
            if filaenArray != nil {
                arrayGamesBezels[filaenArray!][1] = "Sí"
            } else {
                let migrupo = [mijuego, "Sí"]
                arrayGamesBezels.append(migrupo)
            }
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        }
        if gameBezel == "No" {
            let mijuego = juegosXml[columna][0]
            let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
            if filaenArray != nil {
                arrayGamesBezels[filaenArray!][1] = "No"
            } else {
                let migrupo = [mijuego, "No"]
                arrayGamesBezels.append(migrupo)
            }
            let defaults = UserDefaults.standard
            defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        }
        if ventana == "Grid" {
            myCollectionView.reloadData()
            let indexPath:IndexPath = IndexPath(item: columna, section: 0)
            var set = Set<IndexPath>()
            set.insert(indexPath)
            myCollectionView.selectItems(at: set, scrollPosition: .top)
        } else {
            SingletonState.shared.mytable?.reloadData()
        }
        
    }
    
    @objc func favoritos(){
        if juegosXml[columna][19] == "FAV" {
            unfavGames()
        } else {
            favGames()
        }
    }
    
    @objc func favGames(){
        let mifila = columna
        juegosXml[mifila][19] = "FAV"
        let mifilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
        allTheGames[mifilaAll!].games[mifilaJuego!].fav = "FAV"
        xmlJuegosNuevos()
        let miJuego = juegosXml[columna][0]
        let miNombre = juegosXml[columna][1]
        let miDescripcion = juegosXml[columna][2]
        let miMapa = juegosXml[columna][3]
        let miManual = juegosXml[columna][4]
        let miNews = juegosXml[columna][5]
        let miTittleShot = juegosXml[columna][6]
        let miFanArt = juegosXml[columna][7]
        let miThumbnail = juegosXml[columna][8]
        let miImage = juegosXml[columna][9]
        let miVideo = juegosXml[columna][10]
        let miMarquee = juegosXml[columna][11]
        let miReleaseData = juegosXml[columna][12]
        let miDeveloper = juegosXml[columna][13]
        let miPublisher = juegosXml[columna][14]
        let miGenre = juegosXml[columna][15]
        let miLang = juegosXml[columna][16]
        let miPlayers = juegosXml[columna][17]
        let miRating = juegosXml[columna][18]
        let miFav = juegosXml[columna][19]
        let miComando = juegosXml[columna][20]
        let miCore = juegosXml[columna][21]
        let miSystem = juegosXml[columna][22]
        let miBox = juegosXml[columna][23]
        
        //Actualizar aaray de favoritos
        
        var datosDeMiJuego: Juego = Juego(path: String(miJuego), name: miNombre, description: miDescripcion, map: String(miMapa), manual: String(miManual), news: miNews, tittleshot: String(miTittleShot), fanart: String(miFanArt), thumbnail: String(miThumbnail), image: String(miImage), video: String(miVideo), marquee: String(miMarquee), releasedate: miReleaseData, developer: miDeveloper, publisher: miPublisher, genre: miGenre, lang: miLang, players: miPlayers, rating: miRating, fav: miFav, comando: miComando, core: miCore, system: miSystem, box: miBox)
        
        let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
        
        allTheGames[mifilafav!].games.append(datosDeMiJuego)
        //favImagen.isHidden = false
        
    }
    @objc func unfavGames(){
        if sistemaActual != "Favoritos" {
            let mifila = columna
            juegosXml[mifila][19] = ""
            let mifilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
            let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
            allTheGames[mifilaAll!].games[mifilaJuego!].fav = ""
            let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
            let miJuegoFav = allTheGames[mifilafav!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
            allTheGames[mifilafav!].games.remove(at: miJuegoFav!)
            xmlJuegosNuevos()
            //favImagen.isHidden = true
            //contextMenu.items[1].submenu?.items[2].isHidden = true
            //contextMenu.items[1].submenu?.items[1].isHidden = false
        }else {
            
            let mifila = columna
            var miarray = [[String]]()
            juegosXml[mifila][19] = ""
            let miSystem = String(juegosXml[mifila][22])
            let mifilaAll = allTheGames.firstIndex(where: {$0.sistema == miSystem})
            let miRomPath = allTheGames[mifilaAll!].rompath
            let mifilaJuego = allTheGames[mifilaAll!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
            allTheGames[mifilaAll!].games[mifilaJuego!].fav = ""
            for game in allTheGames[mifilaAll!].games {
                
                let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core]
                miarray.append(mijuego)
                
            }
            
            let mifilafav = allTheGames.firstIndex(where: {$0.fullname == "Favoritos"})
            let miJuegoFav = allTheGames[mifilafav!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
            allTheGames[mifilafav!].games.remove(at: miJuegoFav!)
            xmlJuegosNuevosFav(systema: miRomPath, arrayNuevo: miarray)
            //let indexSet = NSIndexSet(index: columna)
            //juegosTableView.removeRows(at: indexSet as IndexSet, withAnimation: .effectFade)
            //favImagen.isHidden = true
            
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
    
    @objc func deleteGameGrid(){
        let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
        let indexSet = NSIndexSet(index: columna)
        let miPath = juegosXml[columna][0]
        juegosXml.remove(at: columna)
        if ventana == "Grid" {
            myCollectionView.reloadData()
        } else {
            listado.reloadData()
        }
        
        
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
        if ventana == "Grid" {
            myCollectionView.reloadData()
        }
        if ventana == "Lista" {
            let indexSet = NSIndexSet(index: columna)
            listado.reloadData()
            listado.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        }
    }
    
    @objc func alertaBorrar(){
        let a = NSAlert()
        a.messageText = "¿Quieres borrar el Juego?"
        a.informativeText = "😱😱 ¿Estás seguro de borrar el Juego? 😱😱 ¡¡🤯🤯 Se eliminará para siempre de tu disco duro 🤯🤯!!"
        //   .alertFirstButtonReturn
        a.addButton(withTitle: "Borrar")
        
        //   .alertSecondButtonReturn
        a.addButton(withTitle: "Cancelar")
        a.alertStyle = .warning
        var w: NSWindow?
        if let window = view.window{
            w = window
        }
        else if let window = NSApplication.shared.windows.first{
            w = window
        }
        if let window = w{
            a.beginSheetModal(for: window){ (modalResponse) in
                if modalResponse == .alertFirstButtonReturn {
                    self.deleteGameGrid()
                    
                } else {
                    print("CANCELADO")
                }
            }
        }
    }
    
    func cambiarTitulo(NewName: String){
        let indexSet = NSIndexSet(index: columna)
        juegosXml[columna][1] = NewName
        let mifila = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        let mifilaJuego = allTheGames[mifila!].games.firstIndex(where: {$0.path == juegosXml[columna][0]})
        allTheGames[mifila!].games[mifilaJuego!].name = NewName
        
        xmlJuegosNuevos()
        if ventana == "Grid" {
            myCollectionView.reloadData()
        } else {
            listado.reloadData()
        }
        
        
        
        
    }
    
    @objc func alertaTitulo(){
        let a = NSAlert()
        a.messageText = "Cambiar Título del Juego"
        //a.informativeText = "😱😱 ¿Estás seguro de borrar el Juego? 😱😱 ¡¡🤯🤯 Se eliminará para siempre de tu disco duro 🤯🤯!!"
        
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        inputTextField.stringValue = juegosXml[columna][1]
        a.accessoryView = inputTextField
        
        //   .alertFirstButtonReturn
        a.addButton(withTitle: "Guardar")
        
        //   .alertSecondButtonReturn
        a.addButton(withTitle: "Cancelar")
        a.alertStyle = .warning
        var w: NSWindow?
        if let window = view.window{
            w = window
        }
        else if let window = NSApplication.shared.windows.first{
            w = window
        }
        if let window = w{
            a.beginSheetModal(for: window){ (modalResponse) in
                if modalResponse == .alertFirstButtonReturn {
                    self.cambiarTitulo(NewName: inputTextField.stringValue)
                    
                } else {
                    print("CANCELADO")
                }
            }
        }
    }
    
    func configNetplay () {
        editRetroArchConfig(param: "netplay_allow_pausing", value: "false")
        editRetroArchConfig(param: "netplay_max_connections", value: "6")
        let defaults = UserDefaults.standard
        let relayServer = defaults.string(forKey: "RelayServer") ?? "madrid"
        editRetroArchConfig(param: "netplay_mitm_server", value: relayServer)
        //editRetroArchConfig(param: "netplay_nickname", value: "BoBMac")
        editRetroArchConfig(param: "netplay_use_mitm_server", value: "true")
        writeRetroArchConfig()
        
        
    }
    
    func editRetroArchConfig (param: String, value: String ) {
        
        let mifila = retroArchConfig.firstIndex(where: {$0[0] == param})
        retroArchConfig[mifila!][1] = value
    
    }
    
    @objc func lanzarNetPlay() {
        
        let mifila = columna
        let mirom = "\"\(juegosXml[mifila][0])\""
        let nombredelarchivo = juegosXml[mifila][0].replacingOccurrences(of: rutaApp , with: "")
        var comandojuego = juegosXml[mifila][20]
        if comandojuego.contains("RetroArch") {
            
            gameShader(shader: "")
            noGameOverlay()
            let defaults = UserDefaults.standard
            let shaders = defaults.integer(forKey: "Shaders")
            print("SHADERS \(shaders)")
            if shaders == 1 {
                let juegoABuscar = juegosXml[columna][0]
                let miShader = checkShaders(juego: juegoABuscar)
                gameShader(shader: miShader)
            }
            let marcos = defaults.integer(forKey: "Marcos")
            
            if marcos == 1 {
                if checkBezels(juego: juegosXml[columna][0]) == true {
                    gameOverlay(game: nombredelarchivo)
                }
            }
            var micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
            
            var comando = micomando.replacingOccurrences(of: "%ROM%", with: mirom).replacingOccurrences(of: "-L", with: "-H -L")
            if playingVideo == true {
                SingletonState.shared.mySnapPlayer?.player?.pause()
                myPlayer.player?.pause()
            }
            print(comando)
            configNetplay()
            
            Commands.Bash.system("\(comando)")
            comando=""
            
        }
        
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
    
}
