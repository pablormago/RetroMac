//
//  OptionsViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 3/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa

var miJuegosXml = [[String]]()
class OptionsViewController: NSViewController {
    
    @IBOutlet weak var guardarBtn: NSButton!
    @IBOutlet weak var scrapSystemBtn: NSButton!
    @IBOutlet weak var systemCoreList: NSPopUpButton!
    @IBOutlet weak var systemShaderList: NSPopUpButton!
    @IBOutlet weak var systemBezelsList: NSPopUpButton!
    @IBOutlet weak var scrapGameBtn: NSButton!
    @IBOutlet weak var changeGameNameBtn: NSButton!
    @IBOutlet weak var favGameBtn: NSButton!
    @IBOutlet weak var delGameBtn: NSButton!
    @IBOutlet weak var gameCoreList: NSPopUpButton!
    @IBOutlet weak var gameShaderList: NSPopUpButton!
    @IBOutlet weak var gameBezelsList: NSPopUpButton!
    @IBOutlet weak var netplayBtn: NSButton!
    @IBOutlet weak var aceptarBTN: NSButton!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var barraProgress: NSProgressIndicator!
    @IBOutlet weak var opcionesSistemaLabel: NSTextField!
    @IBOutlet weak var opcionesJuegoLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OPTIONS LOAD")
        // Do view setup here.
        
        //Cogemos el JuegosXml
        miJuegosXml = juegosXml
        ventanaModal = "Opciones"
        // MARK: Añadimos acciones a los botones
        
        scrapSystemBtn.action = #selector(escrapearSistema)
        scrapGameBtn.action = #selector(buscaJuegoGrid)
        aceptarBTN.action = #selector(cerrar)
        favGameBtn.action = #selector(favoritos)
        delGameBtn.action = #selector(alertaBorrar)
        guardarBtn.action = #selector(guardar)
        changeGameNameBtn.action = #selector(alertaTitulo)
        netplayBtn.action = #selector(netplayHost)
        
        // MARK: LLenar Listas:
        getSystemCores()
        getSystemShaders()
        getGameCore()
        getGameShaders()
        getSystemBezels()
        getGameBezels()
        getFav()
        getSystemAndGame()
    }
    
    @objc func netplayHost() {
        lanzarNetPlay()
    }
    
    @objc func escrapearSistema () {
        escrapeartodos()
    }
    
    
    
    @objc func cerrar() {
        
        ventana = "Grid"
        myPlayer.player?.play()
        ventanaModal = "Ninguna"
        self.dismiss(self)
        listado.becomeFirstResponder()
    }
    
    @objc func guardar(){
        saveOptions()
        ventana = "Grid"
        myPlayer.player?.play()
        ventanaModal = "Ninguna"
        self.dismiss(self)
        listado.becomeFirstResponder()
    }
}
