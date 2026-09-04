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
    // IDs de ScreenScraper: Model 2 = 54, Model 3 = 55 (van seguidos de atomiswave 53
    // y naomi 56). Sin esta entrada el scraper mandaría systemeid vacío.
    let model2 = ["model2", "54"]
    let model3 = ["model3", "55"]
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
    systemsIds.append(model2)
    systemsIds.append(model3)
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
    // Lectura tolerante: si falta el fichero o no es UTF-8, devolvemos vacío en vez de crashear.
    guard let content = (try? String(contentsOfFile: ruta, encoding: .utf8))
        ?? (try? String(contentsOfFile: ruta, encoding: .isoLatin1)) else {
        print("⚠️ mamelista: no se pudo leer mamelist.txt")
        return miArray
    }
    for line in content.split(separator: "\n") {
        let misvalores = line.split(separator: ",")
        // Saltamos líneas malformadas (sin coma) en vez de romper por índice.
        guard misvalores.count >= 2 else { continue }
        miArray.append([String(misvalores[0]), String(misvalores[1])])
    }
    return miArray
}


// MARK: - Caché de listados de carpeta
// Las funciones busca* (imagen, vídeo, manual, box, marquee…) enumeraban RECURSIVAMENTE
// la carpeta del sistema una vez POR CADA una y por cada juego nuevo: 7 escaneos completos
// por juego. Con este caché se enumera la carpeta UNA vez y se reutiliza.
var cacheListados = [String: [String]]()

func listadoCacheado(_ ruta: String) -> [String] {
    if let cacheado = cacheListados[ruta] { return cacheado }
    var lista = [String]()
    if let e = FileManager.default.enumerator(atPath: ruta) {
        while let el = e.nextObject() as? String { lista.append(el) }
    }
    cacheListados[ruta] = lista
    return lista
}

/// Se vacía al empezar a cargar cada sistema, para no servir listados obsoletos.
func limpiarCacheListados() { cacheListados.removeAll() }

/// Carga la lista de MAME (1,3 MB / 30k líneas) solo la primera vez que hace falta.
/// La usan únicamente los scrapers, así que no se parsea en cada arranque.
func asegurarTitulosMame() {
    if titulosMame.isEmpty {
        titulosMame = (mamelista() as? [[String]]) ?? []
    }
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
    // Caché de listados fresco para este sistema: las busca* enumerarán su carpeta
    // UNA sola vez en vez de una por cada juego nuevo y por cada tipo de media.
    limpiarCacheListados()
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
            let miBox = siRutaRelativa2(ruta:String(game.box))
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
        let enumerator = fileManager.enumerator(atPath: rutaApp3 as String)
        while let element = enumerator?.nextObject() as? String {
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
        let enumerator = fileManager.enumerator(atPath: ruta as String)
        while let element = enumerator?.nextObject() as? String {
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
    //var nuevoGamelist = rutaApp2 + "/systems_test.xml"
    do{
        try? xmlData.write(to: pathComponent!)
        print("EXITO")
        
    }catch {print("ERROR")}
    
}

func buscaImage (juego: String, ruta: String) -> String {
    var tieneSnap = false
    var miFoto = ""
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    //print("MI ROMPATH: \(ruta)")
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    //print("MI ROMPATH: \(ruta)")
    
    if ruta != "" && ruta != nil && buscarLocal == true {
        var name = (juego as NSString).deletingPathExtension
        if name.contains("/") {
            let index2 = name.range(of: "/", options: .backwards)?.lowerBound
            let substring2 = name.substring(from: index2! )
            let result1 = String(substring2.dropFirst())
            name = result1
        }
        else {
            
        }
        for element in listadoCacheado(ruta) {
            
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
    retroArchConfig = []
    // Lectura segura: si falta o no se puede leer, avisamos y seguimos (antes crasheaba
    // con preconditionFailure justo en el arranque).
    guard let soporte = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        print("⚠️ readRetroArchConfig: sin Application Support")
        return
    }
    let fileUrl = soporte.appendingPathComponent("RetroArch/config/retroarch.cfg")
    guard let contenido = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        print("⚠️ readRetroArchConfig: no se pudo leer \(fileUrl.path)")
        return
    }

    for linea in contenido.components(separatedBy: .newlines) {
        // Parseo tolerante: saltamos vacías, comentarios y cualquier línea sin "="
        // (antes `myparams[1]` reventaba con esas líneas).
        guard let sep = linea.firstIndex(of: "=") else { continue }
        let clave = linea[linea.startIndex..<sep]
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "\"", with: "")
        // El valor conserva cualquier "=" posterior (rutas, etc.).
        let valor = linea[linea.index(after: sep)...]
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "\"", with: "")
        if clave.isEmpty || clave.hasPrefix("#") { continue }
        retroArchConfig.append([clave, valor])
    }
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
    let home = (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    let fileUrl = home?.appendingPathComponent("RetroArch/config/retroarch.cfg")
    try? mytext.write(to: fileUrl!, atomically: false, encoding: .utf8)
    
    
}

func gameShader(shader: String) {
    var mytext = String()
    mytext = ""
    mytext = mytext + "shaders = \"1\"" + "\n"
    mytext = mytext + "shader0 = \"\(shader)\""
    print(mytext)
    let home = (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first
    let fileUrl = home?.appendingPathComponent("RetroArch/config/global.glslp")
    try? mytext.write(to: fileUrl!, atomically: false, encoding: .utf8)
    
    
}

func gameOverlay(game: String) {
    
    let index2 = game.range(of: "/", options: .backwards)?.lowerBound
    let substring2 = game.substring(from: index2! )
    let result1 = String(substring2.dropFirst())
    let solonombre =  (result1 as NSString).deletingPathExtension
    let gamename = solonombre
    let miruta = rutaApp + "/decorations/"
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(atPath: miruta as String)
    var rutaoverlay = String()
    while let element = enumerator?.nextObject() as? String {
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
            let enumerator = fileManager.enumerator(atPath: miruta as String)
            while let element = enumerator?.nextObject() as? String {
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
    
    try? myOverlayGame.write(to: pathComponent!, atomically: false, encoding: .utf8)
    
    
}

func noGameOverlay() {
    
    
    // Ruta del shader relativa al usuario actual (antes hardcodeada a /Users/pablojimenez/...).
    let shaderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        + "/RetroMac/shaders/zfast_crt.glsl"
    var myOverlayGame = "overlays = 1" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_overlay = " + "\"\" \n"
    myOverlayGame = myOverlayGame + "overlay0_full_screen = true" + "\n"
    myOverlayGame = myOverlayGame + "overlay0_descs = 0" + "\n"
    myOverlayGame = myOverlayGame + "shaders = 1" + "\n"
    myOverlayGame = myOverlayGame + "video_shader = \"\(shaderPath)\"" + "\n"
    myOverlayGame = myOverlayGame + "filter_linear0 = true"
    
    
    let path2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url2 = NSURL(fileURLWithPath: path2)
    let pathComponent = url2.appendingPathComponent("RetroMac/custom_overlay.cfg")
    //let filePath = pathComponent?.path
    try? myOverlayGame.write(to: pathComponent!, atomically: false, encoding: .utf8)
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
    
    arrayShaders = []
    // Sin force-unwraps: si no hay carpeta de shaders, salimos sin lista (no crasheamos).
    guard let home = (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)).first else { return }
    let folder = home.appendingPathComponent("RetroArch/shaders/")
    guard let enumShaders = FileManager.default.enumerator(atPath: folder.path) else { return }
    while let element = enumShaders.nextObject() as? String {
        if element.hasSuffix(".glsl") {
            let ruta = "\(folder.path)/\(element)"
            let nombre = ruta.replacingOccurrences(of: folder.path, with: "").replacingOccurrences(of: "/shaders_glsl", with: "")
            arrayShaders.append([ruta, nombre])
        }
    }
    arrayShaders.sort(by: {($0[1] ) < ($1[1]) })
}



func readCitraConfig () {
    citraConfig = []
    let home = FileManager.default.homeDirectoryForCurrentUser
    let fileUrl = home.appendingPathComponent("Library/Application Support/Azahar/config/qt-config.ini")
    // Si Azahar aún no ha creado su qt-config.ini (nunca se ha lanzado), lo dejamos vacío:
    // no copiamos config de Citra y writeCitraConfig no escribirá nada (evita clobber).
    guard let contenido = try? String(contentsOf: fileUrl, encoding: .utf8) else { return }
    // Sin el "\n" de getline: writeCitraConfig ya añade el salto (antes se duplicaban).
    citraConfig = contenido.components(separatedBy: .newlines)
}

func writeCitraConfig(){
    // Si no leímos config (Azahar aún no la creó), NO escribimos: evita dejar un
    // qt-config.ini vacío que pisaría el de Azahar.
    guard !citraConfig.isEmpty else { return }
    var mytext = String()
    mytext = ""
    for line in citraConfig {
        mytext = mytext + line + "\n"
    }
    let home = FileManager.default.homeDirectoryForCurrentUser
    let fileUrl = home.appendingPathComponent("Library/Application Support/Azahar/config/qt-config.ini")
    try? mytext.write(to: fileUrl, atomically: false, encoding: .utf8)
}

/// Devuelve el conjunto de cores realmente referenciados por el cfg de sistemas
/// (los `core="…"` de los `<emu>` + los `…_libretro.dylib` de los `<command>`), deduplicado.
/// Así se descargan solo los cores que la app puede ofrecer/lanzar, no 200 hardcodeados.
/// El cfg de sistemas es válido si existe, no está vacío y parsea (contiene <system>).
func cfgEsValido(_ path: String) -> Bool {
    guard let s = try? String(contentsOfFile: path, encoding: .utf8), !s.isEmpty else { return false }
    return s.contains("<system>")
}

/// Devuelve los bloques `<system>…</system>` completos de un cfg, en orden.
func bloquesDeSistema(_ texto: String) -> [String] {
    var out = [String]()
    var resto = texto[...]
    while let ini = resto.range(of: "<system>"),
          let fin = resto.range(of: "</system>", options: [], range: ini.upperBound..<resto.endIndex) {
        out.append(String(resto[ini.lowerBound..<fin.upperBound]))
        resto = resto[fin.upperBound...]
    }
    return out
}

/// Nombre corto (`<name>`) de un bloque de sistema.
func nombreDeSistema(_ bloque: String) -> String? {
    guard let a = bloque.range(of: "<name>"),
          let b = bloque.range(of: "</name>", options: [], range: a.upperBound..<bloque.endIndex)
    else { return nil }
    return String(bloque[a.upperBound..<b.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
}

/// Añade al cfg del usuario los `<system>` que están en el cfg del bundle pero no en el suyo.
///
/// Hacía falta porque el cfg de ~/Documents solo se recopia cuando falta o está corrupto
/// (para no pisar el core que el usuario ha elegido por sistema, que escribe `escribeSistemas`).
/// Consecuencia: un sistema nuevo de una versión posterior —model2, model3— no llegaba NUNCA
/// a quien ya tenía un cfg válido. La fusión es a nivel de texto: solo inserta bloques que
/// faltan, sin tocar ni una línea de los que ya están. Devuelve los nombres añadidos.
@discardableResult
func fusionarSistemasNuevos() -> [String] {
    let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let rutaUsuario = docs + "/RetroMac/es_systems_mac.cfg"
    guard let rutaBundle = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg"),
          let delBundle = try? String(contentsOfFile: rutaBundle, encoding: .utf8),
          var delUsuario = try? String(contentsOfFile: rutaUsuario, encoding: .utf8),
          delUsuario.contains("<system>"),
          let cierre = delUsuario.range(of: "</systemList>", options: .backwards)
    else { return [] }

    var nombresAnadidos = [String]()
    var bloquesNuevos = ""
    for bloque in bloquesDeSistema(delBundle) {
        guard let nombre = nombreDeSistema(bloque) else { continue }
        if delUsuario.contains("<name>\(nombre)</name>") { continue }
        bloquesNuevos += "    " + bloque + "\n"
        nombresAnadidos.append(nombre)
    }
    guard !nombresAnadidos.isEmpty else { return [] }

    delUsuario.replaceSubrange(cierre, with: bloquesNuevos + "</systemList>")
    do {
        try delUsuario.write(toFile: rutaUsuario, atomically: true, encoding: .utf8)
    } catch {
        print("⚠️ no se pudieron fusionar los sistemas nuevos: \(error)")
        return []
    }
    return nombresAnadidos
}

func coresDelCfg() -> [String] {
    let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let rutaUsuario = docs + "/RetroMac/es_systems_mac.cfg"
    var contenido = (try? String(contentsOfFile: rutaUsuario, encoding: .utf8)) ?? ""
    if contenido.isEmpty, let bundlePath = Bundle.main.path(forResource: "es_systems_mac", ofType: "cfg") {
        contenido = (try? String(contentsOfFile: bundlePath, encoding: .utf8)) ?? ""
    }
    if contenido.isEmpty { return [] }

    var cores = Set<String>()
    let rango = NSRange(contenido.startIndex..., in: contenido)
    // Los nombres REALES de core son los ficheros `..._libretro.dylib` de los <command>.
    // NO se usa el atributo core="..." porque es la ETIQUETA del selector, no un nombre de
    // fichero: puede llevar espacios (core="vice_x64sc accurate") o no coincidir.
    // El charset incluye guion: hay cores con guion (mesen-s, vitaquake2-rogue).
    guard let re = try? NSRegularExpression(pattern: "([A-Za-z0-9_-]+)_libretro\\.dylib") else { return [] }
    re.enumerateMatches(in: contenido, range: rango) { m, _, _ in
        if let m = m, let r = Range(m.range(at: 1), in: contenido) {
            cores.insert(String(contenido[r]))
        }
    }
    return Array(cores).sorted()
}

// MARK: - Descarga desde fuentes OFICIALES (GitHub Releases API + Dolphin)

/// GET síncrono con User-Agent (la API de GitHub exige User-Agent o devuelve 403).
func httpGETsync(_ urlStr: String) -> Data? {
    guard let url = URL(string: urlStr) else { return nil }
    var req = URLRequest(url: url)
    req.setValue("RetroMac", forHTTPHeaderField: "User-Agent")
    req.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    req.timeoutInterval = 30
    var resultado: Data?
    let sem = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: req) { data, _, _ in resultado = data; sem.signal() }.resume()
    _ = sem.wait(timeout: .now() + 35)
    return resultado
}

/// URL de descarga del asset de macOS del último release de un repo de GitHub.
func githubUltimoAsset(repo: String, contiene patron: String) -> String? {
    guard let data = httpGETsync("https://api.github.com/repos/\(repo)/releases/latest"),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let assets = json["assets"] as? [[String: Any]] else { return nil }
    for a in assets {
        if let name = a["name"] as? String, name.contains(patron),
           let url = a["browser_download_url"] as? String { return url }
    }
    return nil
}

/// URL del .dmg universal de Dolphin desde su API de builds propia.
func dolphinUltimoDmg() -> String? {
    guard let data = httpGETsync("https://dolphin-emu.org/update/latest/beta"),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let arts = json["artifacts"] as? [[String: Any]] else { return nil }
    if let mac = arts.first(where: { ($0["system"] as? String)?.contains("macOS") ?? false }),
       let url = mac["url"] as? String { return url }
    return arts.first?["url"] as? String
}

/// Última versión STABLE de RetroArch del buildbot (fallback a 1.22.2 si no se puede resolver).
func retroArchStableVersion() -> String {
    guard let data = httpGETsync("https://buildbot.libretro.com/stable/"),
          let html = String(data: data, encoding: .utf8),
          let re = try? NSRegularExpression(pattern: "(\\d+)\\.(\\d+)\\.(\\d+)/") else { return "1.22.2" }
    var mejor = (0, 0, 0)
    re.enumerateMatches(in: html, range: NSRange(html.startIndex..., in: html)) { m, _, _ in
        guard let m = m,
              let r1 = Range(m.range(at: 1), in: html),
              let r2 = Range(m.range(at: 2), in: html),
              let r3 = Range(m.range(at: 3), in: html) else { return }
        let v = (Int(html[r1]) ?? 0, Int(html[r2]) ?? 0, Int(html[r3]) ?? 0)
        if v > mejor { mejor = v }
    }
    return mejor == (0, 0, 0) ? "1.22.2" : "\(mejor.0).\(mejor.1).\(mejor.2)"
}

enum FormatoDescarga { case zip, tarxz, sevenz, dmg }

/// Si tras extraer la `.app` quedó anidada dentro de una única carpeta wrapper
/// (p.ej. `azahar-macos-universal-2126.0/Azahar.app`), sube su contenido a `destino`
/// para que quede `destino/Azahar.app` (como espera el cfg y el chequeo de reparación).
func aplanarSiAnidado(_ destino: String) {
    let fm = FileManager.default
    guard let items = try? fm.contentsOfDirectory(atPath: destino) else { return }
    let visibles = items.filter { !$0.hasPrefix(".") }
    if visibles.contains(where: { $0.hasSuffix(".app") }) { return }   // ya hay .app directa
    let subdirs = visibles.filter {
        var d: ObjCBool = false
        return fm.fileExists(atPath: "\(destino)/\($0)", isDirectory: &d) && d.boolValue
    }
    guard subdirs.count == 1 else { return }                            // solo si hay un único wrapper
    let wrapper = "\(destino)/\(subdirs[0])"
    for hijo in (try? fm.contentsOfDirectory(atPath: wrapper)) ?? [] {
        try? fm.moveItem(atPath: "\(wrapper)/\(hijo)", toPath: "\(destino)/\(hijo)")
    }
    try? fm.removeItem(atPath: wrapper)
}

/// Descarga `url` a Descargas y la extrae en `destino` según el formato.
/// .7z usa el binario `7zz` empaquetado en Contents/Resources (macOS no trae 7z).
func descargarYExtraer(url: String, formato: FormatoDescarga, destino: String, etiquetaTexto: String) {
    DispatchQueue.main.sync { etiqueta.stringValue = etiquetaTexto }
    let rutaApp = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
    let descargas = "\(rutaApp)/Emuladores_Mac/Descargas"
    let fichero = (url as NSString).lastPathComponent
    let archivo = "\(descargas)/\(fichero)"
    Commands.Bash.system("mkdir -p \"\(descargas)\" && mkdir -p \"\(destino)\" && cd \"\(descargas)\" && curl -L -f --retry 3 --retry-delay 2 -O \"\(url)\"")
    let sevenZip = Bundle.main.bundlePath + "/Contents/Resources/7zz"
    switch formato {
    case .zip:
        Commands.Bash.system("unzip -o \"\(archivo)\" -d \"\(destino)\"")
    case .tarxz:
        Commands.Bash.system("tar -xf \"\(archivo)\" -C \"\(destino)\"")
    case .sevenz:
        // chmod +x por si el empaquetado quitó el bit de ejecución al binario 7zz.
        Commands.Bash.system("chmod +x \"\(sevenZip)\" 2>/dev/null; \"\(sevenZip)\" x \"\(archivo)\" -o\"\(destino)\" -y")
    case .dmg:
        let punto = "/Volumes/RetroMacDMG"
        Commands.Bash.system("hdiutil detach \"\(punto)\" 2>/dev/null; hdiutil attach \"\(archivo)\" -nobrowse -mountpoint \"\(punto)\" && cp -R \"\(punto)\"/*.app \"\(destino)/\" && hdiutil detach \"\(punto)\"")
    }
    // Muchos archivos traen una carpeta wrapper versionada: subimos la .app a `destino`.
    aplanarSiAnidado(destino)
    // Verificación mínima: avisamos si el destino quedó sin ninguna .app.
    if (try? FileManager.default.contentsOfDirectory(atPath: destino))?.contains(where: { $0.hasSuffix(".app") }) != true {
        print("⚠️ descarga/extracción incompleta en \(destino) (\(fichero))")
    }
}

/// ¿La carpeta contiene alguna .app? Se usa para bajar solo los emuladores que falten.
func carpetaTieneApp(_ ruta: String) -> Bool {
    return (try? FileManager.default.contentsOfDirectory(atPath: ruta))?.contains { $0.hasSuffix(".app") } ?? false
}

/// Renombra la `.app` extraída al nombre EXACTO que espera el cfg.
///
/// Algunas releases traen el nombre con la versión dentro: PCSX2 se instalaba como
/// `PCSX2-v2.8.1.app` mientras el cfg lanza `Pcsx2/PCSX2.app/Contents/MacOS/PCSX2`,
/// así que el sistema PS2 no podía arrancar NUNCA — y `carpetaTieneApp` la daba por
/// instalada, con lo que ni se reintentaba. Además el nombre cambia en cada versión.
func normalizarNombreApp(destino: String, esperado: String) {
    let fm = FileManager.default
    let apps = ((try? fm.contentsOfDirectory(atPath: destino)) ?? [])
        .filter { $0.hasSuffix(".app") && !$0.hasPrefix(".") }
    guard !apps.contains(esperado), let actual = apps.first else { return }
    try? fm.removeItem(atPath: "\(destino)/\(esperado)")
    do {
        try fm.moveItem(atPath: "\(destino)/\(actual)", toPath: "\(destino)/\(esperado)")
        print("↻ \(actual) → \(esperado)")
    } catch {
        print("⚠️ no se pudo renombrar \(actual) a \(esperado): \(error)")
    }
}

func downloadEmulators() {
    let arquitectura: String = CPUType()
    var rutaApp = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
    var isDir:ObjCBool = true
    var theProjectPath = "\(rutaApp)/Emuladores_Mac/"
        // Auto-reparación: ya NO es todo-o-nada. Creamos las carpetas y luego bajamos SOLO
        // lo que falte (RetroArch, cada core, cada emulador, bezels).
        _ = theProjectPath; _ = isDir
        DispatchQueue.main.sync {
            etiqueta.stringValue = "Comprobando emuladores y cores…"
        }
        var comando = "cd \(rutaApp) && mkdir -p Emuladores_Mac && cd \(rutaApp)/Emuladores_Mac && mkdir -p Descargas && mkdir -p Retroarch && mkdir -p Azahar && mkdir -p cores && mkdir -p Dolphin && mkdir -p Pcsx2 && mkdir -p RPCS3 && mkdir -p Xemu"
        Commands.Bash.system("\(comando)")
        let sufijo = "_libretro.dylib.zip"
        let coresDir = "\(rutaApp)/Emuladores_Mac/cores"
        // Cores derivados del cfg (los que la app puede ofrecer/lanzar). Si el cfg no se pudo
        // leer, caemos a la lista completa hardcodeada como red de seguridad.
        arrayCoresRetroArch = coresDelCfg()
        if arrayCoresRetroArch.isEmpty { arrayCoresRetroArch = ["81","2048","a5200","arduous","atari800","bk","blastem","bluemsx","bsnes2014_accuracy","bsnes2014_balanced","bsnes2014_performance","bsnes_cplusplus98","bsnes_hd_beta","bsnes","bsnes_mercury_accuracy","bsnes_mercury_balanced","bsnes_mercury_performance","cannonball","cap32","cdi2015","chailove","craft","crocods","daphne","desmume2015","desmume","dinothawr","dolphin","dosbox_core","dosbox_pure","dosbox_svn","duckstation","easyrpg","ecwolf","fbalpha2012_cps1","fbalpha2012_cps2","fbalpha2012_cps3","fbalpha2012","fbalpha2012_neogeo","fbneo","fceumm","ffmpeg","fixgb","flycast","fmsx","freechaf","freeintv","frodo","fuse","gambatte","gearboy","gearcoleco","gearsystem","genesis_plus_gx","genesis_plus_gx_wide","gme","gong","gpsp","gw","handy","hatari","higan_sfc","ishiiruka","jaxe","jumpnbump","lowresnx","lutro","mame2000","mame2003","mame2003_plus","mame2010","mame","mednafen_gba","mednafen_lynx","mednafen_ngp","mednafen_pce_fast","mednafen_pce","mednafen_pcfx","mednafen_psx_hw","mednafen_psx","mednafen_saturn","mednafen_snes","mednafen_supergrafx","mednafen_vb","mednafen_wswan","melonds","mesen-s","mesen","mgba","minivmac","mrboom","mu","nekop2","neocd","nestopia","np2kai","nxengine","o2em","oberon","openlara","opera","parallel_n64","pcsx_rearmed","picodrive","play","pocketcdg","pokemini","potator","ppsspp","prboom","prosystem","puae","px68k","quasi88","quicknes","race","reminiscence","remotejoy","retro8","same_cdi","sameboy","sameduck","scummvm","smsplus","snes9x2002","snes9x2005","snes9x2005_plus","snes9x2010","snes9x","squirreljme","stella2014","stella","superbroswar","swanstation","test","tgbdual","theodore","thepowdertoy","tic80","tyrquake","uzem","vaporspec","vba_next","vbam","vecx","vemulator","vice_x64","vice_x64sc","vice_x128","vice_xcbm2","vice_xcbm5x0","vice_xpet","vice_xplus4","vice_xscpu64","vice_xvic","virtualjaguar","vitaquake2-rogue","vitaquake2-xatrix","vitaquake2-zaero","vitaquake2","wasm4","x1","xrick","yabause"] }
        
        // ─── RetroArch (STABLE universal), solo si falta ─────────────────────────
        if !carpetaTieneApp("\(rutaApp)/Emuladores_Mac/Retroarch") {
            DispatchQueue.main.sync { etiqueta.stringValue = "Buscando RetroArch…" }
            let versionRA = retroArchStableVersion()
            descargarYExtraer(url: "https://buildbot.libretro.com/stable/\(versionRA)/apple/osx/universal/RetroArch_Metal.dmg",
                              formato: .dmg, destino: "\(rutaApp)/Emuladores_Mac/Retroarch",
                              etiquetaTexto: "Descargando RetroArch \(versionRA)…")
        }

        // ─── Cores ───────────────────────────────────────────────────────────────
        // FASE 1 · COMPROBAR (rápida y silenciosa): qué falta realmente.
        let archCore = (arquitectura == "X86") ? "x86_64" : "arm64"
        DispatchQueue.main.sync { etiqueta.stringValue = "Comprobando cores…" }
        let coresQueFaltan = arrayCoresRetroArch.filter { core in
            !FileManager.default.fileExists(atPath: "\(coresDir)/\(core)_libretro.dylib")
        }

        // FASE 2 · DESCARGAR: solo si falta algo, con progreso real por core.
        if !coresQueFaltan.isEmpty {
            // ¿Responde el buildbot? Si no hay red no marcamos nada como "no disponible"
            // (si no, un corte de red dejaría cores baneados para siempre).
            DispatchQueue.main.sync { etiqueta.stringValue = "Conectando con el servidor de cores…" }
            let hayRed = httpGETsync("https://buildbot.libretro.com/nightly/apple/osx/\(archCore)/latest/") != nil
            if hayRed {
                let descargasDir = "\(rutaApp)/Emuladores_Mac/Descargas"
                let total = coresQueFaltan.count
                for (i, micore) in coresQueFaltan.enumerated() {
                    DispatchQueue.main.sync {
                        etiqueta.stringValue = "Descargando cores… \(i + 1)/\(total) — \(micore)"
                    }
                    comando = "cd \"\(descargasDir)\" && curl -L -f -s --connect-timeout 10 --retry 1 -O https://buildbot.libretro.com/nightly/apple/osx/\(archCore)/latest/\(micore)\(sufijo)"
                    Commands.Bash.system("\(comando)")
                    comando = "unzip -o -q \"\(descargasDir)/\(micore)\(sufijo)\" -d \"\(coresDir)\" 2>/dev/null"
                    Commands.Bash.system("\(comando)")
                    // Si sigue sin estar, ese core del cfg no existe en el buildbot.
                    // NO lo ocultamos: se acumula para avisar al usuario al terminar.
                    if !FileManager.default.fileExists(atPath: "\(coresDir)/\(micore)_libretro.dylib") {
                        coresNoDescargados.append(micore)
                        print("⚠️ core del cfg no disponible en el buildbot (\(archCore)): \(micore)")
                    }
                }
            } else {
                print("⚠️ Sin conexión con el buildbot: se omite la descarga de cores este arranque")
            }
        }

        // ─── Emuladores oficiales (solo los que falten) ──────────────────────────
        // Etiqueta honesta en cada paso: "Buscando…" mientras se resuelve la URL
        // (llamada de red) y "Descargando…" mientras baja de verdad.
        func instalarEmulador(carpeta: String, nombre: String, app: String,
                              formato: FormatoDescarga, resolver: () -> String?) {
            let destino = "\(rutaApp)/Emuladores_Mac/\(carpeta)"
            // Se comprueba la .app CONCRETA que lanza el cfg, no "hay alguna .app":
            // una PCSX2-v2.8.1.app contaba como instalada y no arrancaba nunca.
            if FileManager.default.fileExists(atPath: "\(destino)/\(app)") { return }
            if carpetaTieneApp(destino) {
                normalizarNombreApp(destino: destino, esperado: app)
                if FileManager.default.fileExists(atPath: "\(destino)/\(app)") { return }
            }
            DispatchQueue.main.sync { etiqueta.stringValue = "Buscando \(nombre)…" }
            guard let u = resolver() else {
                print("⚠️ No se pudo resolver la descarga de \(nombre)")
                return
            }
            descargarYExtraer(url: u, formato: formato, destino: destino,
                              etiquetaTexto: "Descargando \(nombre)…")
            normalizarNombreApp(destino: destino, esperado: app)
        }

        instalarEmulador(carpeta: "Xemu", nombre: "xemu", app: "xemu.app", formato: .zip) {
            githubUltimoAsset(repo: "xemu-project/xemu", contiene: "macos-universal.zip")
        }
        instalarEmulador(carpeta: "Pcsx2", nombre: "PCSX2", app: "PCSX2.app", formato: .tarxz) {
            githubUltimoAsset(repo: "PCSX2/pcsx2", contiene: "macos-Qt.tar.xz")
        }
        instalarEmulador(carpeta: "RPCS3", nombre: "RPCS3", app: "RPCS3.app", formato: .sevenz) {
            githubUltimoAsset(repo: "RPCS3/rpcs3-binaries-mac", contiene: "_macos.7z")
        }
        instalarEmulador(carpeta: "Dolphin", nombre: "Dolphin", app: "Dolphin.app", formato: .dmg) {
            dolphinUltimoDmg()
        }
        instalarEmulador(carpeta: "Azahar", nombre: "Azahar (3DS)", app: "Azahar.app", formato: .zip) {
            githubUltimoAsset(repo: "azahar-emu/azahar", contiene: "macos-universal")
        }
        // (cfg del 3DS, fullscreen y config ya migrados a Azahar: Azahar.app/azahar +
        //  ~/Library/Application Support/Azahar/config/qt-config.ini + contains("azahar")).

        //MARK: Bezels desde el bundle (sin Dropbox), solo si aún no están.
        if !FileManager.default.fileExists(atPath: "\(rutaApp)/decorations") {
            let decoracionesBundle = Bundle.main.bundlePath + "/Contents/Resources/decorations"
            if FileManager.default.fileExists(atPath: decoracionesBundle) {
                DispatchQueue.main.sync { etiqueta.stringValue = "Instalando Bezels" }
                Commands.Bash.system("cp -R \"\(decoracionesBundle)\" \"\(rutaApp)/decorations\"")
            } else {
                print("⚠️ No hay 'decorations' en el bundle; los bezels no se instalarán.")
            }
        }

        // Limpieza: si todos los emuladores quedaron instalados, borramos Descargas
        // (zips/dmg/7z ya extraídos, ~cientos de MB). Si falta alguno, la conservamos
        // para no re-descargar de cero en el próximo intento.
        // Se comprueba la .app EXACTA que lanza el cfg (una PCSX2-v2.8.1.app no vale).
        let emus = [("Retroarch", "RetroArch.app"), ("Xemu", "xemu.app"), ("Pcsx2", "PCSX2.app"),
                    ("RPCS3", "RPCS3.app"), ("Dolphin", "Dolphin.app"), ("Azahar", "Azahar.app")]
        let todoInstalado = emus.allSatisfy {
            FileManager.default.fileExists(atPath: "\(rutaApp)/Emuladores_Mac/\($0.0)/\($0.1)")
        }
        if todoInstalado {
            try? FileManager.default.removeItem(atPath: "\(rutaApp)/Emuladores_Mac/Descargas")
        }
}

func CPUType1() ->Int {
    
    var cputype = UInt32(0)
    var size = cputype.bitWidth
    
    let result = sysctlbyname("hw.cputype", &cputype, &size, nil, 0)
    if result == -1 {
        if (errno == ENOENT){
            return 0
        }
        return -1
    }
    return Int(cputype)
}


let CPU_ARCH_MASK          = 0xff      // mask for architecture bits

let CPU_TYPE_X86           = cpu_type_t(7)
let CPU_TYPE_ARM           = cpu_type_t(12)

func CPUType() ->String {
    
    let type: Int = CPUType1()
    if type == -1 {
        return "error in CPU type"
    }
    
    let cpu_arch = type & CPU_ARCH_MASK
    
    if cpu_arch == CPU_TYPE_X86{
        return "X86"
    }
    
    if cpu_arch == CPU_TYPE_ARM{
        return "ARM"
    }
    
    return "unknown"
}






