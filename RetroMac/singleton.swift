import Foundation
import Cocoa

class SingletonState {
    static let shared = SingletonState()
    private init(){}
    var currentViewController: NSViewController?
    var myscroller: NSScrollView?
}
