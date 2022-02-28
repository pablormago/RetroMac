//
//  mainScreenKeyboard.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 11/2/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import Cocoa

extension ViewController {
    
    override func keyDown(with event: NSEvent) {
        if keyIsDown == true {
            return
        }
        
        if abiertaLista == false {
            
            if event.keyCode == 53 && ventana == "Principal" {
                lazy var sheetViewController: NSViewController = {
                    return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
                    as! NSViewController
                }()
                SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
                
            }
            
            if event.keyCode == 36  {
                
                if ventana == "Principal" {
                    print("ENTER LISTA FALSE")
                    backStop()
                    let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    sistemaActual = button?.Fullname! ?? ""
                    //print(sistemaActual)
                    if Int(button!.numeroJuegos!)! > 0 {
                        selecionSistema(button!)
                    }
                    
                }
                
                
            }
            else if event.keyCode == 124  {
                if botonactual < cuantosSistemas {
                    botonactual += 1
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        
                        cuentaboton = botonactual
                        let trozoamover = (560 * botonactual) - 280
                        let cachito = trozoamover - mitadPantalla
                        //print(botonactual)
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        scrollMain.isHidden = false
                        print ("CUENTABOTON: \(cuentaboton)")
                        print ("BOTONACTUAL: \(botonactual)")
                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        backplay (tag: botonactual)
                    }
                }
            }
            else if event.keyCode == 123 {
                //print ("CURSOR IZQUIERDO")
                
                if botonactual > 1 {
                    botonactual -= 1
                    
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        let width = rect.size.width
                        let mitadPantalla = Int (width / 2)
                        anchuraPantall = Int(width)
                        cuentaboton = botonactual
                        let trozoamover = (560 * botonactual) - 280
                        let cachito = trozoamover - mitadPantalla
                        //print(botonactual)
                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                        scrollMain.isHidden = false
                        print ("CUENTABOTON: \(cuentaboton)")
                        print ("BOTONACTUAL: \(botonactual)")
                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        backplay (tag: botonactual)
                    }
                    
                }
                
            }
            
        }
        else if abiertaLista == true {
            
            if event.keyCode == 53 && ventana == "Principal" {
                lazy var sheetViewController: NSViewController = {
                    return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
                    as! NSViewController
                }()
                SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
                
            }
            
            if event.keyCode == 36  {
                if ventana == "Principal" {
                    print("ENTER")
                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                    backStop()
                    sistemaActual = button?.Fullname! ?? ""
                    //print(sistemaActual)
                    if Int(button!.numeroJuegos!)! > 0 {
                        selecionSistema(button!)
                    }
                    
                }
                
                
                
            }
            else if event.keyCode == 124  {
                //print ("CURSOR DERECHO")
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
                        //                            let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                        //                            sistemaLabel.stringValue = button!.numeroJuegos! + " juegos"
                        let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
                        sistemaLabel.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                        backplay (tag: Int(cuentaDec))
                        
                        
                    }
                }
                
                
            }
            else if event.keyCode == 123 {
                //print ("CURSOR IZQUIERDO")
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
            
        }
        
    }
    override func keyUp(with event: NSEvent) {
        keyIsDown = false
    }
    
    
    
}
