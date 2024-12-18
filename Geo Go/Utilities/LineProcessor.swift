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
    
    // Add the last point
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


func removeListTillThisElement(secondPointList: [MyPoint], longitude: Double, latitude: Double) -> Int {
    let latLng = MyPoint(latitude: latitude, longitude: longitude)
    let closest = closestPoint(in: secondPointList, to: latLng)
    
    return secondPointList.firstIndex(where: { $0.latitude == closest.latitude &&
        $0.longitude == closest.longitude }) ?? -1
}

/// Finds the closest point to a given target point in the list
private func closestPoint(in list: [MyPoint], to targetPoint: MyPoint) -> MyPoint {
    var closest: MyPoint? = nil
    var smallestDistance: Float32 = Float32.greatestFiniteMagnitude
    
    for point in list {
        let distance = point.distanceTo(targetPoint)
        if distance < smallestDistance {
            closest = point
            smallestDistance = distance
        } else {
            return closest!
        }
    }
    return closest!
}
