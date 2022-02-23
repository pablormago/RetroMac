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
            editRetroArchConfig(param: "input_overlay_opacity", value: "0.700000")
        }else {
            estadoMarcos = 0
            editRetroArchConfig(param: "input_overlay", value: "")
        }
        
        if shadersSwitch.state.rawValue == 1 {
            estadoShaders = 1
        }else {
            estadoShaders = 0
        }
        
        defaults.set(estadoLocal, forKey: "LocalMedia")
        defaults.set(estadoMarcos, forKey: "Marcos")
        defaults.set(estadoMarcos, forKey: "Shaders")
        
        writeRetroArchConfig()
        
        self.dismiss(self)
        
    }
    
    @IBAction func salir(_ sender: Any) {
        
        //print((self.view.window?.attachedSheet)
        //self.view.window?.endSheet(((self.view.window?.attachedSheet)!))
        self.dismiss(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        // Do view setup here.
        //SingletonState.shared.currentViewController = self
    }
    
    func editRetroArchConfig (param: String, value: String ) {
        
        let mifila = retroArchConfig.firstIndex(where: {$0[0] == param})
        retroArchConfig[mifila!][1] = value
    
    }
    
}
