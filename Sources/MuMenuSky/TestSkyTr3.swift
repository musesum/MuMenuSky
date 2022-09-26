import UIKit
import Tr3


public class TestSkyTr3: NSObject {

    public static let shared = TestSkyTr3()
    public let root = Tr3("√")

    override init() {
        super.init()
        parseScriptFiles()
    }

    func parseScriptFiles() {
        _ = MuMenuSky.parseTr3(root, "menu")
    }
}
