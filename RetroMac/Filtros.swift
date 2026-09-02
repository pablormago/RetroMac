//
//  Filtros.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 25/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import GameController
import Commands
var juegosNivel0 = [[String]]()
var juegosNivel1 = [[String]]()
var juegosNivel2 = [[String]]()
var juegosNivel3 = [[String]]()
var juegosNivel4 = [[String]]()
var rutaBase = String()


public func filtradoPaso1(){
    rawJuegosXml = []
    xmlRutasRaw = []
    xmlRutasUnique = []
    testJuegosXml = []
    for consola in allTheGames {
        if consola.sistema == nombresistemaactual {
            for game in consola.games {
                //print(game)
                let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
                rawJuegosXml.append(mijuego)
            }
            break
        }
    }
    rawJuegosXml.sort(by: {($0[1] ) < ($1[1] ) })
    
    
    for game in rawJuegosXml {
        let rutaRaw = game[0] as NSString?
        let rutaEdit = rutaRaw?.deletingLastPathComponent
        xmlRutasRaw.append(rutaEdit!)
    }
    let countedSet = NSCountedSet(array: xmlRutasRaw)
    for ruta in countedSet {
        var miruta = String()
        miruta = ruta as! String
        let cuenta = miruta.numberOfOccurrencesOf(string: "/")
        let grupo = [String(miruta) , String(cuenta)]
        xmlRutasUnique.append(grupo)
    }
    
    
    
    let minimo = rompath.numberOfOccurrencesOf(string: "/")
    let maximo = Int(xmlRutasUnique.max(by: {($0[1] ) < ($1[1])  })![1])
    minLevel = rompath.numberOfOccurrencesOf(string: "/")
    maxLevel = maximo!
    for a in 0..<xmlRutasUnique.count {
        let miNivel = Int(xmlRutasUnique[a][1])! - minimo
        xmlRutasUnique[a][1] = String(miNivel)
    }
    xmlRutasUnique.sort(by: {($0[1] ) < ($1[1] ) })
    nivelActual = 0
    //MARK: Array ordenado. Es [ruta(sin fichero ni última "/") , nivel] - El mínimo es el nivel cero
    
    //MARK: Ahora hay que añadir las "carpetas" del siguiente nivel (nivelActual + 0) y añadir los juegos de nivel 0
    var rutaAbuscar = String()
    for ruta in xmlRutasUnique {
        if Int(ruta[1]) == (nivelActual) {
            rutaAbuscar = ruta[0]
            break
        }
    }
    
    for ruta in xmlRutasUnique {
        if Int(ruta[1]) == (nivelActual + 1) {
            let miruta = ruta[0] as String
            let nombreRaw = ruta[0] as NSString
            let nombre = String(nombreRaw.lastPathComponent) as String
            // El 9 es la imagen de fondo
            let migrupo = [String(miruta) , nombre, "", "", "", "", "", "", "", getImagen(Ruta: miruta), "", "", "", "", "", "", "", "", "", "", "", "", "Carpeta", ""]
            testJuegosXml.append(migrupo)
        }
    }
    testJuegosXml.sort(by: {($0[1] ) < ($1[1] ) })
    var tempJuegos = [[String]]()
    for consola in allTheGames {
        if consola.sistema == nombresistemaactual {
            for game in consola.games {
                let rutaDelJuego = game.path as NSString
                let rutaJuegoABuscar = rutaDelJuego.deletingLastPathComponent
                let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
                if rutaJuegoABuscar == rutaAbuscar {
                    tempJuegos.append(mijuego)
                }
            }
        break
        }
    }
    tempJuegos.sort(by: {($0[1] ) < ($1[1] ) })
    for juego in tempJuegos {
        testJuegosXml.append(juego)
    }
    print("Nivel:\(nivelActual)")
    
}

func subirNivel() {
    if nivelActual <= 4 {
        nivelActual += 1
    }
    if nivelActual == 1 {
        juegosNivel0 = testJuegosXml
    }
    else if nivelActual == 2 {
        juegosNivel1 = testJuegosXml
    }
    else if nivelActual == 3 {
        juegosNivel2 = testJuegosXml
    }
    else if nivelActual == 4 {
        juegosNivel3 = testJuegosXml
    }
    else if nivelActual == 5 {
        juegosNivel4 = testJuegosXml
    }
    
    //MARK: ver si hay subcarpetas y añadirlas como elementos al array de Juegos
    
    let cuentaBase = rutaBase.numberOfOccurrencesOf(string: "/")
    xmlRutasRaw = []
    //print("RUTA BASE: \(rutaBase)")
    for game in rawJuegosXml {
        let rutaRaw = game[0] as NSString?
        let rutaEdit = rutaRaw?.deletingLastPathComponent
        xmlRutasRaw.append(rutaEdit!)
    }
    
    
    xmlRutasUnique = []
    let countedSet = NSCountedSet(array: xmlRutasRaw)
    for ruta in countedSet {
        var miruta = String()
        miruta = ruta as! String
        let cuenta = miruta.numberOfOccurrencesOf(string: "/")
        let grupo = [String(miruta) , String(cuenta)]
        xmlRutasUnique.append(grupo)
    }
    
    testJuegosXml = []
    var tempXml = [[String]]()
    
    //MARK: Primero añadir icono de volver y luego comprobar si hay subcarpetas
    
    let migrupo = ["Volver" , "Volver", "", "", "", "", "", "", "",Bundle.main.bundlePath + "/Contents/Resources/Themes/back.png", "", "", "", "", "", "", "", "", "", "", "", "", "Volver", ""]
    testJuegosXml.append(migrupo)
    
    for ruta in xmlRutasUnique {
        let rutaABuscar = ruta[0] as NSString
        let rutaABuscarPlana = rutaABuscar.deletingLastPathComponent
        //print("RUTA EN ARRAY: \(rutaABuscar)")
        let nivel = Int(ruta[1])! - minLevel
        if nivel == (nivelActual + 1) && rutaABuscarPlana == rutaBase{
            let miruta = ruta[0] as String
            let nombreRaw = ruta[0] as NSString
            let nombre = String(nombreRaw.lastPathComponent) as String
            // El 9 es la imagen de fondo
            let migrupo = [String(miruta) , nombre, "", "", "", "", "", "", "", getImagen(Ruta: miruta), "", "", "", "", "", "", "", "", "", "", "", "", "Carpeta", ""]
            tempXml.append(migrupo)
        }
    }
    tempXml.sort(by: {($0[1] ) < ($1[1] ) })
    for juego in tempXml {
        testJuegosXml.append(juego)
    }
    
    //MARK: Añadir los juegos que están en la ruta base
    tempXml = []
    let FilaAllTheGames = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
    if FilaAllTheGames != nil {
        for game in allTheGames[FilaAllTheGames!].games {
            let rutaDelJuego = game.path as NSString
            let rutaJuegoABuscar = rutaDelJuego.deletingLastPathComponent
            let nombreDelJuego = game.name as NSString
            let nombre = nombreDelJuego.lastPathComponent
            let mijuego = [game.path, nombre, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
            if rutaJuegoABuscar == rutaBase {
                tempXml.append(mijuego)
            }
        }
    }
    tempXml.sort(by: {($0[1] ) < ($1[1] ) })
    for juego in tempXml {
        testJuegosXml.append(juego)
    }
    
    print("Nivel \(nivelActual)")
    //print(testJuegosXml)
    juegosXml = testJuegosXml
    myCollectionView.reloadData()
    cargaItemCero ()
    let indexPath:IndexPath = IndexPath(item: 0, section: 0)
    var set = Set<IndexPath>()
    set.insert(indexPath)
    myCollectionView.selectItems(at: set, scrollPosition: .top)
    
    
}

func bajarNivel() {
    if nivelActual > 0 {
        nivelActual -= 1
    }
    if nivelActual == 0 {
        testJuegosXml = juegosNivel0
    }
    if nivelActual == 1 {
        testJuegosXml = juegosNivel1
    }
    if nivelActual == 2 {
        testJuegosXml = juegosNivel2
    }
    if nivelActual == 3 {
        testJuegosXml = juegosNivel3
    }
    if nivelActual == 4 {
        testJuegosXml = juegosNivel4
    }
    print("Nivel \(nivelActual)")
    print(testJuegosXml)
    juegosXml = testJuegosXml
    myCollectionView.reloadData()
    cargaItemCero ()
    let indexPath:IndexPath = IndexPath(item: 0, section: 0)
    var set = Set<IndexPath>()
    set.insert(indexPath)
    myCollectionView.selectItems(at: set, scrollPosition: .top)
    if juegosXml[0][10] == "" {
        tieneVideo = false
        myPlayer.isHidden = true
    } else {
        tieneVideo = true
        myPlayer.isHidden = false
    }
    
}

func getFolderImageDefault() -> String {
    var path =  Bundle.main.bundlePath + "/Contents/Resources/Themes/folder.png"
    return path
    print (path)
}

func cargaItemCero (){
    columna = 0
    myRatingStar.doubleValue = (Double(juegosXml[0][18]) ?? 0) * 5
    myPlayersLabel.stringValue = juegosXml[0][17]
    myGameLabel.stringValue = juegosXml[0][1]
    if juegosXml[0][4] != "" {
        myBotonManual.isHidden = false
    } else {
        myBotonManual.isHidden = true
    }
    let miBox = juegosXml[columna][23]
    if miBox != "" {
        let imagenURL = URL(fileURLWithPath: miBox)
        var imagen = NSImage(contentsOf: imagenURL)
        myBox3DButton.image = imagen
        myBox3DButton.isHidden = false
    } else {
        myBox3DButton.isHidden = true
    }
    
    if juegosXml[0][10] == "" {
        //tieneVideo = false
        //myPlayer.isHidden = true
    } else {
        //tieneVideo = true
        //myPlayer.isHidden = false
    }
    myConsolaLabel.stringValue = juegosXml[0][22]
    
}

func getVideo(Ruta: String) -> String {
    var miVideo = String()
    var videos = [String]()
    for game in rawJuegosXml {
        let rutaCompleta = game[0] as NSString
        let ruta = rutaCompleta.deletingLastPathComponent
        if ruta == Ruta {
            if game[10] != "" {
                videos.append(game[10])
            }
        }
    }
    if videos.count > 0 {
        miVideo = videos.randomElement()!
    } else {
        miVideo = ""
    }
    return miVideo
}
func getImagen(Ruta: String) -> String {
    var miImagen = String()
    var imagenes = [String]()
    for game in rawJuegosXml {
        let rutaCompleta = game[0] as NSString
        let ruta = rutaCompleta.deletingLastPathComponent
        if ruta == Ruta {
            if game[9] != "" {
                imagenes.append(game[9])
            }
        }
    }
    if imagenes.count > 0 {
        miImagen = imagenes.randomElement()!
    } else {
        miImagen = ""
    }
    return miImagen
}

func cargaItemColumna() {
    juegosXml = testJuegosXml
    myRatingStar.doubleValue = (Double(juegosXml[columna][18]) ?? 0) * 5
    myPlayersLabel.stringValue = juegosXml[columna][17]
    myGameLabel.stringValue = juegosXml[columna][1]
    if juegosXml[columna][4] != "" {
        myBotonManual.isHidden = false
    } else {
        myBotonManual.isHidden = true
    }
    let miBox = juegosXml[columna][23]
    if miBox != "" {
        let imagenURL = URL(fileURLWithPath: miBox)
        var imagen = NSImage(contentsOf: imagenURL)
        myBox3DButton.image = imagen
        myBox3DButton.isHidden = false
    } else {
        myBox3DButton.isHidden = true
    }
    
    if juegosXml[columna][10] == "" {
        tieneVideo = false
        myPlayer.isHidden = true
        myPlayer.player?.play()
    } else {
        tieneVideo = true
        myPlayer.isHidden = false
    }
    myConsolaLabel.stringValue = juegosXml[columna][22]
    myCollectionView.reloadData()
    let indexPath:IndexPath = IndexPath(item: columna, section: 0)
    var set = Set<IndexPath>()
    set.insert(indexPath)
    myCollectionView.deselectItems(at: set)
    myCollectionView.selectItems(at: set, scrollPosition: .top)
    
}
