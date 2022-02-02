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
    
    @IBOutlet weak var localSwitch: NSSwitch!
    @IBAction func guardar(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(userTXT.stringValue, forKey: "SSUser")
        defaults.set(passwordTxt.stringValue, forKey: "SSPassword")
        var estadoLocal = 0
        if localSwitch.state.rawValue == 1 {
            estadoLocal = 1
        }else {
            estadoLocal = 0
        }
        defaults.set(estadoLocal, forKey: "LocalMedia")
        
        self.dismiss(self)
    }
    
    @IBAction func salir(_ sender: Any) {
        
        self.dismiss(self)
       
        //print((self.view.window?.attachedSheet)
        //self.view.window?.endSheet(((self.view.window?.attachedSheet)!))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        userTXT.stringValue = defaults.string(forKey: "SSUser") ?? ""
        passwordTxt.stringValue = defaults.string(forKey: "SSPassword") ?? ""
        var switchestado = defaults.integer(forKey: "LocalMedia") ?? 0
        if switchestado == 1 {
            localSwitch.state = NSControl.StateValue.on
        }else {
            localSwitch.state = NSControl.StateValue.off
        }
        // Do view setup here.
    }
    
}
