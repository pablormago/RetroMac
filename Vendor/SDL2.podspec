Pod::Spec.new do |s|
  s.name         = "SDL2"
  s.version      = "2.32.10"
  s.summary      = "SDL2 (Simple DirectMedia Layer) — solo para el subsistema de mandos (joystick/gamecontroller)."
  s.homepage     = "https://www.libsdl.org"
  s.license      = { :type => "zlib" }
  s.author       = "Sam Lantinga y colaboradores"
  # Binario oficial descargado de https://github.com/libsdl-org/SDL/releases/tag/release-2.32.10
  # (SDL2-2.32.10.dmg), universal x86_64+arm64. Pod local (:path en el Podfile) — el
  # framework ya está en este mismo directorio, `s.source` no se usa para descargar nada.
  s.source       = { :http => "https://github.com/libsdl-org/SDL/releases/download/release-2.32.10/SDL2-2.32.10.dmg" }
  s.osx.deployment_target = "10.13"
  s.vendored_frameworks = "SDL2.framework"
end
