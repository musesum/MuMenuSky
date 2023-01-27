// Created by warren on 10/17/21.

import SwiftUI
import MuMenu
import MuFlo


open class MuFloNode: MuNode {

    var modelFlo: Flo
    var viewFlo: Flo?
    var axis: Axis = .vertical

    public init(_ modelFlo: Flo,
         parent: MuNode? = nil) {

        self.modelFlo = modelFlo
        super.init(name: modelFlo.name,
                   icon: MuFloNode.makeFloIcon(modelFlo),
                   parent: parent)

        menuSync = self
        makeOptionalLeaf()
    }

    /// this is a leaf node
    init(_ modelFlo: Flo,
         _ nodeType: MuNodeType,
         _ icon: MuIcon,
         parent: MuFloNode? = nil) {

        self.modelFlo = modelFlo

        super.init(name: modelFlo.name, icon: icon, parent: parent)
        self.nodeType = nodeType

        modelFlo.addClosure(syncMenuModel) // update node value closuer
        
        menuSync = self // setup delegate for MuValue protocol
    }

    override public func touch() {
        viewFlo?.updateTime()
    }
    /// optional leaf node for changing values
    func makeOptionalLeaf() {
        if children.count > 0 { return }

        let nodeType = getNodeType()
        if nodeType.isLeaf {
            _ = MuFloNode(modelFlo, nodeType, icon, parent: self)
        }
    }

    /// expression parameters: val vxy tog seg tap x,y indicates a leaf node
    public func getNodeType() -> MuNodeType {
        
        if let name = modelFlo.getName(in: MuNodeLeaves) {
            return  MuNodeType(rawValue: name) ?? .node
        } else if modelFlo.contains(names: ["x","y"]) {
            return MuNodeType.vxy
        }
        return .node
    }

    static func makeFloIcon(_ flo: Flo) -> MuIcon {
        let components = flo.components(named: ["symbol", "image", "text", "cursor"])
        for (key,value) in components {
            if let value = value as? String {
                switch key {
                    case "symbol": return MuIcon(.symbol, named: value)
                    case "image" : return MuIcon(.image,  named: value)
                    case "text"  : return MuIcon(.text,   named: value)
                    case "cursor": return MuIcon(.cursor, named: value)
                    default: continue
                }
            }
        }
        return MuIcon(.none, named: "")
    }
}


