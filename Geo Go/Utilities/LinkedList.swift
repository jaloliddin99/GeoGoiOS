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
    private(set) var head: LinkedListNode<T>?
    private var tail: LinkedListNode<T>?
    private var count: Int = 0
    
    func append(_ value: T) {
        let newNode = LinkedListNode(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
        count += 1
    }
    
    func clear() {
        head = nil
        tail = nil
        count = 0
    }
    
    var first: T? {
        return head?.value
    }
    
    func toArray() -> [T] {
        var result: [T] = []
        var currentNode = head
        while let node = currentNode {
            result.append(node.value)
            currentNode = node.next
        }
        return result
    }
    
    var size: Int {
        return count
    }
    
    func removeUpTo(_ targetNode: LinkedListNode<T>?) {
        guard let targetNode = targetNode else { return }
        
        // Traverse the list to find the target node
        var currentNode = head
        var previousNode: LinkedListNode<T>? = nil
        
        while let node = currentNode {
            if node === targetNode {
                head = node.next
                
                // If the target node was the tail, update the tail
                if node.next == nil {
                    tail = previousNode
                }
                
                // Adjust the count
                count -= 1
                break
            }
            
            previousNode = currentNode
            currentNode = node.next
            count -= 1
        }
    }
}

