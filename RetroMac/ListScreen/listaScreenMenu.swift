//
//  listaScreenMenu.swift
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
    
    func crearItemsMenu() -> [NSMenuItem]{
        
        ///Menu ITEMS de Scrapear
        
        var arrayMenu = [NSMenuItem]()
        
        let scrapGame = NSMenuItem(title: "Scrapear Juego", action: #selector(buscaJuego), keyEquivalent: "")
        let scrapSystem = NSMenuItem(title: "Scrapear Sistema", action: #selector(escrapeartodos), keyEquivalent: "")
        let scrapAll = NSMenuItem(title: "Scrapear Todos los Sistemas", action: nil, keyEquivalent: "")
        let scrapSubmenu = NSMenu()
        scrapSubmenu.addItem(scrapGame)
        scrapSubmenu.addItem(scrapSystem)
        scrapSubmenu.addItem(scrapAll)
        let scrapItem = NSMenuItem(title: "Scrapear", action: nil, keyEquivalent: "")
        if sistemaActual != "Favoritos" {
            scrapItem.submenu = scrapSubmenu
        }
        
        
        /// Menu ITEMS de Juego
        
        let renameGame = NSMenuItem(title: "Cambiar Nombre del Juego", action: #selector(enableBoxEditar), keyEquivalent: "")
        let favGame = NSMenuItem(title: "Añadir Juego a Favoritos", action: #selector(favGames), keyEquivalent: "")
        let unfavGame = NSMenuItem(title: "Eliminar Juego de Favoritos", action: #selector(unfavGames), keyEquivalent: "")
        let searchGame = NSMenuItem(title: "Buscar Juego", action: nil, keyEquivalent: "")
        let delGame = NSMenuItem(title: "Borrar Juego", action: #selector(EnableBoxBorrar), keyEquivalent: "")
        let bezelGame = NSMenuItem(title: "Usar Bezels/Marcos en el Juego", action: nil, keyEquivalent: "")
        let NetGame = NSMenuItem(title: "Iniciar Partida de NETPLAY", action: #selector(lanzarNetPlay), keyEquivalent: "")
        
        let gameBezelSubmenu  = NSMenu()
        bezelGame.submenu = gameBezelSubmenu
        
        let autoGameBezel = NSMenuItem(title: "Automático", action: #selector(autoGameBezel), keyEquivalent: "")
        let siGameBezel = NSMenuItem(title: "Sí", action: #selector(siGameBezel), keyEquivalent: "")
        let noGameBezel = NSMenuItem(title: "No", action: #selector(noGameBezel), keyEquivalent: "")
        gameBezelSubmenu.addItem(autoGameBezel)
        gameBezelSubmenu.addItem(siGameBezel)
        gameBezelSubmenu.addItem(noGameBezel)
        
        let gameSubmenu = NSMenu()
        
        
        gameSubmenu.addItem(renameGame)
        gameSubmenu.addItem(favGame)
        gameSubmenu.addItem(unfavGame)
        gameSubmenu.addItem(searchGame)
        gameSubmenu.addItem(delGame)
        
        let gameItem = NSMenuItem(title: "Opciones del Juego", action: nil, keyEquivalent: "")
        //if sistemaActual != "Favoritos" {
        gameItem.submenu = gameSubmenu
        //}
        
        /// Menu ITEMS de sistema
        
        let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController
        let button = controller!.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
        
        var cuentaCores = button?.cores?.count
        let sistemaItem = NSMenuItem(title: "Opciones del Sistema", action: nil, keyEquivalent: "")
        let sistemaSubmenu = NSMenu()
        if button?.cores != nil {
            
            let cambiarItem = NSMenuItem(title: "Cambiar Core", action: nil, keyEquivalent: "")
            sistemaSubmenu.addItem(cambiarItem)
            let misCores = button?.cores
            
            let coreSubmenu = NSMenu()
            for a in 0..<cuentaCores! {
                
                var core = misCores![a][1]
                var tooltip = misCores![a][2]
                var comando: String =  (button?.Comando)!
                if comando.contains(core + "_libretro.dylib") {
                    core = core + " ✅"
                }
                
                let coreItem = NSMenuItem(title: core, action: #selector(coresistema), keyEquivalent: "")
                coreItem.toolTip = tooltip
                coreSubmenu.addItem(coreItem)
            }
            cambiarItem.submenu = coreSubmenu
            sistemaItem.submenu = sistemaSubmenu
            
            
        }
        //SubMenú Shader por sistema
        let cambiarShaderItem = NSMenuItem(title: "Establecer Shader del Sistema", action: nil, keyEquivalent: "")
        sistemaSubmenu.addItem(cambiarShaderItem)
        let sistemaShaders = NSMenu()
        
        let borrarShaderItem = NSMenuItem(title: "NINGUNO", action: #selector(removeSystemShader), keyEquivalent: "")
        var miSystemShader = String()
        let mifilashader = arraySystemsShaders.firstIndex(where: {$0[0] == sistemaActual})
        if mifilashader != nil {
            miSystemShader = arraySystemsShaders[mifilashader!][1]
        } else {
            borrarShaderItem.title = "NINGUNO ✅"
        }
        let tooltipSystem = "NINGUNO"
        borrarShaderItem.toolTip = tooltipSystem
        sistemaShaders.addItem(borrarShaderItem)
        
        for shader in arrayShaders {
            var miTitulo = String()
            if shader[1] == miSystemShader {
                miTitulo = shader[1] + " ✅"
            } else {
                miTitulo = shader[1]
            }
            let shaderItem = NSMenuItem(title: miTitulo, action: #selector(setSystemShader), keyEquivalent: "")
            let tooltip2 = shader[0]
            shaderItem.toolTip = tooltip2
            sistemaShaders.addItem(shaderItem)
        }
        cambiarShaderItem.submenu = sistemaShaders
        
        
        
        
        let sistemBezelMenu = NSMenuItem(title: "Usar Bezels/Marcos en el Sistema", action: nil, keyEquivalent: "")
        let sistemBezelSubMenu = NSMenu ()
        
        let siSystemBezel = NSMenuItem(title: "Sí", action: #selector(siSistemBezel), keyEquivalent: "")
        let noSystemBezel = NSMenuItem(title: "No", action: #selector(noSistemBezel), keyEquivalent: "")
        
        let sistema = sistemaActual
        let filaAbuscar = arraySystemsBezels.firstIndex(where: {$0[0] == sistema})
        let siONoBezelSistema  = String()
        if filaAbuscar != nil {
            siSystemBezel.title = siSystemBezel.title.replacingOccurrences(of: "  ✅", with: "") + " ✅"
        } else {
            noSystemBezel.title = noSystemBezel.title.replacingOccurrences(of: "  ✅", with: "") + " ✅"
        }
        
        
        sistemBezelSubMenu.addItem(siSystemBezel)
        sistemBezelSubMenu.addItem(noSystemBezel)
        sistemBezelMenu.submenu = sistemBezelSubMenu
        sistemaSubmenu.addItem(sistemBezelMenu)
        
        ///SubMEnu core por juego
        let coreSubmenu = NSMenu()
        var mititulo = "Automático"
        let coreItem = NSMenuItem(title: mititulo, action: #selector(coreauto), keyEquivalent: "")
        coreSubmenu.addItem(coreItem)
        
        
        if button?.cores != nil {
            
            let cambiarItem = NSMenuItem(title: "Cambiar Core", action: nil, keyEquivalent: "")
            let misCores = button?.cores
            
            
            for a in 0..<cuentaCores! {
                
                var core = misCores![a][1]
                var tooltip = misCores![a][2]
                var comando: String =  (button?.Comando)!
                if comando.contains(core + "_libretro.dylib") {
                    //core = core + "✅"
                }
                
                let coreItem = NSMenuItem(title: core, action: #selector(corejuego), keyEquivalent: "")
                coreItem.toolTip = tooltip
                coreSubmenu.addItem(coreItem)
            }
            cambiarItem.submenu = coreSubmenu
            gameSubmenu.addItem(cambiarItem)
            //shader submenu
            
            let shaderMenu = NSMenuItem(title: "Establecer Shader del Juego", action: nil, keyEquivalent: "")
            let shaderSubmenu = NSMenu()
            shaderMenu.submenu = shaderSubmenu
            
            let shaderItemDefault = NSMenuItem(title: "NINGUNO", action: #selector(setShader), keyEquivalent: "")
            let defaultTooltip = "NINGUNO"
            shaderItemDefault.toolTip = defaultTooltip
            shaderSubmenu.addItem(shaderItemDefault)
            
            let shaderItemAuto = NSMenuItem(title: "AUTOMÁTICO", action: #selector(autoShader), keyEquivalent: "")
            let autoTooltip = ""
            shaderItemAuto.toolTip = autoTooltip
            shaderSubmenu.addItem(shaderItemAuto)
            
            for shader in arrayShaders {
                let shaderItem = NSMenuItem(title: shader[1], action: #selector(setShader), keyEquivalent: "")
                let tooltip2 = shader[0]
                shaderItem.toolTip = tooltip2
                shaderSubmenu.addItem(shaderItem)
            }
            gameSubmenu.addItem(shaderMenu)
            gameSubmenu.addItem(bezelGame)
            gameSubmenu.addItem(NetGame)
        }
        
        
        
        
        ///NETPLAY
        
        
        ///
        
        arrayMenu.append(scrapItem)
        arrayMenu.append(gameItem)
        
//
        
        arrayMenu.append(sistemaItem)
        
        return arrayMenu
    }
    
    
    func setupMenu() {
        contextMenu.removeAllItems()
        let items = crearItemsMenu()
        items.forEach {contextMenu.addItem($0)}
        //self.view.menu = contextMenu
    }
    
    func itemsPorJuego() {
        //CORES: Comprobar si está en Automático y añadir el tick si lo está
        var mititulo = "Automático"
        var estaenArray = false
        let mifila = juegosTableView.selectedRow
        let pathabuscar = juegosXml[mifila][0]
        let filaencontrada = arrayGamesCores.firstIndex(where: {$0[0] == pathabuscar})
        if filaencontrada != nil {
            estaenArray = true
        }else {
            estaenArray = false
        }
        
        if estaenArray == false {
            mititulo = mititulo + " ✅"
            contextMenu.items[1].submenu?.items[5].submenu?.items[0].title = mititulo
        }else {
            contextMenu.items[1].submenu?.items[5].submenu?.items[0].title = mititulo
        }
        
        
        
        // Si no está en auto, mirar qué core tiene y añadir el tick
        for a in 1..<(contextMenu.items[1].submenu?.items[5].submenu?.items.count)! {
            var estaeljuegoenelarray = false
            var tituloant = contextMenu.items[1].submenu?.items[5].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: "")
            
            contextMenu.items[1].submenu?.items[5].submenu?.items[a].title = tituloant!
            let mifila = juegosTableView.selectedRow
            let pathabuscar = juegosXml[mifila][0]
            let filaencontrada = arrayGamesCores.firstIndex(where: {$0[0] == pathabuscar})
            if filaencontrada != nil {
                let comandoCore = arrayGamesCores[filaencontrada ?? 0][1]
                
                var core = tituloant! + "_libretro.dylib"
                if comandoCore.contains(core) {
                    
                    var nuevotitulo = tituloant! + " ✅"
                    contextMenu.items[1].submenu?.items[5].submenu?.items[a].title = nuevotitulo
                    break
                }
                
            }
        }
        
        // MARK: Poner tick a shader seleccionado de Juego
        
        for a in 1..<(contextMenu.items[1].submenu?.items[6].submenu?.items.count)! {
            contextMenu.items[1].submenu?.items[6].submenu?.items[a].title = (contextMenu.items[1].submenu?.items[6].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        
        let mifila2 = juegosTableView.selectedRow
        let miRuta = juegosXml[mifila2][0]
        let miGameShaderFila = arrayGamesShaders.firstIndex(where: {$0[0] == miRuta})
        if miGameShaderFila != nil {
            //Tiene Shader o NINGUNO
            let miShader = arrayGamesShaders[miGameShaderFila!][1].replacingOccurrences(of: " ✅", with: "")
            let miFilaItem = contextMenu.items[1].submenu?.items[6].submenu?.items.firstIndex(where: {$0.title == miShader})
            if miFilaItem != nil {
                contextMenu.items[1].submenu?.items[6].submenu?.items[miFilaItem!].title = (contextMenu.items[1].submenu?.items[6].submenu?.items[miFilaItem!].title)!.replacingOccurrences(of: " ✅", with: "") + " ✅"
            }

        } else {
            contextMenu.items[1].submenu?.items[6].submenu?.items[1].title = "AUTOMÁTICO ✅"
        }
        
        // MARK: Poner tick al bezel del juego :
        // puede ser Automático, Sí o No
        let mifilaBezelGame = arrayGamesBezels.firstIndex(where: {$0[0] == miRuta})
        if mifilaBezelGame != nil {
            
        } else {
            contextMenu.items[1].submenu?.items[7].submenu?.items[0].title = (contextMenu.items[1].submenu?.items[7].submenu?.items[0].title)!.replacingOccurrences(of: " ✅", with: "") + " ✅"
        }
        //nombresSystemaShaders()
    }
    
    
}
