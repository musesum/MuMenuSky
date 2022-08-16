import UIKit
import Tr3

class SkyTr3: NSObject {
    
    static let shared = SkyTr3()
    public let root = Tr3("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    func parseScriptFiles() {

        func parseFile(_ fileName: String) {
            let _ = MuMenuSky.parseTr3(root, fileName)
        }
        
        // parseFile("mu.sky")
        // parseFile("mu.shader")
        parseFile("mu.menu")
        // parseFile("mu.midi")

        // print(root.makeTr3Script(indent: 0, pretty: false))
    }
}
