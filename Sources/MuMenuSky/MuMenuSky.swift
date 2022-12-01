//  Created by warren on 8/10/22.

import Foundation
import Tr3
import MuSkyTr3

public struct MuMenuSky {

    public static let bundle = Bundle.module

    public static func read(_ filename: String,
                            _ ext: String) -> String? {

        guard let path = Bundle.module.path(forResource: filename, ofType: ext)  else {
            print("🚫 MuMenuSky couldn't find file: \(filename).\(ext)")
            return nil
        }
        do {
            return try String(contentsOfFile: path) }
        catch {
            print("🚫 MuMenuSky::\(#function) error:\(error) loading contents of:\(path)")
        }
        return nil
    }

    static public func parseTr3(_ root: Tr3,
                                _ filename: String,
                                _ ext: String = "tr3.h") -> Bool {
        
        guard let script = MuSkyTr3.read(filename, ext) ?? read(filename, ext) else {
            return false
        }
        let success = Tr3Parse().parseScript(root, script)
        print(filename + (success ? " ✓" : " 🚫 parse failed"))
        return success
    }

    static public func mergeTr3(_ root: Tr3,
                                _ filename: String,
                                _ ext: String = "tr3.h") -> Bool {


        guard let script = MuSkyTr3.read(filename, ext) ?? read(filename, ext) else {
            return false
        }
        return mergeScript(root, script)
    }
    static public func mergeScript(_ root: Tr3,
                                   _ script: String) -> Bool {

        let mergeTr3 = Tr3("√")
        let success = Tr3Parse().parseScript(mergeTr3, script)
        if success {
            mergeNow(mergeTr3, with: root)
        }
        return success
    }

    static func mergeNow(_ mergeTr3: Tr3, with root: Tr3) {
        if let dispatch = root.dispatch?.dispatch,
           let (tr3,_) = dispatch[mergeTr3.hash],
           let mergeVal = mergeTr3.val,
           let tr3Val = tr3.val {

            _ = tr3Val.setVal(mergeVal)
        }
    }


}
