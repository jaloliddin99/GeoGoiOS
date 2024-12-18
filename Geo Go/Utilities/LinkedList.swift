//
//  LinkedList.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/12/24.
//


import Foundation
import CoreLocation

class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode<T>?
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T> {
    private var head: LinkedListNode<T>?
    private var tail: LinkedListNode<T>?
    
    // Append a value to the linked list
    func append(_ value: T) {
        let newNode = LinkedListNode(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }
    
    // Clear the linked list
    func clear() {
        head = nil
        tail = nil
    }
    
    // Computed property to get the first value
    var first: T? {
        return head?.value
    }
    
    // Convert the linked list to an array (for debugging or iteration)
    func toArray() -> [T] {
        var result: [T] = []
        var currentNode = head
        while let node = currentNode {
            result.append(node.value)
            currentNode = node.next
        }
        return result
    }
}
