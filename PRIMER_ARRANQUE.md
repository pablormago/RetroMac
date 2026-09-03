# RetroMac — Diagnóstico del PRIMER ARRANQUE

> Análisis exhaustivo del arranque en frío: generación de la Base, descarga de emuladores/cores
> y estabilización de la app. Leído función a función (no por firmas). Cita `archivo:línea`.
> Fecha: 2026-09-02.

---

## 0. Secuencia real de arranque

`AppDelegate` → **`SplashController`** (entry del storyboard). Todo el trabajo está en
`SplashController.viewDidAppear` ([SplashController.swift:52](RetroMac/SplashController.swift:52)):

1. Crea `~/Documents/RetroMac/` y copia `es_systems_mac.cfg` del bundle **si no existe** (líneas 70-110).
2. Comprueba versión con `~/Documents/Retroarch/RetroMac.txt`; si cambió, re-copia el cfg (112-205).
3. `copiarBase()` si falta `/Users/Shared/Xemu` **o** cambió la versión (208-219).
4. En **background** (`DispatchQueue.background`, 227-252):
   `downloadEmulators()` → `mamelista()` → `llenaSistemasIds()` → `readRetroArchConfig()` →
   `readCitraConfig()` → `shadersList()` → carga arrays de `UserDefaults` → `cuentaJuegosEnSistemas()`.
5. `completion:` → instancia `HomeView` (`ViewController`) y lo pone como `contentViewController`.

Es decir: **un solo método hace de instalador, actualizador y cargador**, todo secuencial y sin
control de errores real. Si algo peta a mitad, la app queda en un estado indefinido (o crashea).

---

## 1. Config de sistemas (`es_systems_mac.cfg`)

**Cómo se hace:** se empaqueta en el bundle (66 KB, 95 sistemas) y se copia a
`~/Documents/RetroMac/es_systems_mac.cfg` **solo si no existe** ([SplashController.swift:89](RetroMac/SplashController.swift:89)).
La app SIEMPRE lee esa copia, no la del bundle ([SplashController.swift:259](RetroMac/SplashController.swift:259)).

**Problemas:**
- Un fichero de **0 bytes** contaba como "existe" → arrancaba sin ningún sistema (bug real que
  ya te pasó; **corregido**: ahora re-copia si falta o está vacío).
- `createDirectory(atPath: dataPath.absoluteString)` usaba `URL(string:)` sobre un path pelado +
  `.absoluteString` → force-unwrap frágil y percent-encoding con espacios. **CORREGIDO** (ahora
  `FileManager.urls(...)` + `.path`). Nota: la carpeta anidada `~/Documents/RetroMac/RetroMac/` NO
  la causaba este bug — es una **copia manual del código fuente** dejada ahí por error (~12 MB);
  sobrante, se puede borrar a mano.

**Cómo debería hacerse:** validar el cfg (tamaño + parseo OK), versionarlo, y usar `.path` (no
`absoluteString`). Idealmente separar "config de fábrica" (bundle, solo lectura) de "config del
usuario" (editable), y hacer *merge* al actualizar en vez de sobrescribir.

---

## 2. Generación de "la Base" (`copiarBase`)

**Cómo se hace:** [ViewController.swift:526](RetroMac/ViewController.swift:526). Copia con `cp -r`
(shell) tres árboles del bundle a disco:
- `Contents/Resources/Base/Shared/Xemu` → `/Users/Shared/Xemu`
- `Contents/Resources/Base/Documents/Retroarch` → `~/Documents`
- `Contents/Resources/Base/ApplicationSupport/` → `~/Library/Application Support`
- (citra comentado)

La carpeta `Base/` del bundle pesa **474 MB** (RetroArch database/playlists/assets/shaders/
overlays/autoconfig/info, PCSX2 inis, xemu, config de citra).

**Problemas:**
- **474 MB metidos dentro del `.app`** → binario descomunal y lento de distribuir/actualizar.
- `cp -r` por shell: **sin control de errores, sin progreso, sin verificación**. Si falla una copia,
  nadie se entera y RetroArch arranca a medias.
- Disparo grueso: se rehace toda la Base si falta `/Users/Shared/Xemu` **o** cambió la versión;
  no repara copias parciales/corruptas.
- Escribir en `/Users/Shared` es raro para datos de una app de usuario.

**Cómo debería hacerse:** no empaquetar 474 MB. Enviar solo lo mínimo imprescindible y **descargar
bajo demanda** el resto (o dejar que RetroArch se auto-configure). Usar `FileManager` (no `cp` shell)
con manejo de errores y verificación (tamaño/hash). Guardar en el contenedor de la app o en
`~/Library/Application Support/RetroMac`, no en `/Users/Shared`.

---

## 3. Descarga de emuladores y cores (`downloadEmulators`) — el punto crítico

**Cómo se hace:** [funciones.swift:1279](RetroMac/funciones.swift:1279). Solo se ejecuta si NO existe
`Emuladores_Mac/` ([línea 1284](RetroMac/funciones.swift:1284)). Detecta CPU con `CPUType()`
(sysctl `hw.cputype`, [1369](RetroMac/funciones.swift:1369)) y:

- **RetroArch:**
  - Intel (X86): `curl -O http://buildbot.libretro.com/nightly/apple/osx/x86_64/RetroArch.dmg`,
    monta con `hdiutil`, copia `RetroArch.app`, desmonta ([1296](RetroMac/funciones.swift:1296)).
  - Apple Silicon (ARM): `https://buildbot.libretro.com/nightly/apple/osx/universal/RetroArch_Metal.dmg`
    ([1304](RetroMac/funciones.swift:1304)).
- **Cores:** ~200 nombres hardcodeados ([1292](RetroMac/funciones.swift:1292)); descarga cada
  `<core>_libretro.dylib.zip` uno a uno y los descomprime ([1298-1319](RetroMac/funciones.swift:1298)).
- **Otros emuladores + bezels:** Citra, xemu, RPCS3, PCSX2, Dolphin y `decorations.zip` desde
  **enlaces personales de Dropbox** ([1325](RetroMac/funciones.swift:1325)), y los descomprime
  ([1332-1343](RetroMac/funciones.swift:1332)).

**Problemas (graves):**
1. 🔴 **BUG en cores de ARM** ([funciones.swift:1307](RetroMac/funciones.swift:1307)): la URL es
   `http://http://buildbot.libretro.com/...arm64/latest/...` — **doble esquema** → `curl` falla al
   resolver el host `http`. **En Apple Silicon no se descarga ni un solo core.**
2. 🔴 **Enlaces personales de Dropbox** para 6 descargas ([1325](RetroMac/funciones.swift:1325)):
   frágiles, no oficiales, se pueden caer/borrar y matar la instalación.
3. 🔴 **Citra descontinuado** (marzo 2024, acuerdo con Nintendo). Ese `citra.zip` es un callejón sin
   salida; hay que migrar a **Azahar** (sucesor oficial, azahar-emu.org).
4. 🟠 **Descarga ~200 cores hardcodeados, y ~la mitad no los usa nadie.** La lista del selector de
   cores (opciones de juego/sistema) NO sale de la carpeta `cores/`, sale del cfg: `consola.cores` =
   los `<emuladores>/<emu>` de ese sistema ([optionsScreenFunctions.swift:1324](RetroMac/optionsScreen/optionsScreenFunctions.swift:1324)
   y [1400](RetroMac/optionsScreen/optionsScreenFunctions.swift:1400)). Es decir, el selector se
   rellena aunque el `.dylib` no esté; el core solo hace falta para **lanzar**, no para **listar**.
   En el cfg actual hay **68** cores en `<emu core>` + **101** en `<command>` → unión ≈ **100-110**
   cores realmente referenciados, frente a los ~200 del array hardcodeado
   ([funciones.swift:1292](RetroMac/funciones.swift:1292)) → **~90 cores muertos** que nunca se pueden
   elegir ni lanzar. Además la lista hardcodeada se **desincroniza** del cfg.
5. 🟠 **Todo secuencial y bloqueante** (`Commands.Bash.system` espera a cada `curl`): descargar 200
   cores de uno en uno es lentísimo, sin paralelismo, sin reintentos, sin progreso por ítem.
6. 🟠 **Cero control de errores/HTTP**: un 404 o corte de red pasa desapercibido → instalación rota
   sin avisar. No hay verificación de tamaño/hash.
7. 🟠 **Todo-o-nada** ([1284](RetroMac/funciones.swift:1284)): si `Emuladores_Mac/` existe a medias,
   nunca repara ni reintenta lo que falta.
8. 🟡 **Nightly, no stable**: builds inestables de RetroArch. Y usa `http://` (funciona solo porque
   `Info.plist` tiene `NSAllowsArbitraryLoads=true`, que es un olor de seguridad).
9. 🟡 Asume el volumen `/Volumes/RetroArch` al montar; el dmg *Metal* puede montar con otro nombre.

**Cómo debería hacerse (fuentes OFICIALES, HTTPS):**
- **RetroArch:** build **stable** oficial del buildbot de libretro por **HTTPS**
  (`https://buildbot.libretro.com/stable/…/apple/osx/…`), universal para cubrir Intel+ARM.
- **Cores:** **derivar la lista DEL cfg**, no hardcodear 200. Conjunto a bajar = (todos los
  `_libretro.dylib` de los `<command>`) ∪ (todos los `<emu core>`), deduplicado (~100-110). Así todo
  lo que el selector ofrece está descargado y lanzable, sin bajar basura, y se auto-sincroniza al
  editar el cfg. Bajarlos del buildbot por **HTTPS** `…/apple/osx/<arch>/latest/<core>_libretro.dylib.zip`
  con reintentos/verificación (arreglar el `http://http://` de ARM). Variantes: (B) solo los cores de
  los sistemas con ROMs; (C) descarga bajo demanda al seleccionar/lanzar un core que falte. O dejar
  que el **Online Updater** de RetroArch los baje.
- **Dolphin:** web oficial [dolphin-emu.org/download](https://dolphin-emu.org/download/) (publican
  el último build macOS universal, con JSON de versiones).
- **PCSX2:** releases oficiales de GitHub [`PCSX2/pcsx2`](https://github.com/PCSX2/pcsx2/releases)
  (o pcsx2.net/downloads).
- **RPCS3:** [rpcs3.net/download](https://rpcs3.net/download) / GitHub
  [`RPCS3/rpcs3-binaries-mac`](https://github.com/RPCS3/rpcs3-binaries-mac/releases).
- **xemu:** releases oficiales de GitHub [`xemu-project/xemu`](https://github.com/xemu-project/xemu/releases).
- **Citra → Azahar:** [azahar-emu.org](https://azahar-emu.org) / GitHub
  [`azahar-emu/azahar`](https://github.com/azahar-emu/azahar/releases).
- **Bezels/overlays:** vienen con RetroArch (Online Updater) o del repo `libretro/common-overlays`;
  no hace falta un `decorations.zip` personal.
- **Mecanismo recomendado:** resolver el último asset de macOS con la **GitHub Releases API** (HTTPS,
  JSON, oficial) por emulador; descargar en paralelo con progreso, reintentos y verificación de
  hash/tamaño; bajar solo lo necesario; poder reanudar/reparar. Quitar `NSAllowsArbitraryLoads` una
  vez todo sea HTTPS.

---

## 4. Estabilización de la app para su uso

Tras las descargas, en el background de `viewDidAppear` se preparan datos y config:

- **`mamelista()`** [funciones.swift:261](RetroMac/funciones.swift:261): lee `Resources/mamelist.txt`
  (rom→nombre MAME). ⚠️ `try! String(contentsOfFile:)` (crashea si falta) y `misvalores[1]`
  (crashea si una línea no tiene coma).
- **`llenaSistemasIds()`** [funciones.swift:13](RetroMac/funciones.swift:13): mapa hardcodeado
  sistema→id de ScreenScraper (decenas de `let x = ["sys","id"]`). Dato estático; debería ser un
  fichero de datos, no código.
- **`readRetroArchConfig()`** [funciones.swift:908](RetroMac/funciones.swift:908): parsea
  `retroarch.cfg`. ⚠️ **`preconditionFailure` CRASHEA la app** si el cfg falta ([920](RetroMac/funciones.swift:920),
  [926](RetroMac/funciones.swift:926)); y `myparams[1]` **crashea** con cualquier línea sin `=`
  (comentario/vacía) ([960](RetroMac/funciones.swift:960)). Muy frágil justo en el arranque.
- **`readCitraConfig()`** [funciones.swift:1215](RetroMac/funciones.swift:1215): más robusto (si
  falta, copia de la Base y reintenta), pero la recursión podría hacer bucle si la copia falla.
- **`shadersList()`** [funciones.swift:1194](RetroMac/funciones.swift:1194): OK (enumera `.glsl`).
- **`NetPlayCores()`** [funciones.swift:190](RetroMac/funciones.swift:190): mapa hardcodeado
  dylib→nombre de core para netplay. Dato estático en código.
- Carga arrays de `UserDefaults` (juegosCores/Shaders/Bezels, systemsShaders/Bezels).
- **`cuentaJuegosEnSistemas()`** [SplashController.swift:257](RetroMac/SplashController.swift:257):
  parsea el cfg + las `gamelist.xml` → `allTheSystems` / `allTheGames`.

**Problemas:** trabajo pesado y **síncrono** en el arranque, sembrado de `try!`, force-index y
`preconditionFailure` que **crashean** en vez de degradar con gracia; ningún error se le muestra al
usuario (o crashea, o se queda colgado en el Splash). Datos estáticos (ids, cores) viven en código.

**Cómo debería hacerse:** ninguna lectura de fichero con `try!`/`preconditionFailure`; parseo
tolerante (saltar líneas sin `=`); mover ids/cores a ficheros de datos; separar "descargar/instalar"
de "cargar/parsear"; progreso real y estados de error con reintento; hacer la carga incremental para
no bloquear.

---

## 5. Resumen de prioridades (primer arranque)

| # | Cosa | Estado actual | Debería |
|---|---|---|---|
| 1 | cfg de sistemas | copia solo-si-no-existe (bug 0 bytes, ya corregido); bug `absoluteString` | validar+versionar, usar `.path`, merge |
| 2 | Base (474 MB) | empaquetada en el `.app`, `cp -r` sin control | mínima + descarga bajo demanda, `FileManager`, verificación |
| 3 | RetroArch | nightly `http://`, ARM vía Metal | **stable HTTPS** universal |
| 4 | Cores | ~200 hardcodeados (~90 muertos), **ARM roto (`http://http://`)**, secuencial | derivar del cfg (~110), HTTPS, paralelo, reintentos; el selector ya sale del cfg |
| 5 | Otros emuladores | **Dropbox personal**, Citra muerto | webs/GitHub oficiales; Citra→**Azahar** |
| 6 | Bezels | `decorations.zip` personal | overlays oficiales de RetroArch |
| 7 | Estabilización | `try!`/`preconditionFailure` crashean | lecturas tolerantes, sin crashes, con progreso |
| 8 | Seguridad | `NSAllowsArbitraryLoads=true` | todo HTTPS y quitar el allow |

---

## 6. Lista de arreglos (checklist) — por área

Severidad: 🔴 crítico · 🟠 importante · 🟡 limpieza.

### A) cfg de sistemas
- [x] 🟠 **Bug `createDirectory(... .absoluteString)`** ([SplashController.swift:72](RetroMac/SplashController.swift:72)) — **HECHO**: `URL(string:)`+`.absoluteString` → `FileManager.urls(...)` + `.path`.
- [x] 🟡 **Copia manual del código fuente sobrante** en `~/Documents/RetroMac/RetroMac/` — **BORRADA**.
- [x] 🟡 **Validar/versionar el cfg sin perder ediciones** — **HECHO**: nuevo `cfgEsValido()` (parsea `<system>`); el arranque recopia solo si el cfg falta/no es válido; y en cambio de versión ya **NO** se pisa el cfg del usuario (conserva sus selecciones de core que escribe `escribeSistemas`), solo se recopia si es inválido. *(Merge fino de sistemas nuevos del bundle: no se hace — se prioriza no perder datos del usuario.)*

### B) Base (generación — `copiarBase`, [ViewController.swift:526](RetroMac/ViewController.swift:526))
- [x] 🟠 **`cp -r` sin control** — **HECHO (parcial)**: se mantiene `cp -r` (conserva el *merge* que necesita `~/Library/Application Support`), pero ahora con rutas **entrecomilladas** (bug si el path tiene espacios) y **verificación post-copia** de ficheros clave con aviso. (Reescritura completa a `FileManager` descartada: riesgo de romper el merge sin poder testear.)
- [x] 🟠 **Disparo todo-o-nada** — **HECHO**: `copiarBase` ahora es incremental — copia por separado Xemu / Documents/Retroarch / Application Support solo si falta cada uno (repara instalaciones a medias).
- [x] 🟡 **Typo del centinela `/users/Shared/Xemu`** ([SplashController.swift:215](RetroMac/SplashController.swift:215)) — **HECHO**: normalizado a `/Users/Shared/Xemu`.
- ~~Adelgazar los 474 MB~~ — **descartado** (decisión: la Base se mantiene completa en el `.app`).
- ~~Mover `/Users/Shared` a `~/Library/...`~~ — **descartado**: `xemu.ini` hardcodea rutas absolutas a `/Users/Shared/Xemu` (flash/bootrom/hdd), que es independiente del usuario; moverla obligaría a reescribir `xemu.ini` por-usuario en cada arranque → rompe xemu. Se mantiene.

### C) Descargas de emuladores y cores (`downloadEmulators`, [funciones.swift:1279](RetroMac/funciones.swift:1279))
- [x] 🔴 **Cores ARM `http://http://`** ([funciones.swift:1307](RetroMac/funciones.swift:1307)) — **HECHO**: `https://…/arm64/latest/…`. Además X86 (dmg + cores) pasado de `http://` a `https://` ([1296](RetroMac/funciones.swift:1296)/[1299](RetroMac/funciones.swift:1299)).
- [x] 🔴 **Descargas desde Dropbox personal** — **HECHO**: reescrito `downloadEmulators` con infraestructura oficial (GitHub Releases API + Dolphin propio): `httpGETsync` (con User-Agent), `githubUltimoAsset`, `dolphinUltimoDmg`, `retroArchStableVersion`, `descargarYExtraer` (zip/tar.xz/7z/dmg). xemu (`xemu-project/xemu`), PCSX2 (`PCSX2/pcsx2`), RPCS3 (`RPCS3/rpcs3-binaries-mac`, .7z), Dolphin (API propia). Adiós Dropbox.
- [x] 🔴 **Citra → Azahar** — **HECHO**: descarga (`azahar-emu/azahar` universal → `Emuladores_Mac/Azahar/`); cfg del 3DS (bundle + runtime) → `Azahar.app/Contents/MacOS/azahar` (`<emu name="Azahar" core="azahar">`); config `~/Library/Application Support/Azahar/config/qt-config.ini` en `read/writeCitraConfig` (sin copiar config de Citra, con guarda anti-clobber si vacío); `contains("citra-qt")` → `contains("azahar")` en los 5 lanzadores (GridScreen, mainScreenGameController ×2, ListaViewController, NetPlayListController).
- [x] 🟠 **Cores: derivar del cfg (~110), no 200 hardcodeados** — **HECHO**: `coresDelCfg()` + fallback.
- [x] 🟠 **RetroArch: stable universal** — **HECHO**: `retroArchStableVersion()` resuelve la última (hoy 1.22.2) y baja `stable/<v>/apple/osx/universal/RetroArch_Metal.dmg` (cubre Intel+ARM).
- [x] 🟠 **Flujo robusto** — **HECHO (lo esencial)**: reintentos (`curl --retry 3 --retry-delay 2`), **auto-reparación** (baja SOLO lo que falta vía `carpetaTieneApp`), **aplanado de wrappers** (`aplanarSiAnidado` — arregla la `.app` anidada en carpeta versionada, p.ej. Azahar, que hacía re-descargar siempre y no lanzaba) y **borrado de `Descargas`** al final si los 6 emuladores quedaron instalados. Quitado el `mkdir Citra` inútil. *Diferido: descargas en paralelo y barra de progreso fina.*
- [x] 🟠 **Bezels: bundleados** — **HECHO**: carpeta `decorations` (1025 PNGs, 203 MB) añadida al proyecto como **folder reference** (igual que `Base`, para que conserve la carpeta en el `.app`; se corrigió de grupo sincronizado que podía aplanarla) + en Copy Bundle Resources. El código copia de `Contents/Resources/decorations` a `rutaApp/decorations/`. `.DS_Store` limpiados.
- [x] 🟠 **Binario `7zz` en el bundle** — **HECHO**: `7zz` universal (x86_64+arm64) en Copy Bundle Resources para descomprimir el .7z de RPCS3 (con `chmod +x` en runtime).
- [x] 🔴 **Ruta hardcodeada de otro usuario** en `noGameOverlay` ([funciones.swift:1066](RetroMac/funciones.swift:1066)) — **HECHO**: ahora relativa a `~/Documents/RetroMac/shaders/`.

### D) Estabilización (config y datos — bloque background de [SplashController.swift:227](RetroMac/SplashController.swift:227))
- [ ] 🔴 **`readRetroArchConfig` crashea** ([funciones.swift:908](RetroMac/funciones.swift:908)) — `preconditionFailure` si falta el cfg ([920](RetroMac/funciones.swift:920)/[926](RetroMac/funciones.swift:926)) y `myparams[1]` con líneas sin `=` ([960](RetroMac/funciones.swift:960)). Lectura tolerante, sin crashear.
- [ ] 🔴 **`mamelista` crashea** ([funciones.swift:261](RetroMac/funciones.swift:261)) — `try!` si falta `mamelist.txt` y `misvalores[1]` con líneas sin coma.
- [ ] 🟡 **`readCitraConfig` recursión infinita** ([funciones.swift:1215](RetroMac/funciones.swift:1215)) — si la copia de la Base falla, se llama a sí misma sin fin. Guardar el reintento.
- [ ] 🟡 **Datos estáticos en código** — `llenaSistemasIds` ([funciones.swift:13](RetroMac/funciones.swift:13)) y `NetPlayCores` ([funciones.swift:190](RetroMac/funciones.swift:190)) → ficheros de datos.
- [ ] 🟠 **Trabajo síncrono y sin feedback** — separar instalar/actualizar/cargar en `SplashController`; carga incremental con progreso real y estados de error con reintento (hoy o crashea o se cuelga en el Splash).

### E) Seguridad
- [ ] 🟠 **`NSAllowsArbitraryLoads=true`** (Info.plist) — quitarlo cuando todas las descargas sean HTTPS.

### ✅ Ya arreglado (fases previas)
- [x] cfg vacío → re-copia si falta o está vacío ([SplashController.swift:89](RetroMac/SplashController.swift:89)).
- [x] Ventana a `visibleFrame` (bajo la barra de menú).
- [x] Crashes `button!.numeroJuegos!` (teclado + mando).
- [x] Terminal de emuladores se cierra al salir del juego (no la del usuario).
- [x] `AppDelegate` ya no mata cualquier "Terminal"; fichero muerto borrado.
