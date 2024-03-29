import UIKit
import MuFlo


public class SkyFlo: NSObject {

    public static let shared = SkyFlo()
    public let root = Flo("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    private var scriptNames = ["sky", "shader", "midi",
                                  "model", "menu", "plato", "cube"]
    func parseScriptFiles() {
        for name in scriptNames {
            MuMenuSky.parseFlo(root, name)
        }
    }
}
