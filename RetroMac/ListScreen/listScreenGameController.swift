//
//  listScreenGameController.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 13/2/22.
//  Copyright © 2022 pmg. All rights reserved.
//


import Foundation
import Cocoa
import GameController

extension ListaViewController {
 
        // MARK: GamePad
        
        func startWatchingForControllers() {
            // Subscribe for the notes
            let ctr = NotificationCenter.default
            ctr.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) {[weak self] note in
                if let ctrl = note.object as? GCController {
                    self!.add2(ctrl)
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
        
        func add2(_ controller: GCController) {
            let name = String(describing:controller.vendorName)
            if let extendedGamepad = controller.extendedGamepad {
                print("connect extended \(name) in Lista")
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
        private func configureDPadButtons(_ gamepad : GCExtendedGamepad) {
            
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
                    
                }
            }
            
            //Configuracão do direcional para a direita
            gamepad.dpad.right.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Right")
                if pressed == true {
                    
                }
            }
            
        }
        
        /*
             Método para configurar os botões A,B,X e Y do(s) controle(s) do tipo GCExtendedGamepad.
                - Parameters:
                    - gamepad: Gamepad para configuração dos botões.
             */
            private func configureDiamondButtons(_ gamepad: GCExtendedGamepad) {
                
                //Configuração do botão A
                gamepad.buttonA.pressedChangedHandler = {(button, value, pressed) in
                    print( "ExtendedGamepad - A - Lista")
                    if pressed == true {
                        if ventana == "Lista" {
                            self.onItemClicked()
                        }
                    }else {
                        
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
                    print("ExtendedGamepad - Y")
                    if pressed == true {
                        self.backFunc(NSButton())
                    }
                    
                }
                
            }
            
        private func configureShoulderButtons(_ gamepad: GCExtendedGamepad) {
                
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
            private func configureTriggers(_ gamepad: GCExtendedGamepad) {
                
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
        
        
        
        
    

}
