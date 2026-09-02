//
//  listScreenBezels&Shaders.swift
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
    
    @objc func setShader (_ sender: NSMenuItem) {
        let nombre = sender.title.replacingOccurrences(of: " ✅", with: "")
        let ruta = sender.toolTip
        let fila = juegosTableView.selectedRow
        let rutajuego = juegosXml[fila][0]
        let migrupo = [rutajuego, nombre, ruta!] as [String]
        if arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego}) != nil {
            let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego})
            arrayGamesShaders[filaABuscar!][1] = nombre
            arrayGamesShaders[filaABuscar!][2] = ruta!
        }else {
            arrayGamesShaders.append(migrupo)
        }
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesShaders, forKey: "juegosShaders")
        
        // MARK: Actualizar los elementos del menú
        
        for a in 1..<(contextMenu.items[1].submenu?.items[6].submenu?.items.count)! {
            contextMenu.items[1].submenu?.items[6].submenu?.items[a].title = (contextMenu.items[1].submenu?.items[6].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        sender.title = sender.title.replacingOccurrences(of: " ✅", with: "") + " ✅"
    }
    
    @objc func removeShader (_ sender: NSMenuItem) {
        let nombre = sender.title.replacingOccurrences(of: " ✅", with: "")
        let ruta = sender.toolTip
        let fila = juegosTableView.selectedRow
        let rutajuego = juegosXml[fila][0]
        let migrupo = [rutajuego, nombre, ruta!] as [String]
        if arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego}) != nil {
            let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego})
            arrayGamesShaders[filaABuscar!][1] = nombre
            arrayGamesShaders[filaABuscar!][2] = ruta!
        }else {
            arrayGamesShaders.append(migrupo)
        }
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesShaders, forKey: "juegosShaders")
        
        for a in 1..<(contextMenu.items[1].submenu?.items[6].submenu?.items.count)! {
            contextMenu.items[1].submenu?.items[6].submenu?.items[a].title = (contextMenu.items[1].submenu?.items[6].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        sender.title = sender.title.replacingOccurrences(of: " ✅", with: "") + " ✅"
        
    }
    
    @objc func autoShader (_ sender: NSMenuItem) {
        let fila = juegosTableView.selectedRow
        let rutajuego = juegosXml[fila][0]
        guard let filaABuscar = arrayGamesShaders.firstIndex(where: {$0[0] == rutajuego}) else {return}
        arrayGamesShaders.remove(at: filaABuscar)
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesShaders, forKey: "juegosShaders")
        for a in 1..<(contextMenu.items[1].submenu?.items[6].submenu?.items.count)! {
            contextMenu.items[1].submenu?.items[6].submenu?.items[a].title = (contextMenu.items[1].submenu?.items[6].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        sender.title = sender.title.replacingOccurrences(of: " ✅", with: "") + " ✅"
    }
    @objc func setSystemShader (_ sender: NSMenuItem) {
        
        for a in 0..<(contextMenu.items[2].submenu?.items[1].submenu?.items.count)! {
            contextMenu.items[2].submenu?.items[1].submenu?.items[a].title = (contextMenu.items[2].submenu?.items[1].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        let sistema = sistemaActual
        let nombre = sender.title.replacingOccurrences(of: " ✅", with: "")
        let ruta = sender.toolTip
        let migrupo = [sistema , nombre, ruta!] as [String]
        if arraySystemsShaders.firstIndex(where: {$0[0] == sistema}) != nil {
            let filaABuscar = arraySystemsShaders.firstIndex(where: {$0[0] == sistema})
            arraySystemsShaders[filaABuscar!][1] = nombre
            arraySystemsShaders[filaABuscar!][2] = ruta!
        } else {
            arraySystemsShaders.append(migrupo)
        }
        let defaults = UserDefaults.standard
        defaults.set(arraySystemsShaders, forKey: "systemsShaders")
        print(arraySystemsShaders)
        
        sender.title = nombre + " ✅"
    }
    
    @objc func removeSystemShader (_ sender: NSMenuItem) {
        let sistema = sistemaActual
        guard let filaABuscar = arraySystemsShaders.firstIndex(where: {$0[0] == sistema}) else {return}
        arraySystemsShaders.remove(at: filaABuscar)
        let defaults = UserDefaults.standard
        defaults.set(arraySystemsShaders, forKey: "systemsShaders")
                     
        for a in 0..<(contextMenu.items[2].submenu?.items[1].submenu?.items.count)! {
            contextMenu.items[2].submenu?.items[1].submenu?.items[a].title = (contextMenu.items[2].submenu?.items[1].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        contextMenu.items[2].submenu?.items[1].submenu?.items[0].title = "Ninguno ✅"
        print(arraySystemsShaders)
    }
    
    func nombresSystemaShaders() {
        let mifilashader = arraySystemsShaders.firstIndex(where: {$0[0] == sistemaActual})
        if mifilashader != nil {
            let misystemShader = arraySystemsShaders[mifilashader!][1]
            for a in 0..<(contextMenu.items[2].submenu?.items[1].submenu?.items.count)! {
                if contextMenu.items[2].submenu?.items[1].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: "") == misystemShader {
                    contextMenu.items[2].submenu?.items[1].submenu?.items[a].title = (contextMenu.items[2].submenu?.items[1].submenu?.items[a].title.replacingOccurrences(of: " ✅", with: ""))! + " ✅"
                }
            }
            
        } else {
            contextMenu.items[2].submenu?.items[1].submenu?.items[0].title = "Ninguno ✅"
        }
    }
    
    @objc func siGameBezel (){
        let mifila = juegosTableView.selectedRow
        let mijuego = juegosXml[mifila][0]
        let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
        if filaenArray != nil {
            arrayGamesBezels[filaenArray!][1] = "Sí"
            
        } else {
            let migrupo = [mijuego, "Sí"]
            arrayGamesBezels.append(migrupo)
        }
        
        //Falta quitar los ticks
        for a in 0..<(contextMenu.items[1].submenu?.items[7].submenu!.items.count)! {
            contextMenu.items[1].submenu?.items[7].submenu!.items[a].title  = (contextMenu.items[1].submenu?.items[7].submenu!.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        contextMenu.items[1].submenu?.items[7].submenu!.items[1].title =  (contextMenu.items[1].submenu?.items[7].submenu?.items[1].title.replacingOccurrences(of: " ✅", with: ""))! + " ✅"
        
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        
    
    }
    
    @objc func noGameBezel (){
        let mifila = juegosTableView.selectedRow
        let mijuego = juegosXml[mifila][0]
        let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
        if filaenArray != nil {
            arrayGamesBezels[filaenArray!][1] = "No"
            
        } else {
            let migrupo = [mijuego, "No"]
            arrayGamesBezels.append(migrupo)
        }
        
        
        for a in 0..<(contextMenu.items[1].submenu?.items[7].submenu!.items.count)! {
            contextMenu.items[1].submenu?.items[7].submenu!.items[a].title  = (contextMenu.items[1].submenu?.items[7].submenu!.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        contextMenu.items[1].submenu?.items[7].submenu!.items[2].title = ( contextMenu.items[1].submenu?.items[7].submenu?.items[2].title)!.replacingOccurrences(of: " ✅", with: "") + " ✅"
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        print(arrayGamesBezels)
    }
    
    @objc func autoGameBezel() {
        let mifila = juegosTableView.selectedRow
        let mijuego = juegosXml[mifila][0]
        let filaenArray = arrayGamesBezels.firstIndex(where: {$0[0] == mijuego})
        if filaenArray != nil {
            arrayGamesBezels.remove(at: filaenArray!)
            for a in 0..<(contextMenu.items[1].submenu?.items[7].submenu!.items.count)! {
                contextMenu.items[1].submenu?.items[7].submenu!.items[a].title  = (contextMenu.items[1].submenu?.items[7].submenu!.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
            }
            contextMenu.items[1].submenu?.items[7].submenu!.items[0].title = ( contextMenu.items[1].submenu?.items[7].submenu?.items[0].title.replacingOccurrences(of: " ✅", with: ""))! + " ✅"
        }
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesBezels, forKey: "juegosBezels")
        print(arrayGamesBezels)
    }
    
    @objc func siSistemBezel(){
        let sistema = sistemaActual
        let filaAbuscar = arraySystemsBezels.firstIndex(where: {$0[0] == sistema})
        if filaAbuscar != nil {
            
        } else {
            let miGrupo = [sistema, "Sí"]
            arraySystemsBezels.append(miGrupo)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(arraySystemsBezels, forKey: "systemsBezels")
        
        //print(contextMenu.items[2].submenu?.items[2].submenu!.items[0])
        for a in 0..<(contextMenu.items[2].submenu?.items[2].submenu!.items.count)!{
            contextMenu.items[2].submenu?.items[2].submenu!.items[a].title = (contextMenu.items[2].submenu?.items[2].submenu!.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        contextMenu.items[2].submenu?.items[2].submenu!.items[0].title = (contextMenu.items[2].submenu?.items[2].submenu!.items[0].title.replacingOccurrences(of: " ✅", with: ""))! + " ✅"
        
       
        
    }
    
    @objc func noSistemBezel(){
        
        let sistema = sistemaActual
        let filaAbuscar = arraySystemsBezels.firstIndex(where: {$0[0] == sistema})
        if filaAbuscar != nil {
            arraySystemsBezels.remove(at: filaAbuscar!)
        } else {
            
        }
        
        let defaults = UserDefaults.standard
        defaults.set(arraySystemsBezels, forKey: "systemsBezels")
        
        for a in 0..<(contextMenu.items[2].submenu?.items[2].submenu!.items.count)!{
            contextMenu.items[2].submenu?.items[2].submenu!.items[a].title = (contextMenu.items[2].submenu?.items[2].submenu!.items[a].title.replacingOccurrences(of: " ✅", with: ""))!
        }
        
        contextMenu.items[2].submenu?.items[2].submenu!.items[1].title = (contextMenu.items[2].submenu?.items[2].submenu!.items[1].title.replacingOccurrences(of: " ✅", with: ""))! + " ✅"
       
        
    }
    
    @objc func coresistema (_ sender: NSMenuItem) {
        
        let newComand = sender.toolTip!
        print(sistemaActual)
        print(allTheGames[0].fullname)
        var FilaAll = allTheGames.firstIndex(where: {$0.fullname == sistemaActual})
        var FilaSystems = allTheSystems.firstIndex(where: {$0.nombrelargo == sistemaActual})
        print(FilaSystems)
        allTheSystems[FilaSystems!].comando = newComand
        allTheGames[FilaAll!].command = newComand
        for a in 0..<allTheGames[FilaAll!].games.count {
            allTheGames[FilaAll!].games[a].comando = newComand
        }
        for numero in 0..<juegosXml.count {
            juegosXml[numero][20] = newComand
        }
        escribeSistemas()
        recargar()
        
    }
    
    @objc func corejuego (_ sender: NSMenuItem) {
    
        let mifila = juegosTableView.selectedRow
        var newComand = sender.toolTip!
        let mipath = juegosXml[mifila][0]
        let migrupo = [mipath, newComand]
        let filaArray = arrayGamesCores.firstIndex(where: {$0[0] == mipath})
        if filaArray != nil {
            print("Está en el array")
            arrayGamesCores.remove(at: filaArray!)
            arrayGamesCores.append(migrupo)
            
        }else {
            print("no está")
            arrayGamesCores.append(migrupo)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesCores, forKey: "juegosCores")
        juegosTableView.reloadData()
        let indexSet = NSIndexSet(index: mifila)
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        self.view.window?.makeFirstResponder(self.juegosTableView)
        
        
        print(arrayGamesCores)
    }
    
    @objc func coreauto (_ sender: NSMenuItem) {
        let mifila = juegosTableView.selectedRow
        let mipath = juegosXml[mifila][0]
        let filaArray = arrayGamesCores.firstIndex(where: {$0[0] == mipath})
        if filaArray != nil {
            print("Está en el array")
            arrayGamesCores.remove(at: filaArray!)
        }else {
            
        }
        let defaults = UserDefaults.standard
        defaults.set(arrayGamesCores, forKey: "juegosCores")
        juegosTableView.reloadData()
        let indexSet = NSIndexSet(index: mifila)
        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        self.view.window?.makeFirstResponder(self.juegosTableView)
        //print(arrayGamesCores)
    }
    
}
