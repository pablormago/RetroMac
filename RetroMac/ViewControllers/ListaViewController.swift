//
//  ListaViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 07/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Cocoa

class ListaViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        
        // *** FullScreen ***
        let presOptions: NSApplication.PresentationOptions = ([.fullScreen, .autoHideMenuBar])
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions : NSNumber ( value: presOptions.rawValue)]
        
        self.view.enterFullScreenMode(NSScreen.main!)
        self.view.wantsLayer=true
        
        // *** /FullScreen ***
        
    }
    
    
}
