import UIKit
import MuFlo


public class TestSkyFlo: NSObject {

    public static let shared = TestSkyFlo()
    public let root = Flo("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    private var floScriptNames = ["sky", "shader", "model",
                                  "menu", "plato", "cube",
                                  "menu.corner", "midi"]
    func parseScriptFiles() {
        for name in floScriptNames {
            MuMenuSky.parseFlo(root, name)
        }
    }
}
