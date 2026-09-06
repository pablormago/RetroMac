//
//  mainScreenKeyboard.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 11/2/22.
//  Copyright © 2022 pmg. All rights reserved.
//

import Foundation
import Cocoa
import GameController
import Commands
import AVKit
import AVFoundation
var cuentaclicks = 0

extension ViewController {

    // OJO antes de tocar nada aquí: que el keyDown de abajo esté comentado NO
    // significa que esta pantalla ignore el teclado. Los cursores, INTRO, F1 y F5
    // funcionan a través de los keyEquivalent de los botones del storyboard
    // (enterSystem:, menosMenu:, masMenu:, openSettings:, openNetplay:), que AppKit
    // resuelve por performKeyEquivalent antes de llegar a ningún keyDown.
    //
    // Por eso esta versión SOLO se queda con la H de la leyenda y con la tecla que
    // la cierra si está abierta, y todo lo demás se lo pasa a super.
    override func keyDown(with event: NSEvent) {
        if keyIsDown == true {
            return
        }
        keyIsDown = true

        if event.keyCode == 4 {
            LeyendaControles.alternar()
            return
        }
        if LeyendaControles.estaVisible {
            LeyendaControles.ocultar()
            return
        }
        super.keyDown(with: event)
    }

    override func keyUp(with event: NSEvent) {
        keyIsDown = false
        super.keyUp(with: event)
    }

//    override func keyDown(with event: NSEvent) {
//        if keyIsDown == true {
//            return
//        }
//        if abiertaLista == false {
//
//            if event.keyCode == 53 && ventana == "Principal" {
//                lazy var sheetViewController: NSViewController = {
//                    return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
//                    as! NSViewController
//                }()
//                SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
//
//            }
//
//            if event.keyCode == 36  {
//
//                if ventana == "Principal" {
//                    print("ENTER LISTA FALSE")
//                    backStop()
//                    let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
//                    sistemaActual = button?.Fullname! ?? ""
//                    //print(sistemaActual)
//                    if Int(button!.numeroJuegos!)! > 0 {
//                        selecionSistema(button!)
//                    }
//
//
//
//                }
//
//
//            }
//            else if event.keyCode == 124  {
//                if botonactual < cuantosSistemas {
//                    botonactual += 1
//                    if let screen = NSScreen.main {
//                        let rect = screen.frame
//                        let width = rect.size.width
//                        let mitadPantalla = Int (width / 2)
//                        anchuraPantall = Int(width)
//
//                        cuentaboton = botonactual
//                        let trozoamover = (560 * botonactual) - 280
//                        let cachito = trozoamover - mitadPantalla
//                        //print(botonactual)
//                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
//                        scrollMain.isHidden = false
//                        print ("CUENTABOTON: \(cuentaboton)")
//                        print ("BOTONACTUAL: \(botonactual)")
//                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
//                        sistemaLabel.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
//                        backplay (tag: botonactual)
//                    }
//                }
//            }
//            else if event.keyCode == 123 {
//                //print ("CURSOR IZQUIERDO")
//
//                if botonactual > 1 {
//                    botonactual -= 1
//
//                    if let screen = NSScreen.main {
//                        let rect = screen.frame
//                        let width = rect.size.width
//                        let mitadPantalla = Int (width / 2)
//                        anchuraPantall = Int(width)
//                        cuentaboton = botonactual
//                        let trozoamover = (560 * botonactual) - 280
//                        let cachito = trozoamover - mitadPantalla
//                        //print(botonactual)
//                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
//                        scrollMain.isHidden = false
//                        print ("CUENTABOTON: \(cuentaboton)")
//                        print ("BOTONACTUAL: \(botonactual)")
//                        let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
//                        sistemaLabel.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
//                        backplay (tag: botonactual)
//                    }
//
//                }
//
//            }
//
//        }
//        else if abiertaLista == true {
//
//            if event.keyCode == 53 && ventana == "Principal" {
//                lazy var sheetViewController: NSViewController = {
//                    return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
//                    as! NSViewController
//                }()
//                SingletonState.shared.currentViewController?.presentAsSheet(sheetViewController)
//
//            }
//
//            if event.keyCode == 36  {
//                if ventana == "Principal" {
//                    print("ENTER")
//                    let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
//                    backStop()
//                    sistemaActual = button?.Fullname! ?? ""
//                    //print(sistemaActual)
//                    if Int(button!.numeroJuegos!)! > 0 {
//                        selecionSistema(button!)
//                    }
//
//                }
//
//
//
//            }
//            else if event.keyCode == 124  {
//                //print ("CURSOR DERECHO")
//                if Int(cuentaDec) < cuantosSistemas {
//                    cuentaDec += 1
//                    //print(cuentaDec)
//                    if let screen = NSScreen.main {
//                        let rect = screen.frame
//                        let width = rect.size.width
//                        let mitadPantalla = Int (width / 2)
//                        anchuraPantall = Int(width)
//
//
//                        //print("entro")
//                        cuentaboton = botonactual
//                        let trozoamover = (560 * Int(cuentaDec)) - 280
//                        let cachito = trozoamover - mitadPantalla
//                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
//                        //                            let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
//                        //                            sistemaLabel.stringValue = button!.numeroJuegos! + " juegos"
//                        let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
//                        sistemaLabel.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
//                        backplay (tag: Int(cuentaDec))
//
//
//                    }
//                }
//
//
//            }
//            else if event.keyCode == 123 {
//                //print ("CURSOR IZQUIERDO")
//                if cuentaDec > 1 {
//                    cuentaDec -= 1
//                    //print(cuentaDec)
//                    if let screen = NSScreen.main {
//                        let rect = screen.frame
//                        let width = rect.size.width
//                        let mitadPantalla = Int (width / 2)
//                        anchuraPantall = Int(width)
//
//
//                        //print("entro")
//                        cuentaboton = botonactual
//                        let trozoamover = (560 * Int(cuentaDec)) - 280
//                        let cachito = trozoamover - mitadPantalla
//                        scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
//
//                        let button = self.view.viewWithTag(Int(cuentaDec)) as? ButtonConsolas
//                        sistemaLabel.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
//
//                        backplay (tag: Int(cuentaDec))
//
//                    }
//                }
//
//
//            }
//
//        }
//
//        keyIsDown = true
//
//    }
//    override func keyUp(with event: NSEvent) {
//        keyIsDown = false
//    }
    
    func masSistemaKeys () {
        cuentaclicks += 1
        if cuentaclicks == 2 {
            cuentaclicks = 0
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
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
                    
                    backplay (tag: botonactual)
                }
            }
        }
        
    }
    
    func masSistemaListaKeys (){
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
                SingletonState.shared.mySystemLabel?.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
                backplay (tag: Int(cuentaDec))
                
                
            }
        }
    }
    
    func menosSistemaKeys(){
        cuentaclicks += 1
        print(cuentaclicks)
        if cuentaclicks == 2 {
            cuentaclicks = 0
            if botonactual > 1 {
                botonactual -= 1
                
                if let screen = NSScreen.main {
                    let rect = screen.frame
                    let width = rect.size.width
                    let mitadPantalla = Int (width / 2)
                    anchuraPantall = Int(width)
                    cuentaboton = botonactual
                    let trozoamover = (560 * (botonactual)) - 280
                    let cachito = trozoamover - mitadPantalla
                    //print(botonactual)
                    scrollMain.contentView.scroll(to: CGPoint(x: cachito, y: 0))
                    scrollMain.isHidden = false
                    print ("CUENTABOTON: \(cuentaboton)")
                    print ("BOTONACTUAL: \(botonactual)")
                    let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
                    
                    backplay (tag: botonactual)
                }
                
            }
        }
        
        
    }
    
    func menosSistemaListaKeys(){
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
                SingletonState.shared.mySystemLabel?.stringValue = "\(button?.Fullname ?? ""): \(button?.numeroJuegos ?? "0") Juegos"
                backplay (tag: Int(cuentaDec))
            }
        }
    }
    
}
