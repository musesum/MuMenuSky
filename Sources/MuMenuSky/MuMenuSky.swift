//
//  File.swift
//  
//
//  Created by warren on 8/10/22.
//

import Foundation
import Tr3


public class MuMenuSky {
    public static let bundle = Bundle.module
    static func read(_ filename: String, _ ext: String) -> String {

        guard let path = Bundle.module.path(forResource: filename, ofType: ext)  else {
            print("🚫 MuMenuSky couldn't find file: \(filename)")
            return ""
        }
        do {
            return try String(contentsOfFile: path) }
        catch {
            print("🚫 MuMenuSky::\(#function) error:\(error) loading contents of:\(path)")
        }
        return ""
    }

    static public func parseTr3(_ root: Tr3,
                                _ filename: String,
                                _ ext: String = "tr3.h") -> Bool {
        
        let script = read(filename, ext)
        print(filename, terminator: " ")
        let success = Tr3Parse().parseScript(root, script)
        print(success ? "✓" : "🚫 parse failed")
        return success
    }

}
