import UIKit
import MuFlo


public class TestSkyFlo: NSObject {

    public static let shared = TestSkyFlo()
    public let root = Flo("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    private var scriptNames = ["sky", "shader", "midi",
                                  "model", "menu", "plato", "corner"]
    func parseScriptFiles() {
        for name in scriptNames {
            MuMenuSky.parseFlo(root, name)
        }
    }
}
