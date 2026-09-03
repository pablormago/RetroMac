# RetroMac — Análisis integral e índice

> Documento de trabajo para la reforma de la app. Refleja el estado del código a fecha 2026-09-02.
> Objetivo: entender qué hace cada pieza, servir de índice, y listar lo pendiente/roto.

---

## 1. Qué es RetroMac

Frontend de **emulación retro para macOS** (estilo EmulationStation / LaunchBox), escrito en **Swift + AppKit** (storyboard `Main.storyboard`), con un único Pod: **Commands** (para lanzar comandos de shell, `Commands.Bash.system(...)`).

Funciones principales:
- Lee una configuración de sistemas en formato **EmulationStation** (`es_systems_mac.cfg`) y las **gamelist.xml** de cada sistema.
- Muestra los sistemas (pantalla principal) y los juegos (en **Lista** o **Cuadrícula/Grid**), con carátulas, vídeos (snaps), logos, rating, nº de jugadores, etc.
- **Lanza los juegos** con RetroArch (y otros emuladores: Dolphin, RPCS3, Citra, PCSX2, xemu) vía comandos de shell.
- **Scraper de metadatos** contra **ScreenScraper.fr** (imágenes, vídeos, ficha).
- **NetPlay** de RetroArch (lista de partidas desde `lobby.libretro.com`).
- Gestión por **juego y por sistema** de: shaders, bezels/overlays, core, favoritos.
- Control por **teclado y mando** (GameController framework).
- Descarga/instala emuladores y "la Base" (configs) en el primer arranque.
- Tema **siempre claro** (forzado).

Detección de variante **"BoB"** (`esBoB`): si existe `BOBwin.exe` junto a la app, cambia logo/branding.

---

## 2. Arranque y flujo

```
AppDelegate.applicationDidFinishLaunching
        │
        ▼
SplashController (pantalla de carga)   ← Storyboard entry
  viewDidAppear:
   1. Comprueba/crea ~/Documents/RetroMac + copia es_systems_mac.cfg del bundle
   2. Comprueba versión (RetroMac.txt) → si cambia, re-copia base
   3. copiarBase()  (si falta /Users/Shared/Xemu o cambió versión)
   4. En background:
        downloadEmulators()      → RetroArch + emuladores + decorations (bezels)
        mamelista()              → titulosMame (nombres MAME)
        llenaSistemasIds()       → systemsIds (mapeo sistema→ScreenScraper id)
        readRetroArchConfig()    → retroArchConfig
        readCitraConfig()        → citraConfig
        shadersList()            → arrayShaders
        carga arrays de UserDefaults (juegosCores/Shaders/Bezels, systemsShaders/Bezels)
        cuentaJuegosEnSistemas() → parsea cfg + gamelists → allTheSystems / allTheGames
   5. completion → carga "HomeView" (ViewController)
```

`cuentaJuegosEnSistemas()` (en `SplashController`) es el corazón de la carga: por cada `<system>` del cfg crea un `ConsolaRaw` (→ `allTheSystems`) y, si hay `gamelist.xml` o ROMs, un `Consola` con sus `[Juego]` (→ `allTheGames`). Añade el sistema virtual **"Favoritos"**.

---

## 3. Modelo de datos

### Structs (definidos en `ViewController.swift`)
- **`Juego`** — 24 campos. Es la unidad de juego. Se "aplana" a `[String]` de 24 posiciones en la variable global `juegosXml` que usa toda la UI. **Mapa de índices** (crítico, aparece por todo el código como `juegosXml[fila][N]`):

  | 0 path | 1 name | 2 description | 3 map | 4 manual | 5 news |
  |---|---|---|---|---|---|
  | 6 tittleshot | 7 fanart | 8 thumbnail | 9 image | 10 video | 11 marquee |
  | 12 releasedate | 13 developer | 14 publisher | 15 genre | 16 lang | 17 players |
  | 18 rating | 19 fav | 20 comando | 21 core | 22 system | 23 box |

- **`Consola`** — un sistema con juegos: `sistema, fullname, command, rompath, platform, extensions, games:[Juego], videos:[String], cores:[[String]]`.
- **`ConsolaRaw`** — sistema "en crudo" del cfg: `nombrecorto, nombrelargo, comando, rompath, platform, extensions, theme, emuladores:[[String]]`.
- **`PartidaNetplay`** — entrada del lobby de RetroArch (25 campos: ip, port, core, game, mitm…).
- **`ButtonConsolas: NSButton`** — botón de la pantalla principal que **lleva los metadatos del sistema** (`Sistema, Fullname, Comando, RomsPath, Platform, Extensiones, Theme, id, numeroJuegos, videos, cores`).

### Estado global (⚠️ ~70 variables globales en `ViewController.swift` y `funciones.swift`)
Las más importantes:
- `allTheGames: [Consola]`, `allTheSystems: [ConsolaRaw]`, `favoritos: [Juego]`.
- `juegosXml: [[String]]` (juegos del sistema actual, aplanados) — **la fuente de verdad de la UI**. Variantes: `testJuegosXml`, `rawJuegosXml`, `juegosXml2`.
- `sistemaActual`, `nombresistemaactual`, `botonactual`, `cuantosSistemas`.
- `ventana` (`"Principal"`/`"Lista"`/`"Grid"`) y `ventanaModal` (`"Ninguna"`/otro) → **máquina de estados de navegación**.
- `columna`, `fila` (selección en grid/lista).
- `rutaApp`, `rompath` (rutas base).
- Config: `retroArchConfig`, `citraConfig`, `arrayShaders`, `arrayGamesCores/Shaders/Bezels`, `arraySystemsShaders/Bezels`.
- `buscarLocal` (usar media local), `esBoB`, `openEmu`, `pantallaJuegos`.
- `userDev`/`userpass` → **credenciales de ScreenScraper hardcodeadas** ⚠️.

---

## 4. Pantallas y navegación

Storyboard IDs y su controller:

| ID Storyboard | Controller | Rol |
|---|---|---|
| *(entry)* | `SplashController` | Carga inicial |
| `HomeView` | `ViewController` | **Pantalla principal**: selección de sistema (carrusel de `ButtonConsolas`) |
| `GridView` | `GridScreen` | Juegos en **cuadrícula** (NSCollectionView, 3 columnas) |
| `ListaView` | `ListaViewController` | Juegos en **lista** (NSTableView) con ficha/preview |
| `ConfigView` | `ConfigViewController` | **Ajustes generales** (usuario scraper, shaders/marcos on-off, media local, pantalla Lista/Grid) |
| `OptionsView` | `OptionsViewController` | **Opciones de sistema y de juego** (core, shader, bezel, scrap, favorito, borrar, renombrar, netplay host) |
| `NetPlayList` | `NetPlayListController` | Lista de partidas NetPlay para unirse |

Elección Lista vs Grid: `selecionSistema` (en `ViewController`) mira el UserDefault **`PantallaJuegos`** (`"Lista"` por defecto, o `"Cuadrícula"`).

---

## 5. Controles

Capturados por **`NSEvent.addLocalMonitorForEvents`** (teclado, en `ViewController` y `GridScreen`) y por **GameController** (mando).

### Mando (GCExtendedGamepad) — mapeo en `MainScreen/mainScreenGameController.swift`
| Botón | En "Principal" | En "Lista" | En "Grid" |
|---|---|---|---|
| **D-pad ←/→** | sistema anterior/siguiente | — | mover selección ∓1 |
| **D-pad ↑/↓** | — | juego anterior/siguiente | mover selección ∓3 (fila) |
| **A** | entrar al sistema | lanzar juego | lanzar juego |
| **B** | — | opciones | opciones |
| **X** | netplay | netplay | netplay |
| **Y** | — | volver a principal | volver a principal |
| **L1 / R1** | — | botón atrás / adelante lista | sistema ∓ |
| **L2** | abrir ajustes | abrir ajustes | abrir ajustes |
| **R2** | *(sin usar)* | | |
| **Select / Start** | *(sin usar, comentado)* | | |

*(Nota: existe una copia paralela del mapeo de mando en `ListScreen/listScreenGameController.swift` para la pantalla de lista, con comentarios en portugués — derivado de un tutorial.)*

### Teclado (keyCodes)
`36`=Enter (lanzar/entrar), `53`=Escape, `123`=←, `124`=→, `125`=↓, `126`=↑, `51`=Backspace (volver), `49`=Espacio, `99`=F3. La lógica de navegación por teclas está en `MainScreen/mainScreenKeyboard.swift` (`masSistemaKeys`, `menosSistemaKeys`, `…ListaKeys`) y en `GridScreen.keyDown`.

---

## 6. Parsing y ficheros

- **`parserSystems.swift`** — parser XML **encadenado** de `es_systems_mac.cfg` (`<systemList>/<system>` + `<emuladores>/<emu>`). ⚠️ Nombres heredados de un tutorial de libros: `BookParser`, `Book`, `Author`, `LinksParser`, `Link` (aquí `Book`=sistema, `Link`=emulador/core).
- **`gameListParser.swift`** — parser XML de `gamelist.xml` (formato EmulationStation) → `Juego`.
- **`gameListParser` / `funciones.juegosGamelistCarga`** — construyen los `[Juego]` de cada sistema, resolviendo rutas de media (imagen, vídeo, manual, box, marquee…).
- **Configs que lee/escribe**: `retroarch.cfg` (`readRetroArchConfig`/`writeRetroArchConfig`), config de Citra (`readCitraConfig`/`writeCitraConfig`), `RetroMac.txt` (versión), overlays/shaders de RetroArch.

Rutas de datos: `~/Documents/RetroMac/`, `~/Documents/Retroarch/`, `/Users/Shared/Xemu`, `~/Library/Application Support/`.

---

## 7. Emuladores y lanzamiento

- **`downloadEmulators()`** (`funciones.swift`): descarga RetroArch de `buildbot.libretro.com` y otros emuladores (Dolphin, RPCS3, Citra, PCSX2, xemu) + `decorations.zip` (bezels) desde **enlaces personales de Dropbox** ⚠️ (frágil).
- **Lanzamiento**: `launchGame()` / `launchGameGrid()` construyen el comando (sustituyendo `%CORE%` y `%ROM%`) y lo ejecutan con `Commands.Bash.system(...)`. Antes de lanzar aplican **shader** (`gameShader`) y **bezel/overlay** (`gameOverlay`) según config de juego/sistema (`checkShaders`, `checkBezels`). Casos especiales para RetroArch y `citra-qt` (fullscreen).
- ⚠️ **`checkShaders`, `checkBezels`, `launchGame` están DUPLICADOS** en 5 sitios: `GridScreen`, `ListaViewController` (listScreenFunctions), `NetPlayListController`, `OptionsViewController` (optionsScreenFunctions) y `mainScreenGameController`.

---

## 8. Scraper (ScreenScraper.fr)

API `https://www.screenscraper.fr/api2/` (`jeuRecherche.php`, `jeuInfos.php`, `mediaVideoJeu.php`) + `medias/`. Autenticación con `userDev`/`userpass` (dev) + usuario/clave del usuario (en Ajustes). Descarga ficha + imágenes + vídeo y reescribe la `gamelist.xml`.

Implementado (con mucha duplicación) en:
- `ListScreen/listScreenScrapers.swift` (lista): `buscaJuego`, `scrapearJuego`, `buscaJuegoS`, `escrapearSistema`, `escrapeartodos`, `xmlJuegosNuevos`.
- `optionsScreen/optionsScreenFunctions.swift` y `optionsScreen/optionsScreenGridFunctions.swift` (desde Opciones / Grid): las mismas funciones repetidas (`buscaJuegoGrid`, `scrapearJuego`, `scrapearJuegoGrid`, …).

---

## 9. Índice fichero por fichero

### Núcleo / arranque
- **`AppDelegate.swift`** — `applicationDidFinishLaunching` (vacío), `applicationWillTerminate` (⚠️ mata la app "Terminal"), `abrirAyuda` (abre `Ayuda.pdf`).
- **`SplashController.swift`** — carga inicial. `viewDidAppear` (orquesta todo), `cuentaJuegosEnSistemas` (parseo cfg+gamelists → arrays), `getDocumentsDirectory`.
- **`singleton.swift`** — `SingletonState.shared`: referencias compartidas (currentViewController, players AV, table, scroller, systemLabel).
- **`funciones.swift`** — cajón de funciones globales: `llenaSistemasIds`, `NetPlayCores`, `mamelista`, `cuentajuegos`, `juegosGamelistCarga`, `xmlJuegosNuevos2`, `crearGameListInicioCarga`, `escribeSistemas`, `busca{Image,Manual,TittleShot,FanArt,Marquee,Box}`, `rutaARelativa`, `read/writeRetroArchConfig`, `gameShader`, `gameOverlay`, `noGameOverlay`, `cargaPartidasNetplay`, `comprobarJuegoNetPlay`, `shadersList`, `read/writeCitraConfig`, `downloadEmulators`, `CPUType`/`CPUType1` (Intel/ARM).

### Pantalla principal (sistemas)
- **`ViewController.swift`** — `HomeView`. Globales + structs. `viewDidLoad/viewDidAppear/viewWillAppear` (montan carrusel de `ButtonConsolas`, background video), `enterSystem`, `selecionSistema` (abre Lista/Grid), `masMenu/menosMenu`, `backplay/backStop` (vídeo de fondo), `switchToggle`, `openNetplay`, `openSettings`. Structs `Juego/Consola/ConsolaRaw/PartidaNetplay/ButtonConsolas`, `copiarBase`, `buscaVideo`, extensión `String.numberOfOccurrencesOf`.
- **`MainScreen/mainScreenGameController.swift`** — mando en principal/lista/grid: `startWatchingForControllers`, `add`, `configure{DPad,Diamond,Shoulder,Triggers}Buttons`, `mas/menosSistema(Lista)`, `launchGame`, `launchGameGrid`, `backToMain`, `next/prevGame`, `check{Bezels,Shaders}`, `openOptions/openAjustes/abrirNetplay`, `actualizaMediaGrid`, `activa/desactivaBotones`.
- **`MainScreen/mainScreenKeyboard.swift`** — navegación por teclado: `masSistemaKeys`, `masSistemaListaKeys`, `menosSistemaKeys`, `menosSistemaListaKeys` (el `keyDown` override está comentado; se usa vía monitor NSEvent).

### Cuadrícula (Grid)
- **`GridScreen/GridScreen.swift`** — `GridView`. NSCollectionView 3-col. Datasource/delegate, `configureCollectionView`, `arrayJuegos`, `launchGame`, `check{Shaders,Bezels}`, `getLogo`, navegación y acciones (`lanzarJuegos`, `abrirAjustes`, `abrirBox3d`, `openManual`, `openGameSettings`, `abrirNetplay`, `mas/menosSistema`, `backFunc`, `keyDown`).
- **`GridScreen/gridScreenGameController.swift`** — extensión (stub) de GridScreen para mando.
- **`Photo Item/PhotoItem.swift`** — `NSCollectionViewItem` (imagen + label + AVPlayer + doble clic). *[reconstruido]*
- **`Photo Item/PhotoItem.xib`** — vista del item. *[reconstruido]*
- **`GridScreen/Photo Handling/PhotoInfo.swift` + `PhotoHelper.swift`** — *[del tutorial AppCoda; NO se usan en el código actual]*.

### Lista (Lista)
- **`ListaViewController.swift`** — `ListaView`. NSTableView + ficha (título, descripción con `ScrollingTextView`, players, género, fechas, screenshot, snap AVPlayer, favorito, editar/borrar). Acciones: `lanzarJuego`, `abrirAjustes/Netplay/Opciones`, `volverAlMenu`, `deleteGame`, `aceptarTitulo` (renombrar), `abrirGameOption`, `onItemClicked`. Incluye extensión `DispatchQueue.background`.
- **`ViewControllers/ListaViewController.swift`** — ⚠️ **fichero casi vacío** (otra clase `ListaViewController` con `viewDidLoad/viewDidAppear` stub) — **posible colisión/legado**.
- **`ListScreen/listScreenTable.swift`** — datasource/delegate de la tabla (`numberOfRows`, `viewFor`, `selectionDidChange`).
- **`ListScreen/listScreenFunctions.swift`** — `favGames/unfavGames`, `xmlJuegosNuevosFav`, `recargar`, `cargarImagen`, `imageSelected`, `check{Bezels,Shaders}`, `abrirPdf`, `backFunc`, `EnableBoxBorrar/Editar`.
- **`ListScreen/listScreenScrapers.swift`** — scraper (ver §8).
- **`ListScreen/listScreenBezels&Shaders&Cores.swift`** — menús contextuales de shaders/bezels/cores por juego y por sistema (`setShader`, `removeShader`, `autoShader`, `set/removeSystemShader`, `si/no/autoGameBezel`, `si/noSistemBezel`, `core{sistema,juego,auto}`).
- **`ListScreen/listaScreenMenu.swift`** — menú de opciones de la lista: `crearItemsMenu`, `setupMenu`, `itemsPorJuego`. ⚠️ item **"Scrapear Todos los Sistemas" con `action: nil`** (sin conectar).
- **`ListScreen/listScreenKeyboard.swift`** — `keyDown/keyUp` de la lista.
- **`ListScreen/listScreenGameController.swift`** — mando en la lista (copia con comentarios en portugués).
- **`ListScreen/listScreenNetPlay.swift`** — `configNetplay`, `editRetroArchConfig`, `lanzarNetPlay`.

### Modales de configuración
- **`ConfigViewController.swift`** — `ConfigView`. Ajustes generales: usuario/clave scraper, switches (shaders, marcos/bezels, media local), selector de pantalla (Lista/Grid) y servidor. `guardar`, `salir`, `editRetroArchConfig`.
- **`OptionsViewController.swift`** — `OptionsView`. Opciones de sistema y juego (popups de core/shader/bezel + botones scrap/fav/borrar/renombrar/netplay). `guardar`, `cerrar`, `netplayHost`, `escrapearSistema`.
- **`optionsScreen/optionsScreenFunctions.swift`** — la chicha de OptionsView: `get{Fav,SystemAndGame,SystemCores,SystemShaders,GameCore,GameShaders,SystemBezels,GameBezels}`, `saveOptions`, `favoritos/favGames/unfavGames`, `deleteGameGrid`, `alertaBorrar`, `cambiarTitulo/alertaTitulo`, netplay, `check{Shaders,Bezels}`, scraper.
- **`optionsScreen/optionsScreenGridFunctions.swift`** — variantes del scraper para el Grid (`scrapearJuegoGrid`, `xmlJuegosNuevosGrid`, `buscaJuegoSGrid`).
- **`Filtros.swift`** — navegación por carpetas/niveles dentro de un sistema: `filtradoPaso1`, `subirNivel`, `bajarNivel`, `cargaItemCero`, `cargaItemColumna`, `getVideo`, `getImagen`, `getFolderImageDefault`.

### NetPlay
- **`NetPlayListController.swift`** — `NetPlayList`. Tabla de partidas, `actualizarLista`, `conectar`, `launchGame` (une a partida), `check{Shaders,Bezels}`.

### UI utilitaria
- **`ScrollingTextView.swift`** — label con texto que hace scroll (marquesina) para descripciones largas.

### Datos/parsers
- **`parserSystems.swift`**, **`gameListParser.swift`** — ver §6.
- **`SwiftyJSON.swift`** — librería de terceros (JSON del scraper/netplay). *[restaurada]*

---

## 10. Deuda técnica, bugs y cosas sin terminar

### 🔴 Bugs / crashes latentes
1. **Force-unwrap de `button!.numeroJuegos!`** aún en `mainScreenGameController.swift` (botón A, ~líneas 224 y 237) y `Int(sender.numeroJuegos!)!` en `ViewController.selecionSistema` (~439). Mismo patrón que ya reventó con la lista vacía; sólo se arreglaron las rutas de teclado.
2. **`AppDelegate.applicationWillTerminate`** mata cualquier app llamada **"Terminal"** al cerrar — efecto colateral peligroso (cierra la Terminal del usuario).

### 🟠 Arquitectura
3. **~70 variables globales mutables** — todo el estado es global. Difícil de razonar y de testear. Candidato nº1 a refactor (mover a un modelo/estado inyectado).
4. **`juegosXml: [[String]]` con 24 índices mágicos** por todas partes. Ya existe el struct `Juego`; habría que usarlo en vez del array de strings.
5. **Duplicación masiva**: `checkShaders`, `checkBezels`, `launchGame`, `scrapearJuego`, `buscaJuegoS`, `xmlJuegosNuevos` están copiados en 3-5 ficheros (Grid / Lista / Options / OptionsGrid / NetPlay / mainScreenGameController). Unificar en un servicio.
6. **Dos clases `ListaViewController`** (`ListaViewController.swift` real vs `ViewControllers/ListaViewController.swift` casi vacía) — aclarar/eliminar la legada.
7. **Nombres heredados de tutoriales**: `BookParser/Book/Author/Link` (para sistemas), `Photo/PhotoItem/PhotoHelper` (de un tutorial de fotos; `PhotoHelper`/`PhotoInfo` ni se usan), comentarios en portugués en el mando de lista.

### 🟡 Seguridad / distribución
8. **Credenciales de ScreenScraper hardcodeadas** (`userDev`/`userpass` en `ViewController.swift`). Sacar del código.
9. **Emuladores servidos desde Dropbox personal** (`dl.dropboxusercontent.com/...`) — enlaces frágiles que pueden caer; conviene un hosting propio/estable.

### 🟢 Funcionalidad sin terminar (a confirmar con Pablo)
10. **"Scrapear Todos los Sistemas"** — item de menú existe pero `action: nil` (no hace nada).
11. **Botones de mando Select/Start y R2** — handlers vacíos/comentados (sin función asignada).
12. Varios `@IBAction`/ramas con lógica comentada (p.ej. `buttonOptions`/`buttonMenu` → `openOptions`/`openAjustes` comentados).

### ✍️ Detalles menores
- Typos en identificadores: `playersLabeñ`, `menosSistena` (por "menosSistema").
- Muchos `print(...)` de depuración por todo el código.
- Mezcla de idiomas en nombres (ES/PT/EN).

---

## 10-bis. Cambios aplicados — Fase 1 (2026-09-02)

- **Ventana (punto 1):** nuevo helper `NSWindow.maximizarAreaVisible()` (en `ViewController.swift`) que coloca la ventana en `screen.visibleFrame` (todo menos la barra de menú y el Dock). Sustituidos todos los `setFrame(NSRect(0,0,ancho,alto))` dispersos (ViewController, GridScreen ×2, ListaViewController ×2) y las fuentes de `ancho/alto` pasan de `.frame` a `.visibleFrame`. Pendiente de probar en pantalla.
- **Mando en Grid (punto 2):** ANALIZADO — no estaba sin terminar; lo gestionan los handlers compartidos del `ViewController` (cubren `Principal/Lista/Grid` vía `ventana`). `gridScreenGameController.swift` sigue vacío a propósito. Sin cambios de código; a confirmar probando con mando.
- **Bugs de crash (punto 3):** blindados TODOS los `button!.numeroJuegos!` / `button!.Fullname!` / `Int(sender.numeroJuegos!)!` con `guard`/`if let` + `?? ""`/`?? "0"` en: `ViewController.selecionSistema`, `mainScreenGameController` (botón A y `prueba()`, y las 4 etiquetas de `mas/menosSistema(Lista)`), y `mainScreenKeyboard` (4 etiquetas). Ya no queda ningún `button!` activo.

### Resueltos también en Fase 1
- **Cierre de Terminal de los emuladores** — los emuladores abren una Terminal al lanzarse. Nuevo helper global `lanzarJuegoYcerrarTerminal(_:)` (en `ViewController.swift`) que envuelve el lanzamiento: captura si Terminal estaba abierta, lanza (`Commands.Bash.system` bloquea hasta que el juego se cierra) y, al volver, cierra la Terminal **solo si no estaba abierta antes** (nunca la del usuario). Aplicado en los **7 sitios de lanzamiento de juego** (GridScreen, mainScreenGameController ×2, ListaViewController, NetPlayListController ×2, listScreenNetPlay, optionsScreenFunctions). `AppDelegate.applicationWillTerminate` vuelve a ser no-op (la limpieza ahora es al cerrar cada juego, no al salir de la app). Las demás `Commands.Bash.system` (cp/curl/mkdir) no se tocan.
- **Fichero muerto `ViewControllers/ListaViewController.swift`** — BORRADO (huérfano, no compilado). Carpeta vacía eliminada.

---

## 11. Qué falta por decidir (para la reforma)

- ¿Qué features concretas quieres **terminar** primero? (10-12 arriba, u otras que tengas en la cabeza).
- ¿La reforma es **estética** (rediseño de las 3 pantallas), **estructural** (refactor de estado/duplicación) o **funcional** (features nuevas)? — o las tres por fases.
- Recordatorio de tus normas: paridad de diseño exacta y sistema de traducciones si algo se comparte; y actualizar el manual de ayuda tras cualquier cambio de UI/flujo.
