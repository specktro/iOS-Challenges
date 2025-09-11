//
//  TreeNode.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import Foundation

// MARK: - Tree Node Data Structure
class TreeNode<T> {
    var value: T
    var children: [TreeNode<T>]
    weak var parent: TreeNode<T>?
    var isExpanded: Bool = true
    
    init(value: T) {
        self.value = value
        self.children = []
    }
    
    func addChild(_ child: TreeNode<T>) {
        child.parent = self
        children.append(child)
    }
    
    func removeChild(_ child: TreeNode<T>) {
        children.removeAll { $0 === child }
        child.parent = nil
    }
    
    var isLeaf: Bool {
        return children.isEmpty
    }
    
    var depth: Int {
        var level = 0
        var current = parent
        while current != nil {
            level += 1
            current = current?.parent
        }
        return level
    }
    
    func toggleExpansion() {
        isExpanded.toggle()
    }
}
