//
//  AppDelegate.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 01/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    
    @IBAction func abrirAyuda(_ sender: Any) {
        print("PDF")
        let ficheroAyuda = Bundle.main.url(forResource: "Ayuda", withExtension: "pdf")
        NSWorkspace.shared.openFile(ficheroAyuda!.path)
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        for runningApplication in NSWorkspace.shared.runningApplications {
            let appName = runningApplication.localizedName
            if appName == "Terminal" {
                runningApplication.terminate()
            }
        }
    }
    
    
}

