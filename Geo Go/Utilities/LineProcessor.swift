//
//  LineProcessor.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/12/24.
//


import Foundation
import MapboxMaps

var condensedLL = LinkedList<MyPoint>()
var condensedArrayList: [MyPoint] = []



func addLine(points: [MyPoint]) {
    condensedLL.clear()
    condensedArrayList.removeAll()
    
    for i in 0..<points.count - 1 {
        let distance = points[i].distanceTo(points[i + 1])
        if Int(distance) > 5 {
            childLatLng(
                l1: points[i],
                l2: points[i + 1],
                distance: Int(distance)
            )
        }
    }
    
    let lastPoint = points.last!
    condensedLL.append(lastPoint)
    condensedArrayList.append(lastPoint)
}

private func childLatLng(l1: MyPoint, l2: MyPoint, distance: Int) {
    for i in stride(from: 2, through: distance, by: 2) {
        let lat = l1.latitude + ((Double(i) / Double(distance)) * (l2.latitude - l1.latitude))
        let lon = l1.longitude + ((Double(i) / Double(distance)) * (l2.longitude - l1.longitude))
        
        let newPoint = MyPoint(latitude: lat, longitude: lon)
        condensedLL.append(newPoint)
        condensedArrayList.append(newPoint)
    }
}
func removeElementsTillClosest(in linkedList: LinkedList<MyPoint>, to targetPoint: MyPoint) -> Bool {
    var currentNode = linkedList.head
    var closestNode: LinkedListNode<MyPoint>? = nil
    var smallestDistance: Float = Float.greatestFiniteMagnitude
    
    // Find the closest node
    while let node = currentNode {
        let distance = node.value.distanceTo(targetPoint)
        if distance < smallestDistance {
            smallestDistance = distance
            closestNode = node
        }
        currentNode = node.next
    }
    
    linkedList.removeUpTo(closestNode)
    print("smallest distance \(smallestDistance)")
    return smallestDistance < 100
}
