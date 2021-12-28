//
//  SplashViewController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 27/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Cocoa

class SplashViewController: NSViewController {

    @IBOutlet weak var myProgress: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myProgress.minValue = 0
        myProgress.maxValue = 100
        
        //Your function here
        
        
        
        // Do view setup here.
    }
    override func viewDidAppear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                self.view.window?.contentViewController = controller
                abiertaLista = false
                ventana = "Principal"

            }
        }
        
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.isOpaque = false
        view.window?.backgroundColor = NSColor (red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
    }
    
}





///FIN DE LA CLASS
