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
    
    let minimo = Int(xmlRutasUnique.min(by: {($0[1] ) < ($1[1])  })![1])
    let maximo = Int(xmlRutasUnique.max(by: {($0[1] ) < ($1[1])  })![1])
    minLevel = minimo!
    maxLevel = maximo!
    
    for a in 0..<xmlRutasUnique.count {
        let miNivel = Int(xmlRutasUnique[a][1])! - minimo!
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
            let migrupo = [String(miruta) , nombre, "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
            testJuegosXml.append(migrupo)
        }
    }
    for consola in allTheGames {
        if consola.sistema == nombresistemaactual {
            for game in consola.games {
                let rutaDelJuego = game.path as NSString
                let rutaJuegoABuscar = rutaDelJuego.deletingLastPathComponent
                let mijuego = [game.path, game.name, game.description, game.map, game.manual, game.news, game.tittleshot, game.fanart,game.thumbnail,game.image, game.video, game.marquee, game.releasedate, game.developer, game.publisher, game.genre, game.lang, game.players, game.rating, game.fav, game.comando, game.core, game.system, game.box]
                if rutaJuegoABuscar == rutaAbuscar {
                    testJuegosXml.append(mijuego)
                }
            }
        break
        }
    }
    print(testJuegosXml)
}
