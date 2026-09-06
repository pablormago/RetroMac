//
//  ConfigViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 30/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Cocoa

class ConfigViewController: NSViewController {
    
    @IBOutlet weak var userTXT: NSTextField!
    @IBOutlet weak var passwordTxt: NSTextField!
    @IBOutlet weak var guardarBtn: NSButton!
    @IBOutlet weak var salirBtn: NSButton!
    @IBOutlet weak var shadersSwitch: NSSwitch!
    @IBOutlet weak var marcosSwitch: NSSwitch!
    @IBOutlet weak var localSwitch: NSSwitch!
    @IBOutlet weak var listaPantalla: NSPopUpButton!
    
    @IBOutlet weak var serverList: NSPopUpButton!
    @IBOutlet weak var configTxt: NSTextField!
    /// Cambia la carpeta donde están las ROMs (ver rutaRoms() en funciones.swift).
    /// Permite tener RetroMac en /Applications y los juegos en otro disco, o apuntar a
    /// una BoB que no esté junto a la app. Al cambiarla hay que reiniciar: la lista de
    /// sistemas y sus juegos se construyen al arrancar.
    @IBAction func elegirCarpetaRoms(_ sender: Any) {
        // Un solo botón en el storyboard para las dos carpetas: la de juegos (del
        // usuario) y la de emuladores (que gestiona la app). Van por separado a
        // propósito — ver rutaRoms()/rutaDatos() en funciones.swift.
        let menu = NSAlert()
        menu.messageText = "Carpetas de RetroMac"
        menu.informativeText = """
            Juegos:      \(rutaRoms())/roms
            Emuladores:  \(rutaDatos())/Emuladores_Mac
            """
        menu.addButton(withTitle: "Cambiar carpeta de juegos…")
        menu.addButton(withTitle: "Cambiar carpeta de emuladores…")
        menu.addButton(withTitle: "Cancelar")
        switch menu.runModal() {
        case .alertFirstButtonReturn: cambiarCarpetaDeJuegos()
        case .alertSecondButtonReturn:
            if elegirCarpetaDeDatos() { avisarDeReinicio(carpeta: rutaDatos()) }
        default: return
        }
    }

    private func cambiarCarpetaDeJuegos() {
        let actual = rutaRoms()
        let alerta = NSAlert()
        alerta.messageText = "Carpeta de juegos"
        alerta.informativeText = "Ahora mismo RetroMac busca las ROMs en:\n\(actual)/roms"
        alerta.addButton(withTitle: "Elegir otra…")
        alerta.addButton(withTitle: "Crear estructura nueva…")
        alerta.addButton(withTitle: "Cancelar")

        switch alerta.runModal() {
        case .alertFirstButtonReturn:
            guard let elegida = pedirCarpetaAlUsuario(titulo: "Elige la carpeta que contiene tu carpeta «roms»") else { return }
            UserDefaults.standard.set(elegida, forKey: claveCarpetaRoms)
            avisarDeReinicio(carpeta: elegida)

        case .alertSecondButtonReturn:
            guard let destino = pedirCarpetaAlUsuario(titulo: "Elige dónde crear la estructura de carpetas") else { return }
            let creadas = crearEstructuraDeRoms(en: destino)
            UserDefaults.standard.set(destino, forKey: claveCarpetaRoms)
            let aviso = NSAlert()
            aviso.messageText = "Estructura creada"
            aviso.informativeText = "Se han creado \(creadas) carpetas de sistema en:\n\(destino)/roms"
            aviso.runModal()
            avisarDeReinicio(carpeta: destino)

        default:
            return
        }
    }

    private func avisarDeReinicio(carpeta: String) {
        let aviso = NSAlert()
        aviso.messageText = "Carpeta guardada"
        aviso.informativeText = "RetroMac usará:\n\(carpeta)/roms\n\nCierra y vuelve a abrir la aplicación para que se cargue."
        aviso.runModal()
    }

    @IBAction func guardar(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(userTXT.stringValue, forKey: "SSUser")
        defaults.set(passwordTxt.stringValue, forKey: "SSPassword")
        
        var estadoLocal = 0
        var estadoMarcos = 0
        var estadoShaders = 0
        
        if localSwitch.state.rawValue == 1 {
            estadoLocal = 1
        }else {
            estadoLocal = 0
        }
        
        if marcosSwitch.state.rawValue == 1 {
            estadoMarcos = 1
            editRetroArchConfig(param: "input_overlay", value: "~/Documents/RetroMac/custom_overlay.cfg")
            editRetroArchConfig(param: "input_overlay_aspect_adjust_landscape", value: "0.130000")
            editRetroArchConfig(param: "input_overlay_opacity", value: "1.000000")
        }else {
            estadoMarcos = 0
            editRetroArchConfig(param: "input_overlay", value: "")
        }
        
        if shadersSwitch.state.rawValue == 1 {
            estadoShaders = 1
            //video_shader_enable = "true"
            editRetroArchConfig(param: "video_shader_enable", value: "true")
        }else {
            estadoShaders = 0
            editRetroArchConfig(param: "video_shader_enable", value: "false")
        }
        let estadoPantalla = listaPantalla.selectedItem!.title
        defaults.set(estadoPantalla, forKey: "PantallaJuegos")
        pantallaJuegos = estadoPantalla
        defaults.set(estadoLocal, forKey: "LocalMedia")
        defaults.set(estadoMarcos, forKey: "Marcos")
        defaults.set(estadoShaders, forKey: "Shaders")
        
        editRetroArchConfig(param: "netplay_nickname", value: configTxt.stringValue)
        editRetroArchConfig(param: "netplay_mitm_server", value: serverList.selectedItem!.title)
        defaults.set(serverList.selectedItem!.title, forKey: "RelayServer")
        writeRetroArchConfig()
        ventanaModal = "Ninguna"
        self.dismiss(self)
        
    }
    
    @IBAction func salir(_ sender: Any) {
        
        //print((self.view.window?.attachedSheet)
        //self.view.window?.endSheet(((self.view.window?.attachedSheet)!))
        ventanaModal = "Ninguna"
        self.dismiss(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ventanaModal = "Config"
        let defaults = UserDefaults.standard
        userTXT.stringValue = defaults.string(forKey: "SSUser") ?? ""
        passwordTxt.stringValue = defaults.string(forKey: "SSPassword") ?? ""
        
        let switchestado = defaults.integer(forKey: "LocalMedia")
        
        if switchestado == 1 {
            localSwitch.state = NSControl.StateValue.on
        }else {
            localSwitch.state = NSControl.StateValue.off
        }
        let marcos = defaults.integer(forKey: "Marcos") ?? 0
        
        if marcos == 1 {
            marcosSwitch.state = NSControl.StateValue.on
        }else {
            marcosSwitch.state = NSControl.StateValue.off
        }
        let shaders = defaults.integer(forKey: "Shaders") ?? 0
        
        if shaders == 1 {
            shadersSwitch.state = NSControl.StateValue.on
        }else {
            shadersSwitch.state = NSControl.StateValue.off
        }
        var nickName = String()
        let filaNick = retroArchConfig.firstIndex(where: {$0[0] == "netplay_nickname"})
        if filaNick != nil {
            nickName = retroArchConfig[filaNick!][1]
        } else {
            nickName = "RetroMac"
        }
        
        let relayServer = defaults.string(forKey: "RelayServer") ?? ""
        
        configTxt.stringValue = nickName
        if relayServer == "madrid" {
            serverList.selectItem(at: 0)
        }
        if relayServer == "nyc" {
            serverList.selectItem(at: 1)
        }
        if relayServer == "saopaulo" {
            serverList.selectItem(at: 2)
        }
        if relayServer == "singapore" {
            serverList.selectItem(at: 3)
        }
        
        let pantallaJuegos = defaults.string(forKey: "PantallaJuegos") ?? "Lista"
        if pantallaJuegos == "Lista" {
            listaPantalla.selectItem(at: 0)
        }
        if pantallaJuegos == "Cuadrícula" {
            listaPantalla.selectItem(at: 1)
        }
        
        // Do view setup here.
        //SingletonState.shared.currentViewController = self
    }
    
    func editRetroArchConfig (param: String, value: String ) {
        
        let mifila = retroArchConfig.firstIndex(where: {$0[0] == param})
        retroArchConfig[mifila!][1] = value
        
    }
    
}
