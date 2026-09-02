//
//  PhotoItem.swift
//  RetroMac
//
//  Reconstruido: item de la NSCollectionView del GridScreen.
//  Muestra la imagen del juego, un reproductor de vídeo superpuesto
//  (oculto por defecto) y el nombre del juego. Reacciona al doble clic.
//

import Cocoa
import AVKit
import AVFoundation

class PhotoItem: NSCollectionViewItem {

    // MARK: Outlets del .xib
    // `imageView` se hereda de NSCollectionViewItem y se conecta en el .xib.
    @IBOutlet weak var gameLabel: NSTextField!

    // MARK: Reproductor de vídeo
    // Se crea en código para no depender del framework AVKit dentro del .xib.
    var playerItem: AVPlayerView?

    // MARK: Doble clic
    var doubleClickActionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor

        // Reproductor superpuesto sobre la imagen, oculto hasta que haya vídeo.
        let player = AVPlayerView()
        player.controlsStyle = .none
        player.videoGravity = .resizeAspect
        player.translatesAutoresizingMaskIntoConstraints = false
        player.isHidden = true

        if let imageView = imageView {
            view.addSubview(player, positioned: .above, relativeTo: imageView)
            NSLayoutConstraint.activate([
                player.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                player.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                player.topAnchor.constraint(equalTo: imageView.topAnchor),
                player.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
            ])
        } else {
            player.frame = view.bounds
            player.autoresizingMask = [.width, .height]
            view.addSubview(player)
        }

        self.playerItem = player
    }

    // Resalta el item seleccionado (navegación por teclado / mando).
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 4.0 : 0.0
            view.layer?.borderColor = NSColor.white.cgColor
            view.layer?.cornerRadius = 6.0
        }
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if event.clickCount == 2 {
            doubleClickActionHandler?()
        }
    }
}
