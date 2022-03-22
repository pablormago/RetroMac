//
//  listScreenKeyboard.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 2/3/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Cocoa
import Commands
import AVKit
import AVFoundation
import GameController

extension ListaViewController {
    
    override func keyDown(with event: NSEvent) {
        
        if keyIsDown == true {
            return
        }
        keyIsDown = true
        
        
        
        
        
        if event.keyCode == 36  && abiertaLista == true && ventana == "Lista" {
            if cuentaClicks > 0 {
                onItemClicked()
            }
            
            
            
        }
        else if event.keyCode == 51 && abiertaLista == true {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                if playingVideo == true {
                    SingletonState.shared.mySnapPlayer?.player?.pause()
                }
               
                SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
                snapPlayer.player?.pause()
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
                
            }
            print("Backspace")
        }else if event.keyCode == 53 && abiertaLista == true {
            
            // MARK: Abrir Opciones
            //popButton.performClick(nil)
            
            
        }else if event.keyCode == 49 && abiertaLista == true {
            
        }
        
        if event.keyCode == 124 && abiertaLista == true {
            if botonactual < cuantosSistemas {
                print("Derecha")
                if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                    //self.view.window?.contentViewController = controller
                    abiertaLista = true
                    ventana = "Principal"
                    cuentaboton = botonactual
                    botonactual += 1
                    juegosXml = []
                    contextMenu.items.removeAll()
                    let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
                    nombresistemaactual = button!.Sistema ?? ""
                    //print(sistemaActual)
                    
                    controller.selecionSistema(button!)
                    
                    self.viewDidLoad()
                    self.viewDidAppear()
                    juegosTableView.reloadData()
                    if juegosXml.count > 0 {
                        let indexSet = NSIndexSet(index: 0)
                        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
                    }
                    
                }
            }
            
            
        }
        if event.keyCode == 123 && abiertaLista == true {
            if botonactual > 1 {
                print("Izquierda")
                if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                    //self.view.window?.contentViewController = controller
                    abiertaLista = true
                    ventana = "Principal"
                    cuentaboton = botonactual
                    botonactual -= 1
                    juegosXml = []
                    contextMenu.items.removeAll()
                    let button = controller.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
                    nombresistemaactual = button!.Sistema ?? ""
                    //print(sistemaActual)
                    
                    controller.selecionSistema(button!)
                    
                    self.viewDidLoad()
                    self.viewDidAppear()
                    juegosTableView.reloadData()
                    if juegosXml.count > 0 {
                        let indexSet = NSIndexSet(index: 0)
                        juegosTableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
                    }
                }
            }
            
        }
        
        
        
    }
    
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
}
