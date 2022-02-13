//
//  mainScreenGameController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 11/2/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import Cocoa
import GameController

extension ViewController {
 
        // MARK: GamePad
        
        func startWatchingForControllers() {
            // Subscribe for the notes
            let ctr = NotificationCenter.default
            ctr.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) {[weak self] note in
                if let ctrl = note.object as? GCController {
                    self!.add(ctrl)
                }
            }
            ctr.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) {[weak self] note in
                if let ctrl = note.object as? GCController {
                    self!.remove(ctrl)
                }
            }
            // and kick off discovery
            GCController.startWirelessControllerDiscovery(completionHandler: {})
        }
        
        func stopWatchingForControllers() {
            // Same as the first, 'cept in reverse!
            GCController.stopWirelessControllerDiscovery()
            
            let ctr = NotificationCenter.default
            ctr.removeObserver(self, name: .GCControllerDidConnect, object: nil)
            ctr.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        }
        
        func add(_ controller: GCController) {
            let name = String(describing:controller.vendorName)
            if let extendedGamepad = controller.extendedGamepad {
                print("connect extended \(name)")
                configureDPadButtons(extendedGamepad)
                configureDiamondButtons(extendedGamepad)
                configureShoulderButtons(extendedGamepad)
                configureTriggers(extendedGamepad)
                return
            } else if let gamepad = controller.microGamepad {
                print("connect micro (name)")
            } else {
                print("Huh? (name)")
            }
        }
        public func configureDPadButtons(_ gamepad : GCExtendedGamepad) {
            
            //Configuracão do direcional para cima
            gamepad.dpad.up.pressedChangedHandler = {(button, value, pressed) in
                if pressed == true {
                    print("ExtendedGamepad - Up")
                }
                
            }
            
            //Configuracão do direcional para baixo
            gamepad.dpad.down.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Down")
                
             }
            
            //Configuracão do direcional para a esquerda
            gamepad.dpad.left.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Left")
                if pressed == true {
                    if cuentaPrincipio == 0 {
                        self.menosSistema()
                    }else {
                        self.menosSistemaLista()
                    }
                 }
            }
            
            //Configuracão do direcional para a direita
            gamepad.dpad.right.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Right")
                if pressed == true {
                    if cuentaPrincipio == 0 {
                        self.masSistema()
                    }else {
                        self.masSistemaLista()
                    }
                }
            }
            
        }
        
        /*
             Método para configurar os botões A,B,X e Y do(s) controle(s) do tipo GCExtendedGamepad.
                - Parameters:
                    - gamepad: Gamepad para configuração dos botões.
             */
            public func configureDiamondButtons(_ gamepad: GCExtendedGamepad) {
                
                //Configuração do botão A
                gamepad.buttonA.pressedChangedHandler = {(button, value, pressed) in
                    print( "ExtendedGamepad - A")
                    if cuentaPrincipio  > 0 && ventana == "Principal" {
                        print("ENTER LISTA TRUE")
                        let button = self.view.viewWithTag(Int(self.cuentaDec)) as? ButtonConsolas
                        sistemaActual = button?.Fullname! ?? ""
                        //print(sistemaActual)
                        if Int(button!.numeroJuegos!)! > 0 {
                            self.selecionSistema(button!)
                        }
                        
                    } else {
                        if ventana == "Principal" {
                            print("ENTER LISTA FALSE")
                            let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                            sistemaActual = button?.Fullname! ?? ""
                            if Int(button!.numeroJuegos!)! > 0 {
                                self.selecionSistema(button!)
                            }
                        }
                    }
                }
                
                //Configuração do botão B
                gamepad.buttonB.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - B")
                }
                
                //Configuração do botão X
                gamepad.buttonX.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - X")
                }
                
                //Configuração do botão Y
                gamepad.buttonY.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - y")
                }
                
            }
            
        public func configureShoulderButtons(_ gamepad: GCExtendedGamepad) {
                
                //Configuracão do L1
                gamepad.leftShoulder.pressedChangedHandler = {(button, value, pressed) in
                    print( "ExtendedGamepad - Left Shoulder")
                }
                
                //Configuracão do R1
                gamepad.rightShoulder.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - Right Shoulder")
                }
                
            }
            
            /**
             Método para configurar os botões de trigger(L2 e R2) do(s) controle(s) do tipo GCExtendedGamepad.
                - Parameters:
                    - gamepad: Gamepad para configuração dos botões.
             */
            public func configureTriggers(_ gamepad: GCExtendedGamepad) {
                
                //Configuracão do L2
                gamepad.leftTrigger.pressedChangedHandler = {(button, value, pressed) in
                    print( "ExtendedGamepad - Left Trigger")
                }
                
                //Configuracão do R2
                gamepad.rightTrigger.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - Right Trigger")
                }
                
            }
        
        func remove(_ controller: GCController) {
            
        }
        public func masSistema() {
            if Int(cuentaDec) < cuantosSistemas {
                cuentaDec += 1
                //print(cuentaDec)
                if let screen = NSScreen.main {
                    let rect = screen.frame
                    let width = rect.size.width
                    let mitadPantalla = Int (width / 2)
                    anchuraPantall = Int(width)
                    
                    
                    //print("entro")
                    cuentaboton = botonactual
                    let trozoamover = (560 * Int(cuentaDec)) - 280
                    let cachito = trozoamover - mitadPantalla
                    scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    backplay (tag: Int(cuentaDec))
                    
                    
                }
            }
        }
        
        public func menosSistema(){
            if cuentaDec > 1 {
                cuentaDec -= 1
                //print(cuentaDec)
                if let screen = NSScreen.main {
                    let rect = screen.frame
                    let width = rect.size.width
                    let mitadPantalla = Int (width / 2)
                    anchuraPantall = Int(width)
                    
                    
                    //print("entro")
                    cuentaboton = botonactual
                    let trozoamover = (560 * Int(cuentaDec)) - 280
                    let cachito = trozoamover - mitadPantalla
                    scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                    
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    
                    backplay (tag: Int(cuentaDec))
                    
                }
            }
        }
        
        public func masSistemaLista() {
            if Int(cuentaDec) < cuantosSistemas {
                cuentaDec += 1
                if let screen = NSScreen.main {
                    let rect = screen.frame
                    let width = rect.size.width
                    let mitadPantalla = Int (width / 2)
                    anchuraPantall = Int(width)
                    cuentaboton = botonactual
                    let trozoamover = (560 * Int(cuentaDec)) - 280
                    let cachito = trozoamover - mitadPantalla
                    SingletonState.shared.myscroller!.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    backplay (tag: Int(cuentaDec))
                    
                    
                }
            }
        }
        
        public func menosSistemaLista() {
            if cuentaDec > 1 {
                cuentaDec -= 1
                if let screen = NSScreen.main {
                    let rect = screen.frame
                    let width = rect.size.width
                    let mitadPantalla = Int (width / 2)
                    anchuraPantall = Int(width)
                    cuentaboton = botonactual
                    let trozoamover = (560 * Int(cuentaDec)) - 280
                    let cachito = trozoamover - mitadPantalla
                    SingletonState.shared.myscroller!.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    backplay (tag: Int(cuentaDec))
                }
            }
        }
        
        
        
    

}
