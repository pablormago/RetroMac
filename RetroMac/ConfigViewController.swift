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
    
    @IBAction func guardar(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(userTXT.stringValue, forKey: "SSUser")
        defaults.set(passwordTxt.stringValue, forKey: "SSPassword")
        self.dismiss(self)
    }
    
    @IBAction func salir(_ sender: Any) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        userTXT.stringValue = defaults.string(forKey: "SSUser") ?? ""
        passwordTxt.stringValue = defaults.string(forKey: "SSPassword") ?? ""
        // Do view setup here.
    }
    
}
