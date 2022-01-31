//
//  funciones.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 05/01/2022.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation

func llenaSistemasIds() {
    var nes = ["nes", "3"]
    var segacd = ["segacd", "20"]
    var neogeo = ["neogeo", "142"]
    var snes = ["snes", "4"]
    var amstradcpc = ["amstradcpc", "65"]
    var n3do = ["3do", "29"]
    var amiga = ["amiga", "64"]
    var atari2600 = ["atari2600", "26"]
    var atari5200 = ["atari5200", "40"]
    var atari7800 = ["atari7800", "41"]
    var c64 = ["c64", "66"]
    var colecovision = ["colecovision", "48"]
    var pc = ["pc", "135"]
    var dreamcast = ["dreamcast", "23"]
    var gamegear = ["gamegear", "21"]
    var amstradgx4000 = ["amstradgx4000", "87"]
    var arcade = ["arcade", "75"]
    var mame = ["mame", "75"]
    var atari800 = ["atari800", "43"]
    var atarilynx = ["atarilynx", "28"]
    var atarist = ["atarist", "42"]
    var atomiswave = ["atomiswave", "53"]
    var wonderswan = ["wonderswan", "45"]
    var wonderswancolor = ["wonderswancolor", "46"]
    var cps1 = ["cps1", "75"]
    var cps2 = ["cps2", "75"]
    var cps3 = ["cps3", "75"]
    var c128 = ["c128", "66"]
    var c16 = ["c16", "66"]
    var vic20 = ["vic20", "73"]
    var pc9800 = ["pc-9800", "135"]
    var fbn = ["fbn", "75"]
    var msx = ["msx", "113"]
    var msx2 = ["msx2","116"]
    var odyssey2 = ["odyssey2", "104"]
    var intellivision = ["intellivision", "115"]
    var vectrex = ["vectrex", "102"]
    var pcengine = ["pcengine", "31"]
    var pcenginecd = ["pcenginecd", "114"]
    var pcfx = ["pcfx", "72"]
    var supergrafx = ["supergrafx", "105"]
    var tg16 = ["tg16","31"]
    var tg16cd = ["tg16cd", "31"]
    var n64 = ["n64", "14"]
    var famicom = ["famicom", "3"]
    var fds = ["fds", "106"]
    var gba = ["gba", "12"]
    var gbc = ["gbc", "10"]
    var gb = ["gb", "9"]
    var gameandwatch = ["gameandwatch", "52"]
    var sfc = ["sfc", "4"]
    var virtualboy = ["virtualboy", "11"]
    var videopac = ["videopac", "104"]
    var neocd = ["neocd", "70"]
    var ngp = ["ngp", "82"]
    var ngpc = ["ngpc", "82"]
    var scummvm = ["scummvm", "123"]
    var sega32x = ["sega32x", "19"]
    var genesis = ["genesis", "1"]
    var mastersystem = ["mastersystem", "2"]
    var megadrive = ["megadrive", "1"]
    var naomi = ["naomi", "56"]
    var sc3000 = ["sc-3000", "109"]
    var sg1000 = ["sg-1000", "109"]
    var saturn = ["saturn", "22"]
    var x68000 = ["x68000", "79"]
    var zxspectrum = ["zxspectrum", "76"]
    var zx81 = ["zx81", "77"]
    var psx = ["psx", "57"]
    var psp = ["psp", "61"]
    var uzebox = ["uzebox", "216"]
    var prboom = ["prboom", "135"]
    var tic80 = ["tic-80", "222"]
    var easyrpg = ["easyrpg", "231"]
    var supervision = ["supervision", "207"]
    var freej2me = ["freej2me", "1"]
    var karaoke = ["karaoke", "1"]
    var gamecube = ["gamecube", "13"]
    var wii = ["wii", "16"]
    var ps2 = ["ps2", "58"]
    var ps3 = ["ps3", "59"]
    var xbox = ["xbox", "32"]
    var nswitch = ["switch", "225"]
    
    systemsIds.append(nes)
    systemsIds.append(segacd)
    systemsIds.append(neogeo)
    systemsIds.append(snes)
    systemsIds.append(amstradcpc)
    systemsIds.append(n3do)
    systemsIds.append(amiga)
    systemsIds.append(atari2600)
    systemsIds.append(atari5200)
    systemsIds.append(atari7800)
    systemsIds.append(c64)
    systemsIds.append(colecovision)
    systemsIds.append(pc)
    systemsIds.append(dreamcast)
    systemsIds.append(gamegear)
    systemsIds.append(amstradgx4000)
    systemsIds.append(arcade)
    systemsIds.append(mame)
    systemsIds.append(atari800)
    systemsIds.append(atarilynx)
    systemsIds.append(atarist)
    systemsIds.append(atomiswave)
    systemsIds.append(wonderswan)
    systemsIds.append(wonderswancolor)
    systemsIds.append(cps1)
    systemsIds.append(cps2)
    systemsIds.append(cps3)
    systemsIds.append(c128)
    systemsIds.append(c16)
    systemsIds.append(vic20)
    systemsIds.append(pc9800)
    systemsIds.append(fbn)
    systemsIds.append(msx)
    systemsIds.append(msx2)
    systemsIds.append(odyssey2)
    systemsIds.append(intellivision)
    systemsIds.append(vectrex)
    systemsIds.append(pcengine)
    systemsIds.append(pcenginecd)
    systemsIds.append(pcfx)
    systemsIds.append(supergrafx)
    systemsIds.append(tg16)
    systemsIds.append(tg16cd)
    systemsIds.append(n64)
    systemsIds.append(famicom)
    systemsIds.append(fds)
    systemsIds.append(gba)
    systemsIds.append(gbc)
    systemsIds.append(gb)
    systemsIds.append(gameandwatch)
    systemsIds.append(sfc)
    systemsIds.append(virtualboy)
    systemsIds.append(videopac)
    systemsIds.append(neocd)
    systemsIds.append(ngp)
    systemsIds.append(ngpc)
    systemsIds.append(scummvm)
    systemsIds.append(sega32x)
    systemsIds.append(genesis)
    systemsIds.append(megadrive)
    systemsIds.append(mastersystem)
    systemsIds.append(naomi)
    systemsIds.append(sc3000)
    systemsIds.append(sg1000)
    systemsIds.append(saturn)
    systemsIds.append(x68000)
    systemsIds.append(zxspectrum)
    systemsIds.append(zx81)
    systemsIds.append(psx)
    systemsIds.append(psp)
    systemsIds.append(uzebox)
    systemsIds.append(prboom)
    systemsIds.append(tic80)
    systemsIds.append(easyrpg)
    systemsIds.append(supervision)
    systemsIds.append(freej2me)
    systemsIds.append(karaoke)
    systemsIds.append(gamecube)
    systemsIds.append(wii)
    systemsIds.append(ps2)
    systemsIds.append(ps3)
    systemsIds.append(wii)
    systemsIds.append(nswitch)
    
    
}

func mamelista() -> Any{
    //let ruta = "/users/pablojimenez/Documents/mamelist.txt"
    let ruta = Bundle.main.bundlePath + "/Contents/Resources/mamelist.txt"
    var miArray = [[String]]()
    let content = try! String (contentsOfFile: ruta)
    let lines = content.split(separator: "\n")
    for line in lines {
        //print(line)
        var valor1 = String()
        var valor2 = String()
        let misvalores = line.split(separator: ",")
        
        valor1 = String(misvalores[0])
        valor2 = String(misvalores[1])
        
        var group = [valor1 , valor2]
        //print(group)
        miArray.append(group)
        //print(miArray[0])
        //print("\(line)")
    }
    
    return miArray
    
}


func cuentajuegos(arraySistema: [[String]]) -> [[String]]{
    var juegosPorSistema = [[String]]()
    for sistema in arraySistema {
        var juegosenTotal = 0
        var rutaApp1 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "") + "/roms/\(sistema[0])"
        
        //var juegosnuevos = 0
        let pathXMLinterno2 = NSURL(string:  "file://" + rutaApp1 + "/gamelist.xml")
        if let pathXMLinterno2 = pathXMLinterno2, let data2 = try? Data(contentsOf: pathXMLinterno2 as URL )
        {
            let parser2 = GameParser(data: data2)
            for game in parser2.games
            {
                //                    var datosJuego = [String]()
                //                    let miJuego = String(game.path)
                //                    //let miNombre = String(game.name)
                //                    datosJuego = [String(miJuego) ]
                //                    juegosEnSistema.append(datosJuego)
                juegosenTotal += 1
                
                
            }
            
        }else{
            print("ERROR GARGANDO gamelist.xml en: \(String(describing: pathXMLinterno2))")
            juegosenTotal = 0
        }
        //    print("Nuevos: ")
        
        var migrupo2 = [String]()
        migrupo2 = [sistema[0], String(juegosenTotal)]
        
        juegosPorConsola.append(migrupo2)
        
        juegosPorSistema.append(migrupo2)
    }
    
    
    //print("Total: \(juegosEnSistema.count) Juegos en XML")
    //print(juegosPorConsola)
    //print(juegosPorSistema)
    
    return juegosPorSistema
}

func juegosGamelistCarga(sistema: [String]) -> [Juego] {
    arrayVideos = []
    var juegosnuevos = 0
    var miSistema = String(sistema[0])
    var miComando = String(sistema[3])
    var rutaApp3 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "") + "/roms/\(sistema[0])"
    let extensionesSistema = sistema[2].components(separatedBy: " ")
    var losJuegos: [Juego] = []
    juegosXml2 = []
    let pathXMLinterno2 = NSURL(string:  "file://" + rutaApp3 + "/gamelist.xml")
    if let pathXMLinterno2 = pathXMLinterno2, let data2 = try? Data(contentsOf: pathXMLinterno2 as URL )
    {
        let parser2 = GameParser(data: data2)
        for game in parser2.games
        {
            var datosJuego3 = [String]()
            
            let miJuego = siRutaRelativa2(ruta: String(game.path))
            let miNombre = String(game.name)
            let miDescripcion = String(game.desc)
            let miMapa = siRutaRelativa2(ruta:String(game.map))
            let miManual = siRutaRelativa2(ruta:String(game.manual))
            let miNews = siRutaRelativa2(ruta:String(game.news))
            let miTittleShot = siRutaRelativa2(ruta:String(game.tittleshot))
            let miFanArt = siRutaRelativa2(ruta:String(game.fanart))
            let miThumbnail = siRutaRelativa2(ruta:String(game.thumbnail))
            let miImage = siRutaRelativa2(ruta:String(game.image))
            let miVideo = siRutaRelativa2(ruta:String(game.video))
            let miMarquee = siRutaRelativa2(ruta:String(game.marquee))
            let miReleaseData = String(game.releasedata)
            let miDeveloper = String(game.developer)
            let miPublisher = String(game.publisher)
            let miGenre = String(game.genre)
            let miLang = String(game.lang)
            let miPlayers = String(game.players)
            let miRating = String(game.rating)
            let miFav = String(game.fav)
            let miBox = String(game.box)
            var datosDeMiJuego: Juego = Juego(path: String(miJuego), name: miNombre, description: miDescripcion, map: String(miMapa), manual: String(miManual), news: miNews, tittleshot: String(miTittleShot), fanart: String(miFanArt), thumbnail: String(miThumbnail), image: String(miImage), video: String(miVideo), marquee: String(miMarquee), releasedate: miReleaseData, developer: miDeveloper, publisher: miPublisher, genre: miGenre, lang: miLang, players: miPlayers, rating: miRating, fav: miFav, comando: miComando, core: "", system: miSistema, box: miBox)
            
            datosJuego3 = [String(miJuego) , miNombre, miDescripcion, String(miMapa), String(miManual), miNews, String(miTittleShot), String(miFanArt), String(miThumbnail), String(miImage), String(miVideo), String(miMarquee), miReleaseData, miDeveloper, miPublisher, miGenre, miLang, miPlayers, miRating, miFav,  miComando ]
            if miFav == "FAV" {
                favoritos.append(datosDeMiJuego)
                if miVideo != "" {
                    arrayVideosFav.append(miVideo)
                }
            }
            juegosXml2.append(datosJuego3)
            losJuegos.append(datosDeMiJuego)
            if miVideo != "" {
                arrayVideos.append(miVideo)
            }
            //return datosJuego3
            
            
        }
        
    }else{
        print("ERROR GARGANDO gamelist.xml en: \(String(describing: pathXMLinterno2))")
    }
    print("Nuevos: ")
    for extensiones in extensionesSistema {
        
        
        let fileManager = FileManager.default
        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: rutaApp3 as String)!
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(extensiones) { // checks the extension
                
                let rutacompleta = rutaApp3 + "/" + element
                var encuentra = false
                for juego in juegosXml2 {
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
                    let name = (String(element) as NSString).deletingPathExtension
                    var datosJuegoNoXml = [String]()
                    var datosDeMiJuego: Juego = Juego(path: rutacompleta, name: name, description: "", map: "", manual: "", news: "", tittleshot: "", fanart: "", thumbnail: "", image: "", video: "", marquee: "", releasedate: "", developer: "", publisher: "", genre: "", lang: "", players: "", rating: "", fav: "", comando: miComando, core: "", system: miSistema, box: "")
                    datosJuegoNoXml = [rutacompleta , String(element), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" , miComando]
                    juegosXml2.append(datosJuegoNoXml)
                    losJuegos.append(datosDeMiJuego)
                }
                
            }
        }
        
    }
    if juegosnuevos >= 1 {
        print(juegosnuevos)
        xmlJuegosNuevos2(ruta: rutaApp3)
    }
    //print("PRUEBA Total: \(losJuegos.count) Juegos en XML")
    juegosXml2.sort(by: {($0[1] ) < ($1[1] ) })
    //
    
    
    //allTheGames.append(miGrupo)
    //print(miGrupo)
    return losJuegos
}

func siRutaRelativa2(ruta: String) -> String {
    var rutaAbsoluta = ""
    if ruta.hasPrefix("./") {
        rutaAbsoluta = String(String(ruta).dropFirst())
    }else{
        rutaAbsoluta = ruta
    }
    return rutaAbsoluta
}
func xmlJuegosNuevos2(ruta: String){
    print("Crear XML añadiendo Juegos Nuevos")
    var nuevoGamelist = ruta + "/gamelist.xml"
    let root = XMLElement(name: "gameList")
    let xml = XMLDocument(rootElement: root)
    for juego in juegosXml2 {
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
        let favNode = XMLElement(name: "fav", stringValue: "")
        let boxNode = XMLElement(name: "box", stringValue: "")
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
    
    print("TOTAL: \(juegosXml2.count) Juegos en Total")
    do{
        try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
    }catch {}
}

func crearGameListInicioCarga (ruta: String){
    var counter = 0
    var nuevoGamelist = ruta + "/gamelist.xml"
    let root = XMLElement(name: "gameList")
    let xml = XMLDocument(rootElement: root)
    
    //print(xml.xmlString)
    for extensiones in extensionesTemp {
        
        let fileManager = FileManager.default
        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(extensiones) { // checks the extension
                counter += 1
                let gameNode = XMLElement(name: "game")
                root.addChild(gameNode)
                let pathNode = XMLElement(name: "path", stringValue: ruta + "/" + element)
                let filename = element
                let name = (filename as NSString).deletingPathExtension
                let nameNode = XMLElement(name: "name", stringValue: name)
                let descNode = XMLElement(name: "desc")
                let mapNode = XMLElement(name: "map")
                let manualNode = XMLElement(name: "manual")
                let newsNode = XMLElement(name: "news")
                let tittleshotNode = XMLElement(name: "tittleshot")
                let fanartNode = XMLElement(name: "fanart")
                let thumbnailNode = XMLElement(name: "thumbnail")
                let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: element, ruta: ruta) )
                let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: element, ruta: ruta) )
                let marqueeNode = XMLElement(name: "marquee")
                let releasedateNode = XMLElement(name: "releasedate")
                let developerNode = XMLElement(name: "developer")
                let publisherNode = XMLElement(name: "publisher")
                let genreNode = XMLElement(name: "genre")
                let langNode = XMLElement(name: "lang")
                let playersNode = XMLElement(name: "players")
                let ratingNode = XMLElement(name: "rating")
                let favNode = XMLElement(name: "fav")
                let boxNode = XMLElement(name: "box")
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
        }
        
    }
    let xmlData = xml.xmlData(options: .nodePrettyPrint)
    
    print("TOTAL: \(counter) Juegos")
    do{
        try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
    }catch {}
    
    
}

func escribeSistemas () {
    let root = XMLElement(name: "systemList")
    let xml = XMLDocument(rootElement: root)
    //Loop
    //stringByAppendingPathComponent(name)
    let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url2 = NSURL(fileURLWithPath: path2)
    let pathComponent = url2.appendingPathComponent("/RetroMac/es_systems_mac.cfg")
    for consolaRaw in allTheSystems {
        
        let systemNode = XMLElement(name: "system")
        root.addChild(systemNode)
        let shortNameNode = XMLElement(name: "name", stringValue: consolaRaw.nombrecorto)
        let fullNameNode = XMLElement(name: "fullname", stringValue: consolaRaw.nombrelargo)
        let pathNode = XMLElement(name: "path", stringValue: consolaRaw.rompath)
        let extensionNode = XMLElement(name: "extension", stringValue: consolaRaw.extensions)
        let commandNode = XMLElement(name: "command", stringValue: consolaRaw.comando)
        let platformNode = XMLElement(name: "platform", stringValue: consolaRaw.platform)
        let themeNode = XMLElement(name: "theme", stringValue: consolaRaw.theme)
        var emuladoresNode = XMLElement(name: "emuladores")
        if consolaRaw.emuladores.count > 0 {
            //loop para añadir cores
            for core in consolaRaw.emuladores {
                let miEmulador = core[0]
                let miCore = core [1]
                let miComando = core[2]
                let emu = XMLElement(name: "emu", stringValue: miComando)
                emu.addAttribute(XMLNode.attribute(withName: "name", stringValue: miEmulador) as! XMLNode)
                emu.addAttribute(XMLNode.attribute(withName: "core", stringValue: miCore) as! XMLNode)
                emuladoresNode.addChild(emu)
            }
        }
        systemNode.addChild(shortNameNode)
        systemNode.addChild(fullNameNode)
        systemNode.addChild(pathNode)
        systemNode.addChild(extensionNode)
        systemNode.addChild(commandNode)
        systemNode.addChild(platformNode)
        systemNode.addChild(themeNode)
        if consolaRaw.emuladores.count > 0 {
            systemNode.addChild(emuladoresNode)
        }
    }
    let pathXMLinterno = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg")
    //let url = URL (fileURLWithPath: pathXMLinterno!)
    let xmlData = xml.xmlData(options: .nodePrettyPrint)
    let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
    var nuevoGamelist = rutaApp2 + "/systems_test.xml"
    do{
        try? xmlData.write(to: pathComponent!)
        print("EXITO")
        
    }catch {print("ERROR")}
    
}

