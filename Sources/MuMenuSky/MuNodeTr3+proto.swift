//  Created by warren on 9/10/22.

import SwiftUI
import MuMenu
import Tr3
import Par

extension MuTr3Node: MuMenuSync {

    public func setAny(named: String,_ any: Any, _ visitor: Visitor) -> Bool {
        if visitor.newVisit(hash) {
            var options = Tr3SetOptions([.activate])
            if caching { options.insert(.cache) }
            modelTr3.setAny((named,any), options, visitor)
            return true
        } else {
            return false
        }
    }
    public func setAnys(_ anys: [(String, Any)], _ visitor: Visitor) -> Bool {
        if visitor.newVisit(hash) {
            var options = Tr3SetOptions([.activate])
            if caching { options.insert(.cache) }
            modelTr3.setAnys(anys, options, visitor)
            return true
        } else {
            return false
        }
    }

    public func resetDefault() {
        modelTr3.bindDefaults()
        //??? modelTr3.activate()
    }

    // MARK: - get
    public func getAny(named: String) -> Any? {

        let any = modelTr3.component(named: named)

        if let val = any as? Tr3ValScalar {
            return val.now
        } else if let num = any as? Double {
            return num
        } else {
            return nil
        }
    }
    public func getAnys(named: [String]) -> [(String,Any?)] {

        var result = [(String,Any?)]()
        let comps = modelTr3.components(named: named)
        for (name, any) in comps {
            if let val = any as? Tr3ValScalar {
                result.append((name, val.now))
            } else if let num = any as? Float {
                result.append((name, num))
            } else {
                result.append((name, nil))
            }
        }
        return result
    }
    public func getRange(named: String) -> ClosedRange<Double> {

        let any = modelTr3.component(named: named)

        if let val = any as? Tr3ValScalar {
            return val.min...val.max
        } else if let val = modelTr3.val as? Tr3ValScalar {
            return val.min...val.max
        } else {
            return 0...1
        }
    }
    public func getRanges(named: [String]) -> [(String,ClosedRange<Double>)] {

        var result = [(String,ClosedRange<Double>)]()

        let comps = modelTr3.components(named: named)
        for (name, any) in comps {
            if let val = any as? Tr3ValScalar {
                result.append((name, val.min...val.max))
            } else if let val = modelTr3.val as? Tr3ValScalar {
                result.append((name, val.min...val.max))
            } else {
                result.append((name, 0...1))
            }
        }
        return result
    }

    /// callback from tr3
    public func syncModel(_ any: Any, _ visitor: Visitor) {
        guard let tr3 = any as? Tr3 else { return }

        if !visitor.from.animate {
            print("\(tr3.parentPath(99)): \(tr3.val?.scriptVal(.now) ?? "??") \(visitor.log) \(self.hash)")
        }


        for leaf in self.leafProtos {

            let comps = tr3.components(named: MuNodeLeafNames)
            let vals = comps.compactMap { ($1 as? Tr3ValScalar)?.normalized() }

            DispatchQueue.main.async {
                leaf.updateLeaf(vals, visitor)
            }
        }
    }
}
