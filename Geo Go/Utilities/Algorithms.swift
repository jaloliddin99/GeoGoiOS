//
//  Algorithms.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation


extension Double {
    func toRadians() -> Double {
        return self * .pi / 180
    }
}

// Assuming LinkedList implementation
class LinkedList<Element> {
    private var head: Node?
    
    class Node {
        var value: Element
        var next: Node?
        
        init(value: Element, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    func clear() {
        head = nil
    }
    
    func add(_ value: Element) {
        let newNode = Node(value: value)
        if let lastNode = lastNode() {
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    private func lastNode() -> Node? {
        var node = head
        while let next = node?.next {
            node = next
        }
        return node
    }
}

