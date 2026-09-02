//
//  NetPlayListController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 24/2/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa
import Commands
import AVKit
import AVFoundation
import GameController

class NetPlayListController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var NetPlayTable: NSTableView!
    @IBOutlet weak var actualizarBoton: NSButton!
    @IBOutlet weak var cerrarBoton: NSButton!
    @IBOutlet weak var conectarBoton: NSButton!
    
    @IBAction func actualizarLista(_ sender: Any) {
        netplayPlays = []
        cargaPartidasNetplay()
        NetPlayTable.reloadData()
        
    }
    
    @IBAction func cerrar(_ sender: Any) {
        //ventana = "Principal"
        ventanaModal = "Ninguna"
        myPlayer.player?.play()
        self.dismiss(self)
    }
    
    @IBAction func conectar(_ sender: Any) {
        launchGame ()
    }
    
    override func viewDidLoad() {
        
        print("*****ENTRO EN NETPLAY******")
        super.viewDidLoad()
        netplayPlays = []
        cargaPartidasNetplay ()
        NetPlayTable.reloadData()
        myPlayer.player?.pause()
        //ventana = "Netplay"
        ventanaModal = "Neplay"
        NetPlayTable.doubleAction = #selector(launchGame)
        //cargaPartidasNetplay ()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        netplayPlays = []
        cargaPartidasNetplay()
        NetPlayTable.reloadData()
    }
    
    
    func numberOfRows(in NetPlayTable: NSTableView) -> Int {
        
        return netplayPlays.count
        
    }
    
    func tableView(_ NetPlayTable: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let vw = NetPlayTable.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        
        if tableColumn?.title == "País" {
            vw.textField?.stringValue = netplayPlays[row].country ?? "N/A"
       
            
        }
        if tableColumn?.title == "Usuario" {
            vw.textField?.stringValue = netplayPlays[row].username ?? "N/A"
            
            
        }
        if tableColumn?.title == "Juego" {
            vw.textField?.stringValue = netplayPlays[row].game_Name!
            vw.wantsLayer = true
            
        }
        if tableColumn?.title == "Core" {
            vw.textField?.stringValue = netplayPlays[row].core_Name! + " - " + netplayPlays[row].core_Version!
            vw.wantsLayer = true
            
        }
        if tableColumn?.title == "Versión RA" {
            vw.textField?.stringValue = netplayPlays[row].retroarch_Version!
            vw.wantsLayer = true
            
        }
        if tableColumn?.title == "Disponible" {
            vw.textField?.stringValue = String(netplayPlays[row].enabled ?? "NO")
            vw.wantsLayer = true
            if netplayPlays[row].enabled == "NO" {
                vw.layer?.backgroundColor = CGColor(red: 255, green: 0, blue: 0, alpha: 0.5)
            } else {
                //vw.layer?.backgroundColor = NSColor.green.cgColor
                vw.layer?.backgroundColor = CGColor(red: 0, green: 255, blue: 0, alpha: 0.5)
            }
        }
        if tableColumn?.title == "RELÉ" {
            vw.textField?.stringValue = String(netplayPlays[row].isRelay ?? "NO")
        }
        
        
        return vw
        
    }
    
    
    
    @objc func launchGame () {
        SingletonState.shared.myBackPlayer?.player?.pause()
        gameShader(shader: "")
        noGameOverlay()
        let numero = (self.NetPlayTable.selectedRow)
        var micomando = netplayPlays[numero].comando!
        let mirom = "\"\(String(describing: netplayPlays[numero].gamePath!))\""
        let miJuego = netplayPlays[numero].gamePath!
        var miIp = String()
        var miPuerto = String()
        var miRelay = Bool ()
        let rutaRetroMac = Bundle.main.bundlePath.replacingOccurrences(of: "/RetroMac.app", with: "")
        
        if netplayPlays[numero].mitm_Port != "" {
            miPuerto = netplayPlays[numero].mitm_Port ?? ""
        }else {
            miPuerto = netplayPlays[numero].port ?? ""
        }
        let miSesion = netplayPlays[numero].mitm_Session!
        
        if netplayPlays[numero].mitm_Ip != "" {
            miIp = netplayPlays[numero].mitm_Ip ?? ""
            miRelay = true
        }else {
            miIp = netplayPlays[numero].ip ?? ""
            miRelay = false
        }
        
        // MARK: Empezamos a lanzar el juego
        let nombredelarchivo = mirom.replacingOccurrences(of: rutaApp , with: "")
        if micomando.contains("RetroArch") {
            gameShader(shader: "")
            noGameOverlay()
            let defaults = UserDefaults.standard
            let shaders = defaults.integer(forKey: "Shaders")
            if shaders == 1 {
                let juegoABuscar = miJuego
                let miShader = checkShaders(juego: juegoABuscar)
                gameShader(shader: miShader)
            }
            let marcos = defaults.integer(forKey: "Marcos")
            
            if marcos == 1 {
                print(miJuego)
                if checkBezels(juego: miJuego) == true {
                    gameOverlay(game: nombredelarchivo)
                }
            }
        }
        
        if micomando.contains("citra-qt") {
            let mifilaconfig1 = citraConfig.firstIndex(where: {$0.contains("fullscreen=")})
            if mifilaconfig1 != nil {
                citraConfig[mifilaconfig1!] = "fullscreen=true"
            }
            let mifilaconfig2 = citraConfig.firstIndex(where: {$0.contains("fullscreen\\default=")})
            if mifilaconfig2 != nil {
                citraConfig[mifilaconfig2!] = "fullscreen\\default=false"
            }
            
            writeCitraConfig()
        }
        
        if miRelay == true {
            let parametros = "-C \"\(miIp)|\(miPuerto)|\(miSesion)\" -L"
            micomando = micomando.replacingOccurrences(of: "%ROM%", with: mirom).replacingOccurrences(of: "%CORE%", with: rutaRetroMac).replacingOccurrences(of: "-L", with: parametros)
            var launchCommand = rutaRetroMac + micomando
            print("COMANDO: \(launchCommand)")
            Commands.Bash.system("\(launchCommand)")
            launchCommand = ""
        }
        if miRelay == false {
            let parametros = "-C \(miIp)|\(miPuerto) -L"
            micomando = micomando.replacingOccurrences(of: "%ROM%", with: mirom).replacingOccurrences(of: "%CORE%", with: rutaRetroMac).replacingOccurrences(of: "-L", with: parametros)
            var launchCommand = rutaRetroMac + micomando
            print("COMANDO: \(launchCommand)")
            Commands.Bash.system("\(launchCommand)")
            launchCommand = ""
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
            if miShader == "NINGUNO" {
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
            if siONoGameBezel == "SI" {
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
