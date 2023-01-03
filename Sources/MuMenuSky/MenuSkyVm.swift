//  Created by warren on 7/27/22.

import SwiftUI
import MuMenu
import Tr3
import Par

public class MenuSkyVm: MenuVm {

    let id: Int = Visitor.nextId()

    /// one or two menus emanating from a corner
    ///
    ///  - parameters:
    ///     - corner: placement of root node
    ///     - rootAxis: (tr3 root node, axis)
    ///
    ///   - note: assuming maximum of two menues from corner,
    ///     with different axis
    ///
    public init(_ corner: MuCorner,
                _ rootAxis: [(MuTr3Node,Axis)]) {

        var skyTreeVms = [MuTreeVm]()

        for (rootNode,axis) in rootAxis {
            let cornerAxis = CornerAxis(corner,axis)
            let skyTreeVm = MuTreeVm(cornerAxis)
            let skyNodes = MenuSkyVm.skyNodes(rootNode, corner)

            let skyBranchVm = MuBranchVm(nodes: skyNodes,
                                         treeVm: skyTreeVm,
                                         prevNodeVm: nil)
            skyTreeVm.addBranchVms([skyBranchVm])
            skyTreeVms.append(skyTreeVm)
        }
        let rootVm = MuRootVm(corner, treeVms: skyTreeVms)
        super.init(rootVm)
        MuIcon.altBundle = MuMenuSky.bundle
    }

    static func skyNodes(_ rootNode: MuTr3Node,
                         _ corner: MuCorner) -> [MuNode] {

        let rootTr3 = rootNode.modelTr3

        if let menuTr3 = rootTr3.findPath("menu"),
           let modelTr3 = menuTr3.findPath("model") {

            let cornerStr = corner.str()

            if let cornerTr3 = menuTr3.findPath(cornerStr),
               let viewTr3  = cornerTr3.findPath("view") {

                let model = parseTr3Node(modelTr3, rootNode)
                mergeTr3Node(viewTr3, model)

            } else {
                // parse everything together
                _ = parseTr3Node(menuTr3, rootNode)
            }
            return rootNode.children.first?.children ?? []

        } else {

            for child in rootTr3.children {
                _ = parseTr3Node(child, rootNode)
            }
            return rootNode.children
        }
    }

    /// recursively parse tr3 hierachy
    static func parseTr3Node(_ tr3: Tr3,
                             _ parentNode: MuNode) -> MuTr3Node {

        let node = MuTr3Node(tr3, parent: parentNode)
        for child in tr3.children {
            if child.name.first != "_" {
                _ = parseTr3Node(child, node)
            }
        }
        return node
    }

    /// merge menu.view with with menu.model
    static func mergeTr3Node(_ viewTr3: Tr3,
                             _ parentNode: MuTr3Node) {

        func findTr3Node(_ tr3: Tr3) -> MuTr3Node? {
            if parentNode.title == tr3.name {
                return parentNode
            }
            for childNode in parentNode.children {
                if childNode.title == tr3.name,
                   let childNodeTr3 = childNode as? MuTr3Node {
                    return childNodeTr3
                }
            }
            return nil
        }

        for child in viewTr3.children {
            if let nodeTr3 = findTr3Node(child) {
                let icon = MuTr3Node.makeTr3Icon(child)
                nodeTr3.icon = icon
                nodeTr3.viewTr3 = viewTr3
                if nodeTr3.children.count == 1,
                   let grandChild = nodeTr3.children.first,
                   grandChild.nodeType.isLeaf {
                    grandChild.icon = icon
                }
                mergeTr3Node(child, nodeTr3)
            }
        }
    }

}
extension MenuSkyVm: Hashable {
    
    public static func == (lhs: MenuSkyVm, rhs: MenuSkyVm) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }

}
