import UIKit
import MuFlo


public class TestSkyFlo: NSObject {

    public static let shared = TestSkyFlo()
    public let root = Flo("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    func parseScriptFiles() {
        _ = MuMenuSky.parseFlo(root, "menu")
        _ = MuMenuSky.parseFlo(root, "model")
    }
}
