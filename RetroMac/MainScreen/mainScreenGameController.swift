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
import Commands
import AVKit
import AVFoundation
extension ViewController {
 
        // MARK: GamePad
        
        func startWatchingForControllers() {
            // Subscribe for the notes
            let ctr = NotificationCenter.default
            ctr.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) {[weak self] note in
                if let ctrl = note.object as? GCController {
                    self?.add(ctrl)
                }
            }
            ctr.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) {[weak self] note in
                if let ctrl = note.object as? GCController {
                    self?.remove(ctrl)
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
                    
                    if ventana == "Lista" && ventanaModal == "Ninguna" {
                        self.prevGame ()
                    }
                    if ventana == "Grid"  && ventanaModal == "Ninguna" {
                        if columna >= 3 {
                            let indexPath1:IndexPath = IndexPath(item: columna , section: 0)
                            var set1 = Set<IndexPath>()
                            set1.insert(indexPath1)
                            myCollectionView.deselectItems(at: set1)
                            let indexPath:IndexPath = IndexPath(item: columna - 3, section: 0)
                            var set = Set<IndexPath>()
                            set.insert(indexPath)
                            myCollectionView.selectItems(at: set, scrollPosition: .centeredVertically)
                            columna = columna - 3
                            self.actualizaMediaGrid ()
                        }
                    }
                }
                
            }
            
            //Configuracão do direcional para baixo
            gamepad.dpad.down.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Down")
                if pressed == true {
                    if ventana == "Lista" && ventanaModal == "Ninguna"{
                        self.nextGame()
                    }
                    if ventana == "Grid"  && ventanaModal == "Ninguna" {
                        if columna <= juegosXml.count - 4 {
                            let indexPath1:IndexPath = IndexPath(item: columna , section: 0)
                            var set1 = Set<IndexPath>()
                            set1.insert(indexPath1)
                            myCollectionView.deselectItems(at: set1)
                            let indexPath:IndexPath = IndexPath(item: columna + 3, section: 0)
                            var set = Set<IndexPath>()
                            set.insert(indexPath)
                            myCollectionView.selectItems(at: set, scrollPosition: .centeredVertically)
                            columna = columna + 3
                            self.actualizaMediaGrid ()
                        }
                    }
                }
                
             }
            
            //Configuracão do direcional para a esquerda
            gamepad.dpad.left.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Left")
                if pressed == true {
                    if ventana == "Principal" && ventanaModal == "Ninguna" {
                        if cuentaPrincipio == 0 {
                            self.menosSistema()
                        }else {
                            self.menosSistemaLista()
                        }
                    }
                    if ventana == "Grid"  && ventanaModal == "Ninguna" {
                        if columna > 0 && juegosXml.count >= 1 {
                            let indexPath1:IndexPath = IndexPath(item: columna , section: 0)
                            var set1 = Set<IndexPath>()
                            set1.insert(indexPath1)
                            myCollectionView.deselectItems(at: set1)
                            let indexPath:IndexPath = IndexPath(item: columna - 1, section: 0)
                            var set = Set<IndexPath>()
                            set.insert(indexPath)
                            myCollectionView.selectItems(at: set, scrollPosition: .centeredVertically)
                            columna = columna - 1
                            self.actualizaMediaGrid ()
                        }
                    }
                    
                 }
            }
            
            //Configuracão do direcional para a direita
            gamepad.dpad.right.pressedChangedHandler = {(button, value, pressed) in
                print("ExtendedGamepad - Right")
                if pressed == true {
                    if ventana == "Principal" && ventanaModal == "Ninguna" {
                        if cuentaPrincipio == 0 {
                            self.masSistema()
                        }else {
                            self.masSistemaLista()
                        }
                    }
                    if ventana == "Grid"  && ventanaModal == "Ninguna" {
                        if columna < juegosXml.count - 1 {
                            let indexPath1:IndexPath = IndexPath(item: columna , section: 0)
                            var set1 = Set<IndexPath>()
                            set1.insert(indexPath1)
                            myCollectionView.deselectItems(at: set1)
                            let indexPath:IndexPath = IndexPath(item: columna + 1, section: 0)
                            var set = Set<IndexPath>()
                            set.insert(indexPath)
                            myCollectionView.selectItems(at: set, scrollPosition: .centeredVertically)
                            columna = columna + 1
                            self.actualizaMediaGrid ()
                        }
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
                    if pressed == true {
                        if ventana == "Principal" && ventanaModal == "Ninguna" {
                            if cuentaPrincipio  > 0  {
                                print("ENTER LISTA TRUE")
                                let button = self.view.viewWithTag(Int(self.cuentaDec)) as? ButtonConsolas
                                sistemaActual = button?.Fullname! ?? ""
                                //print(sistemaActual)
                                if backIsPlaying == true {
                                    self.backPlayer.player?.pause()
                                    SingletonState.shared.myBackPlayer?.player?.pause()
                                }
                                if Int(button!.numeroJuegos!)! > 0 {
                                    self.selecionSistema(button!)
                                }
                                
                            } else {
                                
                                    print("ENTER LISTA FALSE")
                                    let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                                    sistemaActual = button?.Fullname! ?? ""
                                    if backIsPlaying == true {
                                        self.backPlayer.player?.pause()
                                        SingletonState.shared.myBackPlayer?.player?.pause()
                                    }
                                    if Int(button!.numeroJuegos!)! > 0 {
                                        self.selecionSistema(button!)
                                    }
                                
                            }
                        }
                        
                        if ventana == "Lista" && ventanaModal == "Ninguna"{
                            self.launchGame()
                        }
                        if ventana == "Grid"  && ventanaModal == "Ninguna"{
                            self.launchGameGrid()
                        }
                    }
                    
                }
                
                //Configuração do botão B
                gamepad.buttonB.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - B")
                    if pressed == true {
                        if ventana == "Grid" && ventanaModal == "Ninguna" {
                            self.openOptions()
                        }
                        if ventana == "Lista" && ventanaModal == "Ninguna" {
                            print("OPTIONS")
                            self.openOptions()
                        }
                    }
                }
                
                //Configuração do botão X
                gamepad.buttonX.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - X")
                    if pressed == true {
                        self.abrirNetplay()
                    }
                    
                }
                
                //Configuração do botão Y
                gamepad.buttonY.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - y")
                    if ventana == "Lista" && ventanaModal == "Ninguna" {
                        if pressed == true {
                            self.backToMain()
                        }
                    }
                    if ventana == "Grid" && ventanaModal == "Ninguna"{
                        if pressed == true {
                            self.backToMain()
                        }
                    }
                    
                }
                
                //Configuración de Select
                
                gamepad.buttonOptions!.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - Home")
                    if pressed == true {
                       // self.openOptions()
                    }
                }
                
                gamepad.buttonMenu.pressedChangedHandler = {(button, value, pressed) in
                    if pressed == true {
                        print("Start")
                        //self.openAjustes()
                    }
                }
                
                
            }
            
        public func configureShoulderButtons(_ gamepad: GCExtendedGamepad) {
                
                //Configuracão do L1
                gamepad.leftShoulder.pressedChangedHandler = {(button, value, pressed) in
                    print( "ExtendedGamepad - Left Shoulder")
                    if pressed == true {
                        if ventana == "Grid"  && ventanaModal == "Ninguna" {
                            myMenosBtn.performClick(nil)
                        }
                        if ventana == "Lista" && ventanaModal == "Ninguna" {
                            myAtrasBtn.performClick(nil)
                        }
                    }
                }
                
                //Configuracão do R1
                gamepad.rightShoulder.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - Right Shoulder")
                    if pressed == true {
                        if ventana == "Grid" && ventanaModal == "Ninguna" {
                            myMasBtn.performClick(nil)
                        }
                        if ventana == "Lista" && ventanaModal == "Ninguna" {
                            myDelanteBtn.performClick(nil)
                        }
                    }
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
                    if pressed == true {
                        self.openAjustes()
                        
                    }
                    
                }
                
                //Configuracão do R2
                gamepad.rightTrigger.pressedChangedHandler = {(button, value, pressed) in
                    print("ExtendedGamepad - Right Trigger")
                    if pressed == true {
                        
                    }
                }
                
            }
        
        func remove(_ controller: GCController) {
            
        }
        public func masSistema() {
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
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    
                    backplay (tag: botonactual)
                }
            }
        }
        
        public func menosSistema(){
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
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    
                    backplay (tag: botonactual)
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
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
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
                    SingletonState.shared.mySystemLabel?.stringValue = "\(button!.Fullname!): \(button!.numeroJuegos!) Juegos "
                    backplay (tag: Int(cuentaDec))
                }
            }
        }
        
    public func launchGame(){
        let numero = (SingletonState.shared.mytable?.selectedRow)
        let nombredelarchivo = SingletonState.shared.myJuegosXml![numero!][0].replacingOccurrences(of: rutaApp , with: "")
        let romXml = "\"\(SingletonState.shared.myJuegosXml![numero!][0])\""
        let rompathabuscar = SingletonState.shared.myJuegosXml![numero!][0]
        var comandojuego = SingletonState.shared.myJuegosXml![numero!][20]
        
        if comandojuego.contains("RetroArch") {
            gameShader(shader: "")
            noGameOverlay()
            let defaults = UserDefaults.standard
            let shaders = defaults.integer(forKey: "Shaders")
            print("SHADERS \(shaders)")
            if shaders == 1 {
                let juegoABuscar = SingletonState.shared.myJuegosXml![numero!][0]
                let miShader = checkShaders(juego: juegoABuscar)
                gameShader(shader: miShader)
            }
            let marcos = defaults.integer(forKey: "Marcos")
            
            if marcos == 1 {
                if checkBezels(juego: SingletonState.shared.myJuegosXml![numero!][0]) == true {
                    gameOverlay(game: nombredelarchivo)
                }
            }
        }
        
        if comandojuego.contains("citra-qt") {
            let mifilaconfig1 = citraConfig.firstIndex(where: {$0.contains("fullscreen=")})
            if mifilaconfig1 != nil {
                citraConfig[mifilaconfig1!] = "fullscreen=true"
            }
            let mifilaconfig2 = citraConfig.firstIndex(where: {$0.contains("fullscreen\\default=")})
            if mifilaconfig2 != nil {
                citraConfig[mifilaconfig2!] = "fullscreen\\default=false"
            }
            
            writeCitraConfig()
        }
        
        
        let fila = arrayGamesCores.firstIndex(where: {$0[0] == rompathabuscar})
        if fila != nil {
            comandojuego = arrayGamesCores[fila!][1]
        }
        
        let micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
        //print(micomando.replacingOccurrences(of: "%ROM%", with: romXml))
        var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
        if playingVideo == true {
            //snapPlayer.player?.pause()
            SingletonState.shared.mySnapPlayer?.player?.pause()
        }
        print(comando)
        Commands.Bash.system("\(comando)")
        comando=""
        
        let indexSet = NSIndexSet(index: (SingletonState.shared.mytable!.selectedRow + -1))
        let indexSet2 = NSIndexSet(index: SingletonState.shared.mytable!.selectedRow )
        SingletonState.shared.mytable!.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        SingletonState.shared.mytable!.selectRowIndexes(indexSet2 as IndexSet, byExtendingSelection: false)
    }
    
    public func backToMain (){
        if ventana == "Lista" {
            cuentaboton = botonactual
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
                controller.view.window?.makeFirstResponder(controller.scrollMain)
                SingletonState.shared.mySnapPlayer?.player?.pause()
                abiertaLista = true
                ventana = "Principal"
                cuentaboton = botonactual
            }
        }
        if ventana == "Grid" {
            if let controller = self.storyboard?.instantiateController(withIdentifier: "HomeView") as? ViewController {
                myPlayer.player?.pause()
                SingletonState.shared.currentViewController?.view.window?.contentViewController = controller
                controller.view.window?.makeFirstResponder(controller.scrollMain)
                //snapPlayer.player?.pause()
                abiertaLista = false
                ventana = "Principal"
                cuentaboton = botonactual
            }
        }
        
    }
    
    public func nextGame () {
        let numero = Int((SingletonState.shared.mytable!.selectedRow))
        
        if numero < (SingletonState.shared.myJuegosXml!.count) {
            
            let indexSet = NSIndexSet(index: (SingletonState.shared.mytable!.selectedRow + 1))
            SingletonState.shared.mytable!.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
            SingletonState.shared.mytable?.scrollRowToVisible(numero + 1)
        }
    }
    
    public func prevGame () {
        let numero = Int((SingletonState.shared.mytable!.selectedRow))
        
        if numero > 0 {
            let indexSet = NSIndexSet(index: (SingletonState.shared.mytable!.selectedRow - 1))
            SingletonState.shared.mytable!.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
            SingletonState.shared.mytable?.scrollRowToVisible(numero - 1)
        }
    }
    
    public func prueba () {
        if cuentaPrincipio  > 0 && ventana == "Principal" {
            print("ENTER LISTA TRUE")
            let button = self.view.viewWithTag(Int(self.cuentaDec)) as? ButtonConsolas
            sistemaActual = button?.Fullname! ?? ""
            //print(sistemaActual)
            if backIsPlaying == true {
                self.backPlayer.player?.pause()
                SingletonState.shared.myBackPlayer?.player?.pause()
            }
            if Int(button!.numeroJuegos!)! > 0 {
                self.selecionSistema(button!)
            }
            
        } else {
            if ventana == "Principal" {
                print("ENTER LISTA FALSE")
                let button = self.view.viewWithTag(Int(botonactual)) as? ButtonConsolas
                sistemaActual = button?.Fullname! ?? ""
                if backIsPlaying == true {
                    self.backPlayer.player?.pause()
                    SingletonState.shared.myBackPlayer?.player?.pause()
                }
                if Int(button!.numeroJuegos!)! > 0 {
                    self.selecionSistema(button!)
                }
            }
        }
        if ventana == "Lista" {
            self.launchGame()
        }
    }
    
    public func checkBezels (juego: String) -> Bool {
        var bezelsSystem = Bool ()
        var bezelsGame = Bool ()
        var bezels = Bool()
        // MARK: comprobamos si tiene puesto que se lancen los bezels en todos los juegos del sistema
        let filaenSystem = arraySystemsBezels.firstIndex(where: {$0[0] == sistemaActual})
        if filaenSystem != nil {
            print(arraySystemsBezels[filaenSystem!])
            //Si está en el array es que está activado, sino es quer no lo está
           bezelsSystem = true
        } else {
            bezelsSystem = false
        }
        
        // MARK: comprobamos si el juego tiene puesto que se lance su bezel
        let filaenGames = arrayGamesBezels.firstIndex(where: {$0[0] == juego})
        if filaenGames == nil {
            bezelsGame = bezelsSystem
        } else {
            let siONoGameBezel = arrayGamesBezels[filaenGames!][1]
            if siONoGameBezel == "SI" {
                bezelsGame = true
            } else {
                bezelsGame = false
            }
        }
        
        if bezelsSystem == true && bezelsGame == true {
            bezels = true
        }
        if bezelsSystem == true && bezelsGame == false {
            bezels = false
        }
        if bezelsSystem == false && bezelsGame == false {
            bezels = false
        }
        if bezelsSystem == false && bezelsGame == true {
            bezels = true
        }
        print("\(bezelsSystem) - \(bezelsGame)")
        
        return bezels
    }
    
    public func checkShaders (juego: String) -> String {
        var shader = String ()
        var shadersSystem = String()
        var shadersGame = String()
        
        let filaenSystem = arraySystemsShaders.firstIndex(where: {$0[0] == sistemaActual})
        if filaenSystem != nil {
            shadersSystem = arraySystemsShaders[filaenSystem!][2]
        } else {
            shadersSystem = ""
        }
        let filaEnGame = arrayGamesShaders.firstIndex(where: {$0[0] == juego})
        if filaEnGame != nil {
            let miShader = arrayGamesShaders[filaEnGame!][2]
            if miShader == "NINGUNO" {
                shadersGame = ""
            } else {
                shadersGame = miShader
            }
            
        }else {
            shadersGame = shadersSystem
        }
        
        if shadersSystem == shadersGame {
            shader = shadersSystem
        }
        
        if shadersSystem != shadersGame  {
            shader = shadersGame
        }
        
        //
        return shader
    }
    public func launchGameGrid() {
        let numero = columna
        let nombredelarchivo = juegosXml[numero][0].replacingOccurrences(of: rutaApp , with: "")
        let romXml = "\"\(juegosXml[numero][0])\""
        let rompathabuscar = juegosXml[numero][0]
        var comandojuego = juegosXml[numero][20]
        myPlayer.player?.pause()
        
        if comandojuego.contains("RetroArch") {
            gameShader(shader: "")
            noGameOverlay()
            let defaults = UserDefaults.standard
            let shaders = defaults.integer(forKey: "Shaders")
            print("SHADERS \(shaders)")
            if shaders == 1 {
                let juegoABuscar = juegosXml[numero][0]
                let miShader = checkShaders(juego: juegoABuscar)
                gameShader(shader: miShader)
            }
            let marcos = defaults.integer(forKey: "Marcos")
            
            if marcos == 1 {
                if checkBezels(juego: juegosXml[numero][0]) == true {
                    gameOverlay(game: nombredelarchivo)
                }
            }
        }
        
        if comandojuego.contains("citra-qt") {
            let mifilaconfig1 = citraConfig.firstIndex(where: {$0.contains("fullscreen=")})
            if mifilaconfig1 != nil {
                citraConfig[mifilaconfig1!] = "fullscreen=true"
            }
            let mifilaconfig2 = citraConfig.firstIndex(where: {$0.contains("fullscreen\\default=")})
            if mifilaconfig2 != nil {
                citraConfig[mifilaconfig2!] = "fullscreen\\default=false"
            }
            
            writeCitraConfig()
        }
        
        var fila = arrayGamesCores.firstIndex(where: {$0[0] == rompathabuscar})
        if fila != nil {
            comandojuego = arrayGamesCores[fila!][1]
            print("CORE CUSTOM")
        } else {
            print("CORE DEFAULT")
        }
        
        var micomando = rutaApp + comandojuego.replacingOccurrences(of: "%CORE%", with: rutaApp)
        var comando = micomando.replacingOccurrences(of: "%ROM%", with: romXml)
        print(comando)
        Commands.Bash.system("\(comando)")
        comando=""
        myPlayer.player?.play()
    }
    
    public func openOptions(){
        if ventana == "Grid" && ventanaModal == "Ninguna"{
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "OptionsView")
                as! NSViewController
            }()
            myPlayer.player?.pause()
            tempViewController = SingletonState.shared.currentViewController!
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
        if ventana == "Lista" && ventanaModal == "Ninguna"{
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "OptionsView")
                as! NSViewController
            }()
            //myPlayer.player?.pause()
            //tempViewController = SingletonState.shared.currentViewController!
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
            listado.becomeFirstResponder()
        }
    }
    public func openAjustes(){
        if ventanaModal == "Ninguna"{
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "ConfigView")
                as! NSViewController
            }()
            
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
    }
    public func abrirNetplay(){
        if ventanaModal == "Ninguna" {
            lazy var sheetViewController: NSViewController = {
                return self.storyboard!.instantiateController(withIdentifier: "NetPlayList")
                as! NSViewController
            }()
            SingletonState.shared.currentViewController?.presentAsModalWindow(sheetViewController)
        }
        
    }
    public func actualizaMediaGrid (){
        myRatingStar.doubleValue = (Double(juegosXml[columna][18]) ?? 0) * 5
        myPlayersLabel.stringValue = juegosXml[columna][17]
        myGameLabel.stringValue = juegosXml[columna][1]
        if juegosXml[columna][4] != "" {
            myBotonManual.isHidden = false
        } else {
            myBotonManual.isHidden = true
        }
        let miBox = juegosXml[columna][23]
        if miBox != "" {
            let imagenURL = URL(fileURLWithPath: miBox)
            var imagen = NSImage(contentsOf: imagenURL)
            myBox3DButton.image = imagen
            myBox3DButton.isHidden = false
        } else {
            myBox3DButton.isHidden = true
        }
        myConsolaLabel.stringValue = juegosXml[columna][22]
        if sistemaActual == "Favoritos" {
            myConsolaLabel.isHidden = false
        } else {
            myConsolaLabel.isHidden = true
        }
    }
}
