//  Created by warren on 9/10/22.

import SwiftUI
import MuMenu
import Tr3
import Par

extension MuTr3Node: MuNodeProtocol {

    public func setAny(named: String,_ any: Any) {

        var options = Tr3SetOptions([.activate])
        if caching { options.insert(.cache) }
        modelTr3.setAny((named,any), options, Visitor(id)) //TODO: get Visitor(id) from caller
    }
    public func setAnys(_ anys: [(String, Any)]) {

        var options = Tr3SetOptions([.activate])
        if caching { options.insert(.cache) }
        modelTr3.setAnys(anys, options, Visitor(id)) //TODO: get Visitor(id) from caller
    }

    public func resetDefault() {
        modelTr3.bindDefaults()
        modelTr3.activate()
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
    ///
    /// even though the val
    public func getting(_ any: Any, _ visitor: Visitor) {
        // print("\(tr3.scriptLineage(3)).\(tr3.id): \(tr3.FloatVal() ?? -1)")
        if let tr3 = any as? Tr3 {
            //TODO: visitor.newVisit(id) {
            for proxy in proxies {
                if let p = tr3.CGPointVal() {

                    // TODO: get rid of CGPoint?
                    proxy.updateLeaf(p)

                } else if let name = tr3.getName(in: MuNodeLeaves),
                          let any = tr3.component(named: name) {

                    if let val = any as? Tr3ValScalar {

                        let num = val.now
                        proxy.updateLeaf(num)

                    } else {
                        proxy.updateLeaf(any)
                    }
                }
            }
        }
    }
}
