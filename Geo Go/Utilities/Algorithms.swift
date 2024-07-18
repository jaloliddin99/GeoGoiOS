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


func addLine(points: [MyPoint]) {
    DataHolder.condensedLinkedList.clear()
    
    for i in 0..<points.count - 1 {
        let distance = points[i].distanceTo(points[i + 1])
        
        if Int(distance) > 5 {
            childLatLng(
                points[i],
                points[i + 1],
                Int(distance)
            )
        }
    }
    
    if let lastPoint = points.last {
        DataHolder.condensedLinkedList.add(
            MyPoint.fromLngLat(lastPoint.longitude, lastPoint.latitude)
        )
    }
    
}

func childLatLng(_ l1: MyPoint, _ l2: MyPoint, _ d: Int) {
    for i in stride(from: 2, through: d, by: 2) {
        let lat = l1.latitude + (Double(i) / Double(d)) * (l2.latitude - l1.latitude)
        let lon = l1.longitude + (Double(i) / Double(d)) * (l2.longitude - l1.longitude)
        DataHolder.condensedLinkedList.add(MyPoint.fromLngLat(lon, lat))
    }
}
