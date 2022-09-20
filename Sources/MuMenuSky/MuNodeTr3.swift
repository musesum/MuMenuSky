// Created by warren on 10/17/21.

import SwiftUI
import MuMenu
import Tr3


/// shared between 1 or more MuNodeVm
public class MuNodeTr3: MuNode {

    var tr3: Tr3
    var caching = false
    var axis: Axis = .vertical

    init(_ tr3: Tr3,
         parent: MuNode? = nil) {

        self.tr3 = tr3
        super.init(name: tr3.name,
                   icon: MuNodeTr3.makeTr3Icon(tr3),
                   parent: parent)

        nodeProto = self
        makeOptionalLeaf()
    }

    /// this is a leaf node
    init(_ tr3: Tr3,
         _ nodeType: MuNodeType,
         _ icon: MuIcon,
         parent: MuNodeTr3? = nil) {

        self.tr3 = tr3

        super.init(name: tr3.name, icon: icon, parent: parent)
        self.nodeType = nodeType

        tr3.addClosure(getting) // update node value closuer
        
        nodeProto = self // setup delegate for MuValue protocol
    }

    /// optional leaf node for changing values
    func makeOptionalLeaf() {
        if children.count > 0 { return }

        let nodeType = getNodeType()
        if nodeType.isLeaf {
            _ = MuNodeTr3(tr3, nodeType, icon, parent: self)
        }
    }

    /// expression parameters: val vxy tog seg tap x,y indicates a leaf node
    public func getNodeType() -> MuNodeType {
        
        if let name = tr3.getName(in: MuNodeLeaves) {
            return  MuNodeType(rawValue: name) ?? .node
        } else if tr3.contains(names: ["x","y"]) {
            return MuNodeType.vxy
        }
        return .node
    }

    static func makeTr3Icon(_ tr3: Tr3) -> MuIcon {
        let components = tr3.components(named: ["symbol", "image", "abbrv", "cursor"])
        for (key,value) in components {
            if let value = value as? String {
                switch key {
                    case "symbol": return MuIcon(.symbol, named: value)
                    case "image" : return MuIcon(.image,  named: value)
                    case "abbrv" : return MuIcon(.abbrv,  named: value)
                    case "cursor": return MuIcon(.cursor, named: value)
                    default: continue
                }
            }
        }
        return MuIcon(.none, named: "")
    }
}


