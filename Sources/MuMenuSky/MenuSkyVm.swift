//  Created by warren on 7/27/22.

import SwiftUI
import MuMenu
import Tr3

public class MenuSkyVm: MenuVm {

    public init(_ corner: MuCorner,
                _ axis: Axis,
                _ rootTr3: Tr3) {

        // init in sequence: nodes, root, tree, branch, touch
        let skyTreeVm = MuTreeVm(axis: axis, corner: corner)
        let skyNodes = MenuSkyVm.skyNodes(rootTr3, corner: corner)
        let skyBranchVm = MuBranchVm(nodes: skyNodes, treeVm: skyTreeVm)
        skyTreeVm.addBranchVms([skyBranchVm])
        super.init(MuRootVm(corner, treeVms: [skyTreeVm]))
        MuIcon.altBundle = MuMenuSky.bundle
        //??? rootVm.hideBranches() 
    }

    static func skyNodes(_ rootTr3: Tr3, corner: MuCorner) -> [MuNode] {

        let rootNode = MuNodeTr3(rootTr3)

        if let menuTr3 = rootTr3.findPath("menu") {

            let abbreviation = corner.abbreviation()
            if let cornerTr3 = menuTr3.findPath(abbreviation),
               let modelTr3 = menuTr3.findPath("model"),
               let viewTr3  = cornerTr3.findPath("view") {

                let model = parseTr3(modelTr3, rootNode)
                mergeTr3(viewTr3, model)

                let components = viewTr3.components(named: ["depth", "touch"])
                
                for (key,value) in components {
                    if let scalar = (value as? Tr3ValScalar) {
                        print("*** \(key): \(scalar.now)")
                    }
                }
            } else {
                // parse everything together
                _ = parseTr3(menuTr3, rootNode)
            }
            return rootNode.children.first?.children ?? []

        } else {

            for child in rootTr3.children {
                _ = parseTr3(child, rootNode)
            }
            return rootNode.children
        }
    }

    /// recursively parse tr3 hierachy
    static func parseTr3(_ tr3: Tr3,
                         _ parentNode: MuNode) -> MuNodeTr3 {

        let node = MuNodeTr3(tr3, parent: parentNode)
        for child in tr3.children {
            if child.name.first != "_" {
                _ = parseTr3(child, node)
            }
        }
        return node
    }

    /// merge menu.view with with menu.model
    static func mergeTr3(_ viewTr3: Tr3,
                         _ parentNode: MuNodeTr3) {

        func findTr3Node(_ tr3: Tr3) -> MuNodeTr3? {
            if parentNode.title == tr3.name {
                return parentNode
            }
            for childNode in parentNode.children {
                if childNode.title == tr3.name,
                let childNodeTr3 = childNode as? MuNodeTr3 {
                    return childNodeTr3
                }
            }
            return nil
        }

        for child in viewTr3.children {
            if let nodeTr3 = findTr3Node(child) {
                let icon = MuNodeTr3.makeTr3Icon(child)
                nodeTr3.icon = icon
                nodeTr3.viewTr3 = viewTr3
                if nodeTr3.children.count == 1,
                   let grandChild = nodeTr3.children.first,
                   grandChild.nodeType.isLeaf {
                    grandChild.icon = icon
                }
                mergeTr3(child, nodeTr3)
            }
        }
    }

}
