//
//  listScreenNetPlay.swift
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
        
        let mifila = juegosTableView.selectedRow
        let mirom = "\"\(juegosXml[mifila][0])\""
        let nombredelarchivo = juegosXml[mifila][0].replacingOccurrences(of: rutaApp , with: "")
        var comandojuego = juegosXml[mifila][20]
        if comandojuego.contains("RetroArch") {
            gameOverlay(game: nombredelarchivo)
            var fila = arrayGamesCores.firstIndex(where: {$0[0] == juegosXml[mifila][0]})
            if fila != nil {
                comandojuego = arrayGamesCores[fila!][1]
            }
            var micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
            
            var comando = micomando.replacingOccurrences(of: "%ROM%", with: mirom).replacingOccurrences(of: "-L", with: "-H -L")
            if playingVideo == true {
                SingletonState.shared.mySnapPlayer?.player?.pause()
                snapPlayer.player?.pause()
            }
            print(comando)
            configNetplay()
            
            Commands.Bash.system("\(comando)")
            comando=""
            
        }
        
    }
    
}
