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
        // Mandos vía SDL2, como añadido al GameController nativo (ver
        // SDLControllerManager.swift). Se arranca aquí y no en el viewDidLoad de
        // ViewController porque allí dependía de un contador (`cuentaCargaGame == 1`)
        // que no siempre se cumple — aquí es un único punto garantizado al arrancar.
        SDLControllerManager.shared.iniciar()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // La Terminal que abren los emuladores se cierra al salir de cada juego
        // (ver lanzarJuegoYcerrarTerminal en ViewController.swift), no aquí.
    }
}

