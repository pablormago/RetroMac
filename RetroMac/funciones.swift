//
//  funciones.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 05/01/2022.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import GameController
import Commands

func llenaSistemasIds() {
    let nes = ["nes", "3"]
    let segacd = ["segacd", "20"]
    //var neogeo = ["neogeo", "142"]
    let neogeo = ["neogeo", "75"]
    let snes = ["snes", "4"]
    let amstradcpc = ["amstradcpc", "65"]
    let n3do = ["3do", "29"]
    let amiga = ["amiga", "64"]
    let atari2600 = ["atari2600", "26"]
    let atari5200 = ["atari5200", "40"]
    let atari7800 = ["atari7800", "41"]
    let c64 = ["c64", "66"]
    let colecovision = ["colecovision", "48"]
    let pc = ["pc", "135"]
    let dreamcast = ["dreamcast", "23"]
    let gamegear = ["gamegear", "21"]
    let amstradgx4000 = ["amstradgx4000", "87"]
    let arcade = ["arcade", "75"]
    let mame = ["mame", "75"]
    let atari800 = ["atari800", "43"]
    let atarilynx = ["atarilynx", "28"]
    let atarist = ["atarist", "42"]
    let atomiswave = ["atomiswave", "53"]
    let wonderswan = ["wonderswan", "45"]
    let wonderswancolor = ["wonderswancolor", "46"]
    let cps1 = ["cps1", "75"]
    let cps2 = ["cps2", "75"]
    let cps3 = ["cps3", "75"]
    let c128 = ["c128", "66"]
    let c16 = ["c16", "66"]
    let vic20 = ["vic20", "73"]
    let pc9800 = ["pc-9800", "135"]
    let fbn = ["fbn", "75"]
    let msx = ["msx", "113"]
    let msx2 = ["msx2","116"]
    let odyssey2 = ["odyssey2", "104"]
    let intellivision = ["intellivision", "115"]
    let vectrex = ["vectrex", "102"]
    let pcengine = ["pcengine", "31"]
    let pcenginecd = ["pcenginecd", "114"]
    let pcfx = ["pcfx", "72"]
    let supergrafx = ["supergrafx", "105"]
    let tg16 = ["tg16","31"]
    let tg16cd = ["tg16cd", "31"]
    let n64 = ["n64", "14"]
    let famicom = ["famicom", "3"]
    let fds = ["fds", "106"]
    let gba = ["gba", "12"]
    let gbc = ["gbc", "10"]
    let gb = ["gb", "9"]
    let gameandwatch = ["gameandwatch", "52"]
    let sfc = ["sfc", "4"]
    let virtualboy = ["virtualboy", "11"]
    let videopac = ["videopac", "104"]
    let neocd = ["neocd", "70"]
    let ngp = ["ngp", "82"]
    let ngpc = ["ngpc", "82"]
    let scummvm = ["scummvm", "123"]
    let sega32x = ["sega32x", "19"]
    let genesis = ["genesis", "1"]
    let mastersystem = ["mastersystem", "2"]
    let megadrive = ["megadrive", "1"]
    let naomi = ["naomi", "56"]
    let sc3000 = ["sc-3000", "109"]
    let sg1000 = ["sg-1000", "109"]
    let saturn = ["saturn", "22"]
    let x68000 = ["x68000", "79"]
    let zxspectrum = ["zxspectrum", "76"]
    let zx81 = ["zx81", "77"]
    let psx = ["psx", "57"]
    let psp = ["psp", "61"]
    let uzebox = ["uzebox", "216"]
    let prboom = ["prboom", "135"]
    let tic80 = ["tic-80", "222"]
    let easyrpg = ["easyrpg", "231"]
    let supervision = ["supervision", "207"]
    let freej2me = ["freej2me", "1"]
    let karaoke = ["karaoke", "1"]
    let gamecube = ["gamecube", "13"]
    let wii = ["wii", "16"]
    let ps2 = ["ps2", "58"]
    let ps3 = ["ps3", "59"]
    let xbox = ["xbox", "32"]
    let nswitch = ["switch", "225"]
    let n3ds = ["n3ds", "17"]
    
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
    systemsIds.append(n3ds)
    systemsIds.append(xbox)
    
    
    
}

func NetPlayCores () {
    NetCores = [ ["81_libretro.dylib" , "81"],
                 ["blastem_libretro.dylib" , "BlastEm"],
                 ["bsnes_hd_beta_libretro.dylib" , "bsnes-hd beta"],
                 ["bsnes_libretro.dylib" , "bsnes"],
                 ["bsnes_mercury_accuracy_libretro.dylib" , "bsnes-mercury Accuracy"],
                 ["bsnes_mercury_balanced_libretro.dylib" , "bsnes-mercury Balanced"],
                 ["bsnes_mercury_performance_libretro.dylib" , "bsnes-mercury Performance"],
                 ["bsnes2014_accuracy_libretro.dylib" , "bsnes 2014 Accuracy"],
                 ["bsnes2014_balanced_libretro.dylib" , "bsnes 2014 Balanced"],
                 ["bsnes2014_cplusplus98_libretro.dylib" , "bsnes C++98 (v085)"],
                 ["bsnes2014_performance_libretro.dylib" , "bsnes-mercury Performance"],
                 ["cap32_libretro.dylib" , "Caprice32"],
                 ["desmume_libretro.dylib" , "DeSmuME"],
                 ["fbalpha_cps1_libretro.dylib" , "FB Alpha 2012 CPS-1"],
                 ["fbalpha_cps2_libretro.dylib" , "FB Alpha 2012 CPS-2"],
                 ["fbalpha_cps3_libretro.dylib" , "FB Alpha 2012 CPS-3"],
                 ["fbalpha2012_libretro.dylib" , "FB Alpha 2012"],
                 ["fbalpha2012_neogeo_libretro.dylib" , "FB Alpha 2012 Neo Geo"],
                 ["fbneo_libretro.dylib" , "FinalBurn Neo"],
                 ["fceumm_libretro.dylib" , "FCEUmm"],
                 ["gearsystem_libretro.dylib" , "Gearsystem"],
                 ["genesis_plus_gx_libretro.dylib" , "Genesis Plus GX"],
                 ["genesis_plus_gx_wide_libretro.dylib" , "Genesis Plus GX Wide"],
                 ["handy_libretro.dylib" , "Handy"],
                 ["higan_sfc_libretro.dylib" , "nSide (Super Famicom Accuracy)"],
                 ["mame_libretro.dylib" , "MAME (Git)"],
                 ["mame2003_libretro.dylib" , "MAME 2003 (0.78)"],
                 ["mame2003_plus_libretro.dylib" , "MAME 2003-Plus"],
                 ["mame2010_libretro.dylib" , "MAME 2010 (0.139)"],
                 ["mame2010_libretro.dylib" , "MAME 2010"],
                 ["mednafen_gba_libretro.dylib" , "Beetle GBA"],
                 ["mednafen_lynx_libretro.dylib" , "Beetle Lynx"],
                 ["mednafen_ngp_libretro.dylib" , "Beetle NeoPop"],
                 ["mednafen_pce_fast_libretro.dylib" , "Beetle PCE Fast"],
                 ["mednafen_pce_libretro.dylib" , "Beetle PCE"],
                 ["mednafen_pcfx_libretro.dylib" , "Beetle PC-FX"],
                 ["mednafen_snes_libretro.dylib" , "Beetle bsnes"],
                 ["mednafen_vb_libretro.dylib" , "Beetle VB"],
                 ["mednafen_wswan_libretro.dylib" , "Beetle WonderSwan"],
                 ["mesen_libretro.dylib" , "Mesen"],
                 ["mesen-s_libretro.dylib" , "Mesen-S"],
                 ["nestopia_libretro.dylib" , "Nestopia"],
                 ["np2kai_libretro.dylib" , "Neko Project II Kai"],
                 ["opera_libretro.dylib" , "Opera"],
                 ["parallel_n64_libretro.dylib" , "ParaLLEl N64"],
                 ["pcsx_rearmed_libretro.dylib" , "PCSX-ReARMed"],
                 ["picodrive_libretro.dylib" , "PicoDrive"],
                 ["potator_libretro.dylib" , "Potator"],
                 ["px68k_libretro.dylib" , "PX68k"],
                 ["quicknes_libretro.dylib" , "QuickNES"],
                 ["race_libretro.dylib" , "RACE"],
                 ["sameboy_libretro.dylib" , "SameBoy"],
                 ["snes9x_libretro.dylib" , "Snes9x"],
                 ["snes9x2002_libretro.dylib" , "Snes9x 2002"],
                 ["snes9x2005_libretro.dylib" , "Snes9x 2005"],
                 ["snes9x2005_plus_libretro.dylib" , "Snes9x 2005 Plus"],
                 ["snes9x2010_libretro.dylib" , "Snes9x 2010"],
                 ["stella_libretro.dylib" , "Stella"],
                 ["stella2014_libretro.dylib" , "Stella 2014"],
                 ["tgbdual_libretro.dylib" , "TGB Dual"],
                 ["theodore_libretro.dylib" , "theodore"],
                 ["vba_next_libretro.dylib" , "VBA Next"],
                 ["vbam_libretro.dylib" , "VBA-M"],
                 ["flycast_libretro.dylib", "Flycast"],
                 ["2048_libretro.dylib" , "2048"],
                 ["mgba_libretro.dylib" , "mGBA"],
                 ["mednafen_psx_hw_libretro.dylib" , "Beetle PSX HW"]
    ]
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
    var mirompath = String(sistema[5])
    var miSistema = String(sistema[0])
    var miComando = String(sistema[3])
    var rutaApp3 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "") + mirompath
    rutaTransformada = rutaApp3
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
            
            datosJuego3 = [String(miJuego) , miNombre, miDescripcion, String(miMapa), String(miManual), miNews, String(miTittleShot), String(miFanArt), String(miThumbnail), String(miImage), String(miVideo), String(miMarquee), miReleaseData, miDeveloper, miPublisher, miGenre, miLang, miPlayers, miRating, miFav,  miComando, miBox]
            
            let fileDoesExist = FileManager.default.fileExists(atPath: String(miJuego))
            if fileDoesExist {
                if miFav == "FAV" {
                    favoritos.append(datosDeMiJuego)
                    if miVideo != "" {
                        arrayVideosFav.append(miVideo)
                    }
                }
                juegosXml2.append(datosJuego3)
                losJuegos.append(datosDeMiJuego)
                if String(miVideo) != "" {
                    arrayVideos.append(miVideo)
                }
                
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
                    var datosDeMiJuego: Juego = Juego(path: rutacompleta, name: name, description: "", map: "", manual: buscaManual(juego: name, ruta: rutaApp3), news: "", tittleshot: buscaTittleShot(juego: name, ruta: rutaApp3), fanart: buscaFanArt(juego: name, ruta: rutaApp3), thumbnail: buscaImage(juego: name, ruta: rutaApp3), image: buscaImage(juego: name, ruta: rutaApp3), video: buscaVideo(juego: name, ruta: rutaApp3), marquee: buscaMarquee(juego: name, ruta: rutaApp3), releasedate: "", developer: "", publisher: "", genre: "", lang: "", players: "", rating: "", fav: "", comando: miComando, core: "", system: miSistema, box: buscaBox(juego: name, ruta: rutaApp3))
                    datosJuegoNoXml = [rutacompleta , name, "", "", buscaManual(juego: name, ruta: rutaApp3), "", buscaTittleShot(juego: name, ruta: rutaApp3), buscaFanArt(juego: name, ruta: rutaApp3), buscaImage(juego: name, ruta: rutaApp3), buscaImage(juego: name, ruta: rutaApp3), buscaVideo(juego: name, ruta: rutaApp3), buscaMarquee(juego: name, ruta: rutaApp3), "", "", "", "", "", "", "" , buscaBox(juego: name, ruta: rutaApp3)]
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
        rutaAbsoluta = rutaTransformada +  String(String(ruta).dropFirst())
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
        let pathNode = XMLElement(name: "path", stringValue: rutaARelativa(ruta: juego[0]))
        //Hay que formatearlos asi: .\(juego[0].replacingOccurrences(of: rutaTransformada, with: ""))")
        let filename = juego[1]
        let name = (filename as NSString).deletingPathExtension
        let nameNode = XMLElement(name: "name", stringValue: name)
        let descNode = XMLElement(name: "desc", stringValue: rutaARelativa(ruta: juego[2]))
        let mapNode = XMLElement(name: "map", stringValue: rutaARelativa(ruta: juego[3]))
        let manualNode = XMLElement(name: "manual", stringValue: rutaARelativa(ruta: juego[4]))
        let newsNode = XMLElement(name: "news",  stringValue: juego[5])
        let tittleshotNode = XMLElement(name: "tittleshot", stringValue: rutaARelativa(ruta: juego[6]))
        let fanartNode = XMLElement(name: "fanart", stringValue: rutaARelativa(ruta: juego[7]))
        let thumbnailNode = XMLElement(name: "thumbnail", stringValue: rutaARelativa(ruta: juego[8]))
        let imageNode = XMLElement(name: "image", stringValue: rutaARelativa(ruta: juego[9]))
        //let imageNode = XMLElement(name: "image", stringValue: juego[9] )
        let videoNode = XMLElement(name: "video", stringValue: rutaARelativa(ruta: juego[10]))
        //let videoNode = XMLElement(name: "video", stringValue: juego[10] )
        let marqueeNode = XMLElement(name: "marquee", stringValue: rutaARelativa(ruta: juego[11]))
        let releasedateNode = XMLElement(name: "releasedate",  stringValue: juego[12])
        let developerNode = XMLElement(name: "developer", stringValue: juego[13])
        let publisherNode = XMLElement(name: "publisher", stringValue: juego[14])
        let genreNode = XMLElement(name: "genre", stringValue: juego[15])
        let langNode = XMLElement(name: "lang", stringValue: juego[16])
        let playersNode = XMLElement(name: "players", stringValue: juego[17])
        let ratingNode = XMLElement(name: "rating", stringValue: juego[18])
        let favNode = XMLElement(name: "fav", stringValue: "")
        let boxNode = XMLElement(name: "box", stringValue: rutaARelativa(ruta: juego[19]))
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
                let manualNode = XMLElement(name: "manual",stringValue: buscaManual(juego: name, ruta: ruta))
                let newsNode = XMLElement(name: "news")
                let tittleshotNode = XMLElement(name: "tittleshot",stringValue: buscaTittleShot(juego: name, ruta: ruta))
                let fanartNode = XMLElement(name: "fanart",stringValue: buscaFanArt(juego: name, ruta: ruta))
                let thumbnailNode = XMLElement(name: "thumbnail", stringValue: buscaImage(juego: name, ruta: ruta))
                let imageNode = XMLElement(name: "image", stringValue: buscaImage(juego: name, ruta: ruta) )
                let videoNode = XMLElement(name: "video", stringValue: buscaVideo(juego: name, ruta: ruta) )
                let marqueeNode = XMLElement(name: "marquee",stringValue: buscaMarquee(juego: name, ruta: ruta))
                let releasedateNode = XMLElement(name: "releasedate")
                let developerNode = XMLElement(name: "developer")
                let publisherNode = XMLElement(name: "publisher")
                let genreNode = XMLElement(name: "genre")
                let langNode = XMLElement(name: "lang")
                let playersNode = XMLElement(name: "players")
                let ratingNode = XMLElement(name: "rating")
                let favNode = XMLElement(name: "fav")
                let boxNode = XMLElement(name: "box",stringValue: buscaBox(juego: name, ruta: ruta))
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
        //try? xmlData.write(to: URL(fileURLWithPath: nuevoGamelist))
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

func buscaImage (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miFoto = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if (element.hasSuffix(".png") || element.hasSuffix(".jpg") || element.hasSuffix(".jpeg") ) && !element.contains("marquee") && !element.contains("box") && !element.contains("fanart") && !element.contains("tittleshot"){
                    tieneSnap = true
                    miFoto = ruta + "/" + element
                    break
                }
            }
            else {
                miFoto = ""
                tieneSnap = false
            }
        }
        
        return miFoto
    } else {
        return ""
    }
    
    
}

func buscaManual (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miManual = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if element.hasSuffix(".pdf"){
                    tieneSnap = true
                    miManual = ruta + "/" + element
                    break
                }
            }
            else {
                miManual = ""
                tieneSnap = false
            }
        }
        
        return miManual
    } else {
        return ""
    }
    
    
}

func buscaTittleShot (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miTittleShot = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if element.hasSuffix("_tittleshot.png"){
                    tieneSnap = true
                    miTittleShot = ruta + "/" + element
                    break
                }
            }
            else {
                miTittleShot = ""
                tieneSnap = false
            }
        }
        
        return miTittleShot
    } else {
        return ""
    }
    
    
}

func buscaFanArt (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miFanArt = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if element.hasSuffix("_fanart.png"){
                    tieneSnap = true
                    miFanArt = ruta + "/" + element
                    break
                }
            }
            else {
                miFanArt = ""
                tieneSnap = false
            }
        }
        
        return miFanArt
    } else {
        return ""
    }
    
    
}

func buscaMarquee (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miMarquee = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if element.hasSuffix("marquee.png"){
                    tieneSnap = true
                    miMarquee = ruta + "/" + element
                    break
                }
            }
            else {
                miMarquee = ""
                tieneSnap = false
            }
        }
        
        return miMarquee
    } else {
        return ""
    }
    
    
}
func buscaBox (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miBox = ""
    let fileManager = FileManager.default
    //print("MI ROMPATH: \(ruta)")
    
    if ruta != "" && ruta != nil && buscarLocal == true {
        let enumerator2: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: ruta as String)!
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        while let element = enumerator2.nextObject() as? String {
            
            if element.contains(name) || element.contains(name.replacingOccurrences(of: " ", with: "")){
                if element.hasSuffix("_box.png"){
                    tieneSnap = true
                    miBox = ruta + "/" + element
                    break
                }
            }
            else {
                miBox = ""
                tieneSnap = false
            }
        }
        
        return miBox
    } else {
        return ""
    }
    
    
}

func rutaARelativa (ruta: String) -> String {
    var rutarelativa = String()
    if ruta != "" {
        rutarelativa = "." + ruta.replacingOccurrences(of: rutaTransformada, with: "")
    }else {
        rutarelativa = ""
    }
    
    return rutarelativa
}

func readRetroArchConfig () {
    let applicationSupportFolderURL = try! (FileManager.default.urls(for: .applicationSupportDirectory,
                                                                        in: .userDomainMask)).first
    let retroarchfolder = applicationSupportFolderURL?.appendingPathComponent("RetroArch/config/retroarch.cfg")
    
    let home = try! (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    
    // add a filename
    let fileUrl = home?.appendingPathComponent("RetroArch/config/retroarch.cfg")
    
    
    // make sure the file exists
    guard FileManager.default.fileExists(atPath: (fileUrl?.path)!) else {
        preconditionFailure("file expected at \(fileUrl?.absoluteString) is missing")
    }
    
    // open the file for reading
    // note: user should be prompted the first time to allow reading from this location
    guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileUrl?.path,"r") else {
        preconditionFailure("Could not open file at \(fileUrl?.absoluteString)")
    }
    
    // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
    var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
    
    // see the official Swift documentation for more information on the `defer` statement
    // https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_defer-statement
    defer {
        // remember to close the file when done
        fclose(filePointer)
        
        // The buffer should be freed by even if getline() failed.
        lineByteArrayPointer?.deallocate()
    }
    
    // the smallest multiple of 16 that will fit the byte array for this line
    var lineCap: Int = 0
    
    // initial iteration
    var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    
    
    while (bytesRead > 0) {
        
        // note: this translates the sequence of bytes to a string using UTF-8 interpretation
        let lineAsString = String.init(cString:lineByteArrayPointer!)
        
        // do whatever you need to do with this single line of text
        // for debugging, can print it
        //print(lineAsString)
        let myparams = lineAsString.split(separator: "=")
        var myparam1 = String((myparams[0]).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "")).dropLast()
        let myparam2 = String((myparams[1]).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "")).dropFirst()
        var p1 = String()
        var p2 = String()
        p1 = String(myparam1)
        p2 = String(myparam2)
        let arrayLine = [p1 , p2]
        //print("Parametro: \(p1) - Valor: \(p2)")
        retroArchConfig.append(arrayLine)
        
        // updates number of bytes read, for the next iteration
        bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    }
    
    //print(retroArchConfig)
}

func writeRetroArchConfig () {
    //"input_overlay_aspect_adjust_landscape = 0.130000"
    //    let mifila = retroArchConfig.firstIndex(where: {$0[0] == param})
    //    retroArchConfig[mifila!][1] = value
    var mytext = String()
    mytext = ""
    for line in retroArchConfig {
        mytext = mytext + line[0] + " = \"" + line[1] + "\"\n"
        
    }
    let home = try! (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    let fileUrl = home?.appendingPathComponent("RetroArch/config/retroarch.cfg")
    try! mytext.write(to: fileUrl!, atomically: false, encoding: .utf8)
    
    
}

func gameShader(shader: String) {
    var mytext = String()
    mytext = ""
    mytext = mytext + "shaders = \"1\"" + "\n"
    mytext = mytext + "shader0 = \"\(shader)\""
    print(mytext)
    let home = try! (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    let fileUrl = home?.appendingPathComponent("RetroArch/config/global.glslp")
    try! mytext.write(to: fileUrl!, atomically: false, encoding: .utf8)
    
    
}

func gameOverlay(game: String) {
    
    let index2 = game.range(of: "/", options: .backwards)?.lowerBound
    let substring2 = game.substring(from: index2! )
    let result1 = String(substring2.dropFirst())
    let solonombre =  (result1 as NSString).deletingPathExtension
    let gamename = solonombre
    let miruta = rutaApp + "/decorations/"
    let fileManager = FileManager.default
    let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: miruta as String)!
    var rutaoverlay = String()
    while let element = enumerator.nextObject() as? String {
        if element.contains(gamename + ".png") {
            rutaoverlay = miruta + element
            break
        }
    }
    
    if rutaoverlay == "" {
        let filaConsola = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        if filaConsola != nil {
            let sistemaABuscar = allTheGames[filaConsola!].sistema
            let miruta = rutaApp + "/decorations/"
            let fileManager = FileManager.default
            let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: miruta as String)!
            while let element = enumerator.nextObject() as? String {
                if element.contains(sistemaABuscar + ".png") {
                    rutaoverlay = miruta + element
                    break
                }
            }
        }
    }
    
    var myOverlayGame = "overlays = 1" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_overlay = " + "\"\(rutaoverlay)\" \n"
    myOverlayGame = myOverlayGame + "overlay0_full_screen = true" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_descs = 0"
    
    //input_overlay_opacity = "1.000000" en retroarch config
    
    
    let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url2 = NSURL(fileURLWithPath: path2)
    let pathComponent = url2.appendingPathComponent("RetroMac/custom_overlay.cfg")
    //let filePath = pathComponent?.path
    
    try! myOverlayGame.write(to: pathComponent!, atomically: false, encoding: .utf8)
    
    
}

func noGameOverlay() {
    
    
    var myOverlayGame = "overlays = 1" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_overlay = " + "\"\" \n"
    myOverlayGame = myOverlayGame + "overlay0_full_screen = true" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_descs = 0" + "\n"
    myOverlayGame = myOverlayGame + "shaders = 1" + "\n"
    myOverlayGame = myOverlayGame + "video_shader = \"/Users/pablojimenez/Documents/RetroMac/shaders/zfast_crt.glsl\"" + "\n"
    myOverlayGame = myOverlayGame + "filter_linear0 = true"
    
    
    let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url2 = NSURL(fileURLWithPath: path2)
    let pathComponent = url2.appendingPathComponent("RetroMac/custom_overlay.cfg")
    //let filePath = pathComponent?.path
    try! myOverlayGame.write(to: pathComponent!, atomically: false, encoding: .utf8)
}

func cargaPartidasNetplay () {
    netplayPlays = []
    NetPlayCores()
    let datasource = "http://lobby.libretro.com/list"
    guard let url = URL(string: datasource) else {
        return
    }
    guard let data = try? String(contentsOf: url) else {
        return
    }
    var feed: JSON?
    let newFeed = JSON(parseJSON: data)
    feed = newFeed
    for (_,primJson):(String, JSON) in feed! {
        for (node, subJson):(String, JSON) in primJson {
            var comando = String()
            var gamePath = String()
            var gameIsInTheList = String()
            var datosdelJuego = [String]()
            var coreInMac = Bool()
            var milinea = NetCores.firstIndex(where: {$0[1] == subJson["core_name"].stringValue}) ?? 10000000
            var dylibcore = String()
            var isRelay = String()
            
            if subJson["mitm_ip"].stringValue != "" {
                isRelay = "SI"
            } else  {
                isRelay = "NO"
            }
            
            if milinea != 10000000 {
                dylibcore = NetCores[milinea][0]
                print("Archivo Core: \(dylibcore)")
            } else {
                dylibcore = "N/A"
            }
            var parametrosJuego = comprobarJuegoNetPlay(juego: subJson["game_name"].stringValue, corepartida: dylibcore)
            var tengoJuego: Bool = parametrosJuego.resultado
            var habilitado = String()
            
            if milinea != 10000000 {
                coreInMac = true
            }else {
                coreInMac = false
                print("Core no Disponible en Mac OsX: \(subJson["core_name"].stringValue)")
            }
            
            if tengoJuego == true && coreInMac == true {
                habilitado = "SI"
            } else {
                habilitado = "NO"
            }
            
            var datosPartida: PartidaNetplay = PartidaNetplay(id: Int(subJson["id"].stringValue), username: subJson["username"].stringValue, country: subJson["country"].stringValue, game_Name: subJson["game_name"].stringValue, game_Crc: subJson["game_crc"].stringValue, core_Name: subJson["core_name"].stringValue, core_Version:  subJson["core_version"].stringValue, subsystem_Name: subJson["subsystem_name"].stringValue, retroarch_Version: subJson["retroarch_version"].stringValue, frontend: subJson["frontend"].stringValue, ip: subJson["ip"].stringValue, port: subJson["port"].stringValue, mitm_Ip: subJson["mitm_ip"].stringValue, mitm_Port: subJson["mitm_port"].stringValue, mitm_Session: subJson["mitm_session"].stringValue, host_Method: Int(subJson["host_method"].stringValue), has_Password: subJson["has_password"].stringValue, has_SpectatePassword: subJson["has_spectate_password"].stringValue, connectable: subJson["connectable"].stringValue, isRetroarch: subJson["is_retroarch"].stringValue, created: subJson["created"].stringValue, updated: subJson["updated"].stringValue, enabled: habilitado, comando: parametrosJuego.comandoGame, gamePath: parametrosJuego.rutaGame, isRelay: isRelay)
            netplayPlays.append(datosPartida)
            
        }
        
    }
    //juegosXml.sort(by: {($0[1] ) < ($1[1] ) })
    netplayPlays.sort(by: {($0.enabled! ) > ($1.enabled! ) })
    //print(netplayPlays)
}



func comprobarJuegoNetPlay (juego: String, corepartida: String) -> (resultado: Bool, comandoGame: String? , rutaGame: String?) {
    var commandGame = String()
    commandGame = ""
    var resultado = Bool()
    var comando = String()
    var gamePath = String()
    
buscaloop: for partida in netplayPlays {
    //Buscamos el nombre del juego y lo buscamos en nuestros juegos
    var gameIsInTheList = false
    for consola in allTheGames {
        for gameFound in consola.games {
            
            let index2 = gameFound.path.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = gameFound.path.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            let gamefileString = (result1 as NSString).deletingPathExtension
            if gamefileString == juego {
                print("** Disponible \(juego) de \(gameFound.system)**")
                gameIsInTheList == true
                comando = gameFound.comando
                gamePath = gameFound.path
                resultado = true
                for comandos in consola.cores {
                    
                    if comandos[2].contains(corepartida) {
                        print ("El comando del juego es: \(comandos[2])")
                        commandGame = comandos[2]
                        break
                    }
                }
                if commandGame == "" {
                    if consola.command.contains(corepartida) {
                        commandGame = consola.command
                    }
                }
                break buscaloop
            } else {
                gameIsInTheList = false
                resultado = false
                comando = ""
                gamePath = ""
            }
        }
        
    }
    
}
    return (resultado, commandGame, gamePath)
}

func shadersList () {
    
    let home = try! (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    let folder = home?.appendingPathComponent("RetroArch/shaders/")
    let fileManager = FileManager.default
    guard let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: folder!.path as String) else {
        return
    }
    while let element = enumerator.nextObject() as? String {
        if element.hasSuffix(".glsl") {
            //print("\(folder!.path)/\(element)")
            let ruta = "\(folder!.path)/\(element)"
            let nombre = ruta.replacingOccurrences(of: folder!.path, with: "")
            let migrupo = [ruta, nombre]
            arrayShaders.append(migrupo)
        }
    }
    arrayShaders.sort(by: {($0[1] ) < ($1[1]) })
}

func readCitraConfig () {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let fileUrl = home.appendingPathComponent(".config/citra-emu/qt-config.ini")
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: fileUrl.path) {
        // make sure the file exists
        guard FileManager.default.fileExists(atPath: (fileUrl.path)) else {
            preconditionFailure("file expected at \(fileUrl.absoluteString) is missing")
        }
        
        // open the file for reading
        // note: user should be prompted the first time to allow reading from this location
        guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileUrl.path,"r") else {
            preconditionFailure("Could not open file at \(fileUrl.absoluteString)")
        }
        
        // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        
        // see the official Swift documentation for more information on the `defer` statement
        // https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_defer-statement
        defer {
            // remember to close the file when done
            fclose(filePointer)
            
            // The buffer should be freed by even if getline() failed.
            lineByteArrayPointer?.deallocate()
        }
        
        // the smallest multiple of 16 that will fit the byte array for this line
        var lineCap: Int = 0
        
        // initial iteration
        var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        
        
        while (bytesRead > 0) {
            
            // note: this translates the sequence of bytes to a string using UTF-8 interpretation
            let lineAsString = String.init(cString:lineByteArrayPointer!)
            citraConfig.append(lineAsString)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
    } else {
        let home = Bundle.main.bundlePath
        let baseCitra = "cp -r " + home +  "/Contents/Resources/Base/.config/citra-emu/ ~/.config/citra-emu/"
        Commands.Bash.system("\(baseCitra)")
        readCitraConfig()
    }
}

func writeCitraConfig(){
    
    var mytext = String()
    mytext = ""
    for line in citraConfig {
        mytext = mytext + line + "\n"
    }
    let home = FileManager.default.homeDirectoryForCurrentUser
    let fileUrl = home.appendingPathComponent(".config/citra-emu/qt-config.ini")
    try! mytext.write(to: fileUrl, atomically: false, encoding: .utf8)
    
}

