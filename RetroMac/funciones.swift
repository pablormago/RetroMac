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
func cuentaJuegosEnSistemas()  {
    //print("ENTRO A CONTAR")
    let pathXMLinterno = Bundle.main.url(forResource: "es_systems_mac", withExtension: "cfg")
    var datosdelsitema = [[String]]()
    datosdelsitema = []
    tieneRoms = false
    juegosPorConsola = []
    if let pathXMLinterno = pathXMLinterno, let data = try? Data(contentsOf: pathXMLinterno as URL)
        
    {
        let parser = BookParser(data: data)
        
        
        for book in parser.books
        {
            //print(book.name)
            let rutaApp2 = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
            let miruta = rutaApp2 + book.path /// Es lo mismo que ROMPATH
            //print(miruta)
            ///Comprobar si ha gamelist.xml
            let fileDoesExist2 = FileManager.default.fileExists(atPath: miruta + "/gamelist.xml")
            
            if fileDoesExist2 {
                ///Si existe, lo añadimos al array de sistemas
                //sistemasTengo.append(book.name)
                print(book.name)
                var miSistema = book.name
                var extensionescuenta = String()
                extensionescuenta = book.extensiones
                var migrupo = [miSistema,extensionescuenta]
                
                datosdelsitema.append(migrupo)
                //print(datosdelsitema)
                //print(datosdelsitema)
                
            }else {
                ///Si no existe hay que comprobar si hay juegos, y crear el xml en caso de que lo haya
                
                //                var encuentra =  false
                //                var isDir:ObjCBool = true
                //                if FileManager.default.fileExists(atPath: miruta, isDirectory: &isDir) {
                //                    //para cada book.extensiones
                //                    var extensionescuenta = [String]()
                //
                //                    extensionescuenta = book.extensiones.components(separatedBy: " ")
                //                    for extensiones in extensionescuenta {
                //
                //                        let fileManager = FileManager.default
                //                        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: miruta as String)!
                //                        while let element = enumerator.nextObject() as? String {
                //                            if element.hasSuffix(extensiones) { // checks the extension
                //                                //print(element)
                //                                encuentra = true
                //                                break
                //                            }
                //                        }
                //                        if encuentra == true {
                //                            break
                //                        }else{
                //                            encuentra = false
                //                        }
                //                    }
                //
                //                    if encuentra == true {
                //                        ///Creamos el xml y añadimos el sistema al array porque ha encontrado ROMS
                //                        //print("ROMS ENCONTRADAS")
                //                        systemextensions = extensionescuenta
                //                        rompath = miruta
                //                        //print(systemextensions)
                //                        crearGameListInicio(ruta: miruta)
                //                        //sistemasTengo.append(book.name)
                //                    }else {
                //
                //                    }
                //                }
            }
            
            
        }
    }
    
    //sistemasTengo.sort()
    //return sistemasTengo
    //print(datosdelsitema)
    cuentajuegos(arraySistema: datosdelsitema)
    
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


