# Uncomment the next line to define a global platform for your project
 #platform :osx, '10.5'

target 'RetroMac' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RetroMac
pod 'Commands',        '~> 0.6.0'
# SDL2 solo para leer mandos que GameController.framework no reconoce (ver
# SDLControllerManager.swift) — framework binario oficial vendorizado en Vendor/,
# no viene de ningún spec repo remoto.
pod 'SDL2', :path => 'Vendor'
workspace 'RetroMac'

end

# Xcode 26 ya no incluye libarclite: forzamos los Pods a macOS 10.13+ para no necesitarlo
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.13'
    end
  end
end
