//  Created by warren on 9/10/22.

import SwiftUI
import MuMenu
import MuFlo
import MuPar

extension MuFloNode: MuMenuSync {

    public func setMenuAny(named: String,_ any: Any, _ visitor: Visitor) -> Bool {
        if visitor.newVisit(hash) {
            modelFlo.setNameAnys([(named,any)], .activate, visitor)
            return true
        } else {
            return false
        }
    }
    public func setMenuAnys(_ anys: [(String, Any)], _ visitor: Visitor) -> Bool {
        if visitor.newVisit(hash) {
            modelFlo.setNameAnys(anys, .activate, visitor)
            return true
        } else {
            return false
        }
    }

    public func resetDefault() {
        modelFlo.bindDefaults()
        //?? modelFlo.activate()
    }

    // MARK: - get
    public func getMenuAny(named: String) -> Any? {

        let any = modelFlo.component(named: named)

        if let val = any as? FloValScalar {
            return val.now
        } else if let num = any as? Double {
            return num
        } else {
            return nil
        }
    }
    public func getMenuAnys(named: [String]) -> [(String,Any?)] {

        var result = [(String,Any?)]()
        let comps = modelFlo.components(named: named)
        for (name, any) in comps {
            if let val = any as? FloValScalar {
                result.append((name, val.now))
            } else if let num = any as? Float {
                result.append((name, num))
            } else {
                result.append((name, nil))
            }
        }
        return result
    }
    public func getMenuRange(named: String) -> ClosedRange<Double> {

        let component = modelFlo.component(named: named)

        let range = ((component as? FloValScalar)?.range() ??
                (modelFlo.val as? FloValScalar)?.range() ??
                0...1)
        return range 
    }
    public func getMenuRanges(named: [String]) -> [(String,ClosedRange<Double>)] {

        var result = [(String,ClosedRange<Double>)]()

        let comps = modelFlo.components(named: named)
        for (name, component) in comps {

            let range = ((component as? FloValScalar)?.range() ??
                         (modelFlo.val as? FloValScalar)?.range() ??
                         0...1)

            result.append((name,range))
        }
        return result
    }

    /// callback from flo
    public func syncMenuModel(_ any: Any, _ visitor: Visitor) {
        guard let flo = any as? Flo else { return }
        
        if true || //???
            visitor.from.animate ||
            visitor.newVisit(self.hash) {

            if !visitor.from.animate {
                print("\(flo.parentPath(99)) \(flo.val?.scriptVal(.now) ?? "??") \(visitor.log) \(self.hash)")
            }


            for leaf in self.leafProtos {

                let comps = flo.components(named: MuNodeLeafNames)
                let vals = comps.compactMap { ($1 as? FloValScalar)?.normalized() }

                DispatchQueue.main.async {
                    leaf.updateLeaf(vals, visitor)
                }
            }
        }
    }
}
