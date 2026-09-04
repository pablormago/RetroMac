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
- [x] 🟡 **Validar/versionar el cfg sin perder ediciones** — **HECHO**: nuevo `cfgEsValido()` (parsea `<system>`); el arranque recopia solo si el cfg falta/no es válido; y en cambio de versión ya **NO** se pisa el cfg del usuario (conserva sus selecciones de core que escribe `escribeSistemas`), solo se recopia si es inválido.
- [x] 🔴 **Merge de sistemas nuevos del bundle** — **HECHO** (`fusionarSistemasNuevos()`, [funciones.swift:1249](RetroMac/funciones.swift:1249)). Antes se descartó por miedo a pisar datos del usuario; el efecto secundario era grave: **un sistema nuevo de una versión posterior no llegaba NUNCA** a quien ya tuviera un cfg válido (model2/model3 habrían sido invisibles). La fusión es a nivel de **texto**: recorre los `<system>` del bundle e inserta solo los cuyo `<name>` no está en el cfg del usuario, antes de `</systemList>`. No toca ni una línea de los bloques existentes, así que las selecciones de core de `escribeSistemas` se conservan intactas. Se llama en [SplashController.swift:171](RetroMac/SplashController.swift:171), **antes de `downloadEmulators()`**, porque `coresDelCfg()` lee el cfg del usuario y así se bajan también los cores de los sistemas recién añadidos.

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
- [x] 🔴 **`readRetroArchConfig` crashea** — **HECHO**: reescrito con lectura segura (`String(contentsOf:)`) y **parseo tolerante** (salta vacías/comentarios/líneas sin `=`; el valor conserva los `=` posteriores). Sin `preconditionFailure`.
- [x] 🔴 **`mamelista` crashea** — **HECHO**: lectura con `try?` (UTF-8 con fallback isoLatin1) y se saltan líneas sin coma en vez de romper por índice.
- [x] 🟡 **`readCitraConfig` recursión infinita** — **HECHO** (en la migración a Azahar): sin recursión ni copia de config; además ya no duplica saltos de línea.
- [x] 🔴 **Todos los `preconditionFailure`, `try!` y lectores C** — **HECHO**: 0 `preconditionFailure`, 0 `fopen/getline`, 0 `try!` en toda la app (escrituras a `try?`). La versión de `RetroMac.txt` también se lee de forma segura.
- [x] 🔴 **12 `FileManager.enumerator(atPath:)!`** — **HECHO**: ahora opcionales con `enumerator?.nextObject()`; si la carpeta no existe/no se puede leer, el bucle no itera en vez de crashear (p.ej. sistema del cfg cuya carpeta de ROMs ya no está). `shadersList` reescrito sin `folder!`.
- [x] 🟠 **Sin feedback de error** — **HECHO (lo esencial)**: si tras cargar no hay ningún sistema, se muestra un aviso explicando que no se pudo leer el cfg (antes: app vacía y silencio). *(Diferido: reestructurar Splash en instalar/actualizar/cargar con progreso fino — alto riesgo, poco valor añadido ahora.)*
- [ ] 🟡 **Datos estáticos en código** — `llenaSistemasIds` / `NetPlayCores` → ficheros de datos. **RECOMENDACIÓN: no hacerlo.** Los datos casi no cambian, y moverlos al bundle añade una dependencia de recurso y un modo de fallo nuevo (fichero ausente → sin ids) a cambio de nada funcional.

### E) Seguridad
- [x] 🟠 **`NSAllowsArbitraryLoads=true`** — **HECHO**: quitado el permiso general. Todas las descargas ya son HTTPS; la única excepción acotada es `lobby.libretro.com` (NetPlay), que **no soporta HTTPS** (comprobado: https da timeout, http responde 200), vía `NSExceptionDomains`.

### F) Vuelta a fondo de rendimiento y honestidad de la UI (tras pruebas reales)
Síntomas reportados: *"pone Comprobando cores mientras descarga"*, *"en los siguientes arranques la
comprobación es eterna"*, *"descarga cores que ya tenía"*. Diagnóstico con datos: **96 cores
instalados vs 105 que pide el cfg** → esos **9 que no existen en el buildbot se reintentaban en CADA
arranque**, lentos por `--retry 3 --retry-delay 2`, con la etiqueta congelada.

- [x] **Cores: separar COMPROBAR de DESCARGAR** — fase 1 calcula qué falta (instantánea); fase 2 solo
  se ejecuta si falta algo, con progreso real `n/total — nombre-del-core`.
- [x] **CAUSA RAÍZ de los "cores que fallan" — era un bug de extracción, no cores malos.**
  `coresDelCfg()` sacaba nombres del atributo `core="…"`, que es la **etiqueta del selector**, no un
  nombre de fichero (p. ej. `core="vice_x64sc accurate"`, con espacio). Y la regex `[A-Za-z0-9_]+`
  **no admitía guiones**, así que partía `mesen-s_libretro.dylib` y se quedaba con `s`.
  **Corregido**: los nombres salen SOLO de los `…_libretro.dylib` de los `<command>` (los ficheros
  reales), admitiendo guiones. Cores requeridos: 105 fantasma → **96 reales**.
- [x] **Nada de blacklists silenciosos** — se descartó ocultar los cores que fallan (tapaba el bug de
  arriba). Ahora, si un core del cfg no se puede descargar, **se avisa al usuario** al terminar la
  carga con la lista exacta y el motivo (`coresNoDescargados`), para que decida.
- [x] **Corregidos 6 nombres erróneos del cfg** (verificados uno a uno contra el buildbot), en el cfg
  del bundle y en el de `~/Documents`: `mednafen_supergraf`→`mednafen_supergrafx`,
  `fbalpha2012_core`→`fbalpha2012`, `mesen_svn`→`mesen`, `vbam_next`→`vba_next`,
  `duckstation`→`swanstation` (renombrado por libretro). Y **eliminado el sistema `freej2me`
  ("Java Games")** entero: su único core no tiene build para macOS. 95 → 94 sistemas, XML válido.
- [x] **curl más rápido** — `-s --connect-timeout 10 --retry 1` en vez de `--retry 3 --retry-delay 2`
  (un 404 no es reintentable, solo hacía perder segundos por core).
- [x] **Etiquetas honestas en todo el arranque** — "Buscando X…" mientras se resuelve la URL (red) y
  "Descargando X…" mientras baja; y pasos que antes iban mudos ahora informan: lista MAME, datos de
  sistemas, config de RetroArch, shaders, preferencias, "Buscando juegos…". El Splash ya no arranca
  mintiendo con "Cargando Sistemas".
- [x] **Lista de MAME perezosa** — `mamelist.txt` (1,3 MB / **30.444 líneas**) se parseaba en CADA
  arranque y **solo la usan los scrapers**. Ahora se carga bajo demanda (`asegurarTitulosMame()`).
- [x] **Caché de listados de carpeta** (`listadoCacheado`) — las 7 funciones `busca*` (imagen, vídeo,
  manual, box, marquee, fanart, tittleshot) hacían **una enumeración recursiva completa de la carpeta
  del sistema por cada una y por cada juego nuevo** (7 escaneos por juego). Ahora se enumera **una vez
  por carpeta** y se reutiliza; el caché se vacía al empezar cada sistema.
- [x] Limpieza: eliminadas 7 declaraciones `let fileManager` que quedaban sin uso.

### G) Sistemas que no se podían cargar — alternativas para macOS

Investigación de los **11 directorios de ROMs sin sistema** en `/Volumes/Pablo/BoB/Bobwin/roms`
(verificado contra el buildbot de libretro —225 cores x86_64 / 215 arm64— y la API de GitHub, 04-09-2026).

**Añadidos (decisión del usuario: model2 y model3):**
- [x] 🟠 **`model3`** → core `supermodel_libretro` (x86_64 1,27 MB · arm64 1,22 MB). Verificado:
  el `.dylib` de x86_64 es Mach-O x86_64 real. `coresDelCfg()` lo detecta solo y lo descarga.
- [x] 🟠 **`model2`** → core `mame_libretro` (driver `segam2`). Coste de descarga **cero**: ese core
  ya estaba en el cfg por el sistema `mame`. ⚠️ **Reserva**: los 19 `.zip` de la BoB son romsets del
  *Model 2 Emulator* (Nebula), no de MAME; puede que no arranquen sin romsets en formato MAME.
- [x] 🔴 **Crash al añadir cualquier sistema sin logo** ([ViewController.swift:299](RetroMac/ViewController.swift:299)
  y [ListaViewController.swift:319](RetroMac/ListaViewController.swift:319)) — `NSImage(byReferencingFile:)!`
  con force-unwrap explotaba **antes** del `if fileDoesExist` que venía justo debajo. Ya había
  **18 sistemas del cfg sin logo** (`cdi`, `dos`, `lynx`, `sfc`, `tic-80`…): era un crash latente.
  Ahora es `fileExists` + `if let`, y sin logo el botón se queda con el título.
- [x] 🟡 **IDs de ScreenScraper** para los nuevos en `llenaSistemasIds()`: `model2` = **54**,
  `model3` = **55** (confirmados en las URLs `plateforme=` de screenscraper.fr). Sin ellos el
  scraper enviaría `systemeid` vacío.
- [x] 🟡 **Logos** — **HECHO**, y de paso repasado el set entero: había **20 de 106 sistemas sin
  logo**, no solo model2/model3. Ahora quedan **104/106**.
  - **5 traídos del tema `Carbon BOB`** de la instalación de RetroBat: `model2`, `model3`, `cdi`,
    `fbn` (de `fbneo.svg`) y `atarijaguarcd` (PNG directo).
  - **13 eran fallos de nombre, no logos ausentes**: el app busca el PNG por `<name>`, pero el
    nombre bueno está en `<theme>` (`dos`→pc, `jaguar`→atarijaguar, `lynx`→atarilynx,
    `o2em`→odyssey2, `wswanc`→wonderswancolor, `tic-80`→tic80, `n3ds`→3ds, `sfc`→snes,
    `sc-3000`/`sg-1000`→sg1000, `amiga600`→amiga, `atarixe`→atari800, `chailove`→love).
    Duplicados con el nombre del sistema. **De estos, 5 sí tenían ROMs en el disco del usuario**
    (`dos` 272, `o2em` 190, `lynx` 91, `wswanc` 83, `jaguar` 29): salían sin logo por esto.
  - **Conversión SVG→PNG**: el tema guarda 255 logos en SVG. `sips` (ImageIO) rasteriza algunos
    mal —`model3` salía recortado— así que se usa el renderizador de QuickLook (WebKit), que sí
    los dibuja bien pero aplana sobre blanco. Se renderiza **dos veces, sobre blanco y sobre
    negro**, y se recupera el alfa exacto (`a = 1 − (Cblanco − Cnegro)`, `color = Cnegro / a`),
    incluido el antialias; luego se recorta el relleno. Script en el scratchpad (`svg2png.py` +
    `pngcrop.py`, PNG en Python puro: esta máquina no tiene PIL ni ImageMagick).
  - **Quedan 2 sin logo**: `karaoke` y `supervision`. No existen en el tema de BOB ni en el set
    del app, y **ninguno tiene ROMs** (0 ficheros), así que no llegan al carrusel. No los invento.
  - `themes` es una *folder reference* en el pbxproj, así que los PNG nuevos entran al bundle
    solos, sin tocar el proyecto.

**Descartados, con el motivo:**
| Sistema | Veredicto |
|---|---|
| `wiiu` | Core `cemu_libretro` existe (9,9 MB, ambas arch) pero el propio Cemu declara macOS *"purely experimental"* (MoltenVK + Rosetta). El standalone oficial `cemu-2.6-macos-12-x64.dmg` es **x64**. |
| `ports` | Cores `2048`/`craft`/`gong` disponibles, pero los ficheros son `.libretro` (texto con el nombre del core, sin contenido) → exige código nuevo en el lanzador: leer el `.libretro` y arrancar RetroArch con `-L core` y **sin ROM**. |
| `switch` | Ryubing (fork de Ryujinx) sí tiene builds macOS, pero **la distribución salió de GitHub** a su GitLab propio: `Ryubing/Ryujinx` y `Ryubing/Stable-Releases` → *Not Found*, `git.ryujinx.app/api/v4` → 404. No automatizable. |
| `openbor` | [DCurrent/openbor](https://github.com/DCurrent/openbor) v7533 publica Android/Linux/Windows, **ningún asset macOS**. El port `sasus470/OpenBor_on_mac` no trae binarios en sus releases (hay que compilar). No hay core `openbor` en el buildbot. |
| `triforce` | Dolphin fusionó Triforce en mainline en 2026 tras el fork de crediar, pero **solo Windows/Linux y Android; aún no en los builds macOS**. |
| `xbox360` | Xenia es Windows + Direct3D 12 exclusivamente. |
| `windows`, `PinballFX` | Ejecutables Windows lanzados por RetroBat → requerirían Wine/CrossOver. Fuera del alcance. |

**Standalone Supermodel: descartado por incompatible con esta máquina.** [trzy/Supermodel](https://github.com/trzy/Supermodel)
publica un `…-macos.tar.gz` actualizado (v0.3a-20260726, 6,5 MB) y sería trivial de integrar, pero al
extraerlo el binario resulta ser **`Mach-O 64-bit executable arm64`** — y este Mac es un
**Intel Core i5-5257U (x86_64)**. Ninguna release tiene un asset macOS x86_64. Además **no es un
`.app`**, sino un binario suelto con `Frameworks/`, así que `carpetaTieneApp()` lo daría siempre por
no instalado y `downloadEmulators()` lo re-descargaría en cada arranque. Se queda solo el core libretro.

### H) Emuladores que NO son RetroArch — config y línea de comandos

Repaso de los 5 emuladores standalone del cfg (Dolphin, Azahar, xemu, PCSX2, RPCS3).
Punto de partida: RetroArch va al 100 %, xemu y Azahar "han perdido la config", el resto sin probar.

**H1 · xemu no lee la config del bundle: el formato está muerto** 🔴 — **ARREGLADO**
La Base enviaba `ApplicationSupport/xemu/xemu/xemu.ini`. xemu abandonó el INI: desde 0.7.90 lee
**solo `xemu.toml`**. La propia ejecución lo dice: `config path: …/xemu/xemu/xemu.toml`. Y no es
solo el formato — cambió cada clave y cada sección:

| `xemu.ini` (bundle) | Valor | Equivalente actual | |
|---|---|---|---|
| `[system] flash_path` | Complex_4627.bin | `[sys.files] flashrom_path` | renombrada |
| `[system] bootrom_path` | mcpx_1.0.bin | `[sys.files] bootrom_path` | otra sección |
| `[system] hdd_path` | xbox_hdd.qcow2 | `[sys.files] hdd_path` | otra sección |
| `[system] memory` | **128** | `[sys] mem_limit = '128'` | por eso arrancaba con `-m 64` |
| `[system] shortanim` | false | `[general] skip_boot_anim` | |
| `[system] hard_fpu` | true | `[perf] hard_fpu` | |
| `[display] scale` | `scale_ws169` | `[display.ui] aspect_ratio` | **ese valor ya no existe** |
| `[display] ui_scale` / `render_scale` | 1 | `[display.ui] scale` / `[display.quality] surface_scale` | |
| `[input] controller_1_guid` | keyboard | `[input.bindings] port1` | |
| `[network] enabled` / `backend` | true / **`user`** | `[net] enable` / `[net] backend` | **`user` ahora es `nat`** |
| `[network] local_addr` / `remote_addr` | | `[net.udp] bind_addr` / `remote_addr` | |
| `[misc] check_for_update` | | `[general.updates] check` | |

Sustituido por un `xemu.toml` escrito contra el esquema oficial (`config_spec.yml` del repo de xemu),
con solo los valores que difieren del default. `eeprom_path` se deja sin poner a propósito: el default
es `<base>/eeprom.bin`, justo donde la Base deja su `eeprom.bin`, y fijarlo obligaría a escribir
`/Users/<usuario>/…`, que no es portable.

**H2 · `copiarBase()` no reparaba nada salvo RetroArch** 🔴 — **ARREGLADO**
Los tres bloques colgaban de un único guard: `if !existe ~/Library/Application Support/RetroArch`.
Con RetroArch ya instalado, el bloque entero se saltaba y **xemu y PCSX2 no recibían ni recuperaban
jamás su config**. Ahora hay un guard por bloque, cada uno mirando un fichero real
(`xbox_hdd.qcow2`, `retroarch.cfg`, `xemu.toml`, `PCSX2/inis`).

**H3 · `cp -r origen destino` anidaba en vez de fusionar** 🟠 — **ARREGLADO**
Con el destino ya existente, BSD `cp -r` mete la carpeta DENTRO. Resultado real en el disco del
usuario: `/Users/Shared/Xemu/Xemu/` con las tres BIOS duplicadas. Ahora se usa `cp -r origen/. destino/`
(helper `fusionar`) y se borró el duplicado.

**H4 · La config de Azahar del bundle nunca ha existido para la app** 🟠 — **ARREGLADO**
El bundle traía `Base/.config/citra-emu/qt-config.ini` y `copiarBase()` **no copia `.config`** —
solo `Shared/Xemu`, `Documents/Retroarch` y `ApplicationSupport/`. Aunque la copiara: era config de
**Citra** (sin las claves de Azahar), con rutas de **Linux** (`~/.local/share/citra-emu/nand/`) y con
una ruta muerta personal dentro (`~/Downloads/…/Mundo R`). Borrada del bundle. Azahar se genera su
`qt-config.ini` correcto solo, y `readCitraConfig`/`writeCitraConfig` ya apuntan ahí y no escriben si
aún no existe.

**H5 · PCSX2 se instalaba con un nombre que el cfg no puede lanzar** 🔴 — **ARREGLADO**
En el disco estaba `Pcsx2/PCSX2-v2.8.1.app`, pero el cfg lanza `Pcsx2/PCSX2.app/…`. **PS2 no podía
arrancar nunca**, y `carpetaTieneApp()` la daba por instalada, así que ni se reintentaba — y el nombre
cambia con cada versión. Nuevo `normalizarNombreApp(destino:esperado:)`: tras extraer, renombra la
`.app` al nombre exacto del cfg. `instalarEmulador` ahora recibe ese nombre y comprueba **esa** `.app`,
no "hay alguna `.app`"; la limpieza final de `Descargas` también.

**H6 · Argumentos de línea de comandos verificados contra el código fuente de cada emulador**

| Emulador | Comando anterior | Veredicto |
|---|---|---|
| **xemu** | `-dvd_path %ROM% -full-screen` | ✅ correcto — `-full-screen` es opción estándar de QEMU (`qemu-options.hx:2477`), `-dvd_path` es de xemu |
| **Azahar** | `azahar %ROM%` | ✅ correcto |
| **Dolphin** | `--exec=%ROM%` | ⚠️ funcionaba pero dejaba la GUI abierta → **añadido `-b`** (batch: sin interfaz y sale al terminar el juego, que es lo que espera `lanzarJuegoYcerrarTerminal`) |
| **PCSX2** | `%ROM% --nogui --fullscreen` | ❌ **roto**: `CHECK_ARG` es igualdad exacta y cualquier `-x` desconocido lanza un diálogo *"Unknown parameter"* y aborta → **`-nogui -fullscreen -- %ROM%`** (uso documentado: `[parámetros] [--] [fichero]`) |
| **RPCS3** | `%ROM% -fullscreen --no-gui` | ❌ **roto**: usa `QCommandLineParser`, las opciones largas llevan doble guion; `-fullscreen` se lee como opciones cortas agrupadas → **`--no-gui --fullscreen %ROM%`** |

**Limitación conocida**: `fusionarSistemasNuevos()` solo AÑADE sistemas que faltan; no actualiza los
bloques existentes. Un arreglo de comando en el cfg del bundle **no llega** a quien ya tiene ese
sistema. Por eso estos tres se han parcheado también a mano en `~/Documents/RetroMac/es_systems_mac.cfg`.
Pendiente decidir si conviene un mecanismo de actualización de comandos que respete el core elegido.

**H7 · Verificación ejecutando los binarios reales** (carpeta `Build/Products/Debug` de Xcode)

Prueba A/B con los flags viejos y los nuevos, sobre los emuladores instalados de verdad:

| Prueba | Resultado |
|---|---|
| PCSX2 **viejo** `ROM --nogui --fullscreen` | `exit=142` — **colgado 20 s** sin salida: el diálogo modal *"Unknown parameter"* esperando un clic. Y `Commands.Bash.system` bloquea hasta que se cierre. |
| PCSX2 **nuevo** `-nogui -fullscreen -- ROM` | `exit=0`, salida limpia (con `-testconfig`). ✅ |
| RPCS3 **viejo** `ROM -fullscreen --no-gui` | `exit=1` → `RPCS3: Unknown options: f, u, l, l, s, c, r, e, e, n.` — Qt leyendo `-fullscreen` como opciones cortas agrupadas, tal cual se predijo. |
| RPCS3 **nuevo** `--no-gui --fullscreen ROM` | Entra en el emulador (imprime build, "Emulation is stopped"). ✅ |
| Dolphin **nuevo** `-b --exec=ROM` | Aceptado. Control: `--flaginventado` → `Dolphin: error: no such option` inmediato, así que la prueba discrimina. ✅ |
| xemu `-dvd_path ROM -full-screen` | Arranca y construye bien los parámetros de QEMU. ✅ |

`xemu.toml` de la Base validado clave por clave contra `config_spec.yml` del repo de xemu:
las 9 claves existen y los 3 enums (`sys.mem_limit='128'`, `display.ui.aspect_ratio='16x9'`,
`net.backend='nat'`) están dentro de los valores permitidos.

Simulados además los 7 comandos finales (`rutaApp` + `<command>`, `%CORE%`→`rutaApp`, `%ROM%`
entrecomillada) para 3ds, gamecube, ps2, ps3, wii, xbox y n3ds: **los 7 resuelven a un binario que
existe** y el entrecomillado aguanta rutas con espacios.

**Lo único sin probar**: arrancar un juego de verdad. No hay ROMs de `ps2`, `ps3`, `gamecube`, `wii`,
`3ds` ni `xbox` — ni en el disco externo ni en `Build/Products/Debug/roms`, que solo tiene
`mame/shinobi.zip` y `neogeo/mslug.zip` (ambos de RetroArch).

### H8) Prueba con ROMs reales del disco del usuario — resultado por emulador

Con el disco `/Volumes/Pablo/BoB/Bobwin` montado, lanzados los comandos EXACTOS que construye
el cfg contra una ROM real de cada sistema no-RetroArch.

**Dolphin (GameCube/Wii) — bug real encontrado y corregido** 🔴
`-b --exec=%ROM%` (el flag ya arreglado en H6) carga el título pero la CPU se queda muerta al
2-3 % y no aparece ninguna ventana: **el backend de vídeo por defecto de Dolphin en esta máquina
(Metal) se cuelga silenciosamente**, sin error en el log. Prueba objetiva —`TimePlayed.ini`, que
Dolphin solo incrementa mientras emula de verdad—: con Metal quedó en 0. Forzando **Vulkan**
(`-v Vulkan`), CPU al 37-46 % y el contador saltó de **28 ms a 30 035 ms** tras 30 s de ejecución
real (y un título nuevo de Wii registrado en la segunda prueba). **Comando final**:
`-b -v Vulkan --exec=%ROM%`, aplicado a `gamecube` y `wii` en ambos cfg.

**PCSX2 — confirma el fix de H6** ✅
Con `-nogui -fullscreen -- %ROM%` ya no se cuelga (antes: diálogo modal *"Unknown parameter"*
bloqueando `Commands.Bash.system` para siempre). Arranca, carga el motor de entrada, y se detiene
de forma **limpia y esperada**: `bios` está vacío en `~/Library/Application Support/PCSX2/bios/`.
No hay ninguna BIOS de PS2 instalada — **no la puede bundlear la app**, es firmware de Sony con
copyright; el usuario tiene que volcarla de su propia consola. RetroMac no puede hacer nada aquí
salvo, quizás, detectar la carencia y avisar en vez de dejar que el emulador se quede esperando.

**RPCS3 — confirma el fix de H6, y de paso se detectó un fallo de MI prueba manual** ✅
Con `--no-gui --fullscreen %ROM%` ya no hay `Unknown options: f,u,l,l,s,c,r,e,e,n` (antes, H7).
Al probar con la ruta del disco físico (`PS3_DISC.SFB`) dio *"Invalid file or folder"* — pero es
porque para PS3 el "rom" es la **carpeta** `NombreDelJuego.ps3` entera (extensión de carpeta,
convención RetroBat/Batocera), no un fichero suelto dentro; con la ruta de carpeta correcta el
error de ruta desaparece y solo queda `Missing Firmware` — igual que PCSX2: firmware de Sony
(`PS3UPDAT.PUP`), no se puede bundlear, el propio RPCS3 tiene un instalador de firmware integrado
que el usuario debe correr una vez.

**Azahar — comando correcto, bloqueado por falta de archivos de sistema** ✅ (comando) / 🟡 (dato)
`azahar %ROM%` carga bien la config Vulkan y arranca el boot, pero el log da
`Core::Load: Failed to determine system mode (Error 8)!`. Es el equivalente de una BIOS para 3DS:
archivos de sistema (NAND/CFG) que Azahar necesita volcar de una consola real o generar desde su
propio menú de "System Settings" — no viene con la ROM ni se puede bundlear (son de Nintendo).

**xemu — funciona** ✅ (verificado con evidencia indirecta, ver nota)
Con la ROM real de Xbox (`Smashing Drive/default.xbe`) CPU al 152 % sostenido y una ventana real
en pantalla (640×508, confirmado por `CGWindowListCopyWindowInfo`, no solo por CPU). El log
construye bien los parámetros de QEMU con el BIOS/bootrom/HDD de la Base. No se pudo hacer captura
de pantalla del contenido (el terminal de este entorno no tiene permiso de Screen Recording), pero
la ventana real + la CPU sostenida son evidencia suficiente de ejecución genuina (a diferencia de
Dolphin+Metal, que también "parecía vivo" con CPU baja y sin avanzar nada).

**Conclusión**: los 6 flags de línea de comandos (H6) están verificados y correctos contra binarios
reales. El único bug de código nuevo encontrado en esta ronda fue **Dolphin necesitando forzar
Vulkan** (ya corregido). Los bloqueos restantes —BIOS de PS2, firmware de PS3, archivos de sistema
de 3DS— son limitaciones legales de cada emulador, no bugs de RetroMac: son ficheros con copyright
que cada usuario debe aportar. Pendiente de decidir: ¿merece la pena que la app detecte su ausencia
y muestre un aviso en vez de dejar que el emulador se quede esperando en silencio?

### H9) Citra vuelve a como estaba — decisión del usuario, no un bug

En la fase A/B/C se migró Citra (descontinuado) a Azahar. Pablo ha pedido revertir ESA parte
en concreto: *"En 3DS antes con citra... hacia que funcionara"* — y con razón: Azahar quitó a
propósito el soporte de ROMs **encriptadas** (`.3ds`/`.cci` sin descifrar) como defensa legal,
igual que le pasó a Yuzu — es literalmente el mecanismo por el que demandaron a Citra. Verificado
sin descifrar nada, solo leyendo la cabecera NCSD (byte `NoCrypto` en 0x18F): `Shovel Knight.3ds`
y `Pullblox.3ds`, las dos ROMs 3DS del usuario, están **cifradas**. Con Azahar no arrancarían nunca,
sea cual sea el arreglo de código — es un rechazo deliberado del formato, no un fallo.

Revertido tal cual estaba antes de `af26279`, decisión del usuario:
- `downloadEmulators()`: Citra vuelve a descargarse del enlace personal de Dropbox
  (`dl.dropboxusercontent.com/…/citra.zip`, verificado vivo y con `citra-qt.app` sin carpeta
  wrapper), no desde GitHub Releases de Azahar (cuyo sucesor real dejó de servir lo que el
  usuario necesita).
- Carpeta `Emuladores_Mac/Citra`, binario `citra-qt.app/Contents/MacOS/citra-qt`.
- `readCitraConfig()`/`writeCitraConfig()`: vuelven a `~/.config/citra-emu/qt-config.ini`
  (antes: `~/Library/Application Support/Azahar/…`), con el mecanismo original de copiar la
  plantilla de la Base si aún no existe — pero manteniendo la lectura segura (`String(contentsOf:)`
  + `try?`) en vez del `fopen`/`getline`/`preconditionFailure` original, que sí era un bug de
  verdad ya corregido en una fase anterior y no tiene que ver con la elección de emulador.
- Restaurado `Base/.config/citra-emu/qt-config.ini` y `telemetry_id` (los había borrado yo en
  H4 por parecerme dead weight con rutas de Linux; el usuario decide mantenerlos tal cual).
- Los 6 sitios que miraban `comandojuego.contains("azahar")` (5 pantallas de lanzamiento +
  NetPlay) vuelven a `contains("citra-qt")`.
- `es_systems_mac.cfg` (bundle y `~/Documents`): `3ds` y `n3ds` vuelven a
  `/Emuladores_Mac/Citra/citra-qt.app/Contents/MacOS/citra-qt %ROM%`.

**Verificado con el binario real** descargado del enlace: `citra-qt` (Mach-O x86_64, sin arm64 —
esta build de 2022 es solo Intel) arranca `Shovel Knight.3ds` (cifrada) sin problema. Su propio
log (`~/.local/share/citra-emu/log/citra_log.txt`) muestra el DSP de audio inicializado y frames
renderizados durante más de 30 s, sin ningún error de "Error 8" ni de encriptación — confirma
exactamente lo que decía el usuario: con Citra y su config, esta ROM sí funcionaba.

### H11) xemu no abre la ROM de Xbox de la BoB — formato, no bug

Diagnóstico pedido explícitamente: mirar el formato de la ROM antes de tocar nada.

`roms/xbox/Smashing Drive/` **no contiene ningún disco de Xbox**, contiene un disco ya
**extraído/desempaquetado**: `default.xbe` (el ejecutable, suelto) + `diskimg/` con los assets
del juego como ficheros `.wad` sueltos (`common.wad`, `roms.wad`, `system.wad`…). No hay ningún
`.iso`/`.xiso` en ningún sitio de la carpeta.

Según la **documentación oficial de xemu** (xemu.app/docs/disc-images): *"xemu requires game discs
to be in the form of xiso images"* — exige estrictamente una imagen XISO empaquetada para
`-dvd_path`; no admite ni un `.xbe` suelto ni una carpeta con los ficheros ya extraídos.

Esto explica el síntoma exacto: el escáner del cfg coge `default.xbe` (única entrada que coincide
con `<extension>.xbe .iso</extension>`), xemu lo monta como si fuera el CD-ROM y arranca el
ejecutable (por eso había CPU alta y una ventana real en la prueba de H8), pero en cuanto el juego
intenta leer un asset del "disco" (los `.wad` de `diskimg/`) no hay ningún sistema de ficheros ahí
— solo los bytes crudos del `.xbe`.

**No es un bug de RetroMac ni de xemu**: la carpeta extraída es el resultado de haber pasado la
ROM original por `extract-xiso -x` (o equivalente) sin el paso final de reempaquetado
(`extract-xiso -c` / `xdvdfs-cli`) en una única imagen `.iso`.

**Decisión del usuario**: por ahora no se toca — ni reempaquetado automático en la app ni cambios
de código. Queda documentado como limitación conocida por si se retoma más adelante. Si se retoma,
las dos vías evaluadas fueron: (a) detectar carpetas sin `.iso`/`.xiso` y reempaquetar automático
la primera vez con `xdvdfs-cli` (open source), cacheando el resultado; (b) exigir que las ROMs de
Xbox en la BoB del usuario vengan ya empaquetadas.

### ✅ Ya arreglado (fases previas)
- [x] cfg vacío → re-copia si falta o está vacío ([SplashController.swift:89](RetroMac/SplashController.swift:89)).
- [x] Ventana a `visibleFrame` (bajo la barra de menú).
- [x] Crashes `button!.numeroJuegos!` (teclado + mando).
- [x] Terminal de emuladores se cierra al salir del juego (no la del usuario).
- [x] `AppDelegate` ya no mata cualquier "Terminal"; fichero muerto borrado.
