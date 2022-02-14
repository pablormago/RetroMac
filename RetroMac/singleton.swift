import Foundation
import Cocoa
import AVKit
import AVFoundation

class SingletonState {
    static let shared = SingletonState()
    private init(){}
    var currentViewController: NSViewController?
    var myscroller: NSScrollView?
    var mytable: NSTableView?
    var myJuegosXml: [[String]]?
    var mySnapPlayer : AVPlayerView?
    var myBackPlayer: AVPlayerView?
    var mySystemLabel: NSTextField?
}
