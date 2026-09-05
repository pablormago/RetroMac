//
//  RetroMac-Bridging-Header.h
//  RetroMac
//
//  Expone SDL2 a Swift. SDL2 no es un framework modular de verdad (sus cabeceras
//  begin_code.h/close_code.h usan un patrón push/pop que no es compatible con el
//  sistema de módulos de Clang — comprobado: un module.modulemap propio da
//  "Nested inclusion of begin_code.h"). Por eso va por bridging header (inclusión
//  textual clásica) en vez de `import SDL2`.
//
//  Usado solo por SDLControllerManager.swift, para el subsistema de mandos
//  (joystick/gamecontroller) — no se usa nada de vídeo/audio/render de SDL2 aquí.
//

#import <SDL2/SDL.h>
