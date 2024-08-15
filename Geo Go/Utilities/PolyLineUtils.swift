//
//  PolyLineUtils.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation
import CoreLocation

struct MyPoint {
    let latitude: Double
    let longitude: Double
    
    static func fromLngLat(_ lng: Double, _ lat: Double) -> MyPoint {
        return MyPoint(latitude: lat, longitude: lng)
    }
    
    func distanceTo(_ point2: MyPoint) -> Float {
        let earthRadius = 3958.75
        let latDiff = (point2.latitude - self.latitude).toRadians()
        let lngDiff = (point2.longitude - self.longitude).toRadians()
        let a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(self.latitude.toRadians()) * cos(point2.latitude.toRadians()) *
        sin(lngDiff / 2) * sin(lngDiff / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c
        let meterConversion = 1609.0
        return Float(distance * meterConversion)
    }
    
    var description: String {
        return "Point(latitude: \(latitude), longitude: \(longitude))"
    }
}

func decode(encodedPath: String, precision: Int) -> [MyPoint] {
    _ = encodedPath.count
    let factor = pow(10.0, Double(precision))
    
    var path: [MyPoint] = []
    var index = encodedPath.startIndex
    var lat = 0
    var lng = 0
    
    while index < encodedPath.endIndex {
        var result = 1
        var shift = 0
        var temp: Int
        
        repeat {
            guard let asciiValue = encodedPath[index].asciiValue else {
                print("Invalid character in encoded path")
                return path
            }
            
            temp = Int(asciiValue) &- 63 &- 1
            result &+= temp << shift
            shift &+= 5
            index = encodedPath.index(after: index)
        } while temp >= 0x1f
        
        lat &+= (result & 1 != 0) ? ~(result >> 1) : (result >> 1)
        
        result = 1
        shift = 0
        
        repeat {
            guard let asciiValue = encodedPath[index].asciiValue else {
                print("Invalid character in encoded path")
                return path
            }
            
            temp = Int(asciiValue) &- 63 &- 1
            result &+= temp << shift
            shift &+= 5
            index = encodedPath.index(after: index)
        } while temp >= 0x1f
        
        lng &+= (result & 1 != 0) ? ~(result >> 1) : (result >> 1)
        
        let location = MyPoint(
            latitude: Double(lat) / factor,
            longitude: Double(lng) / factor
        )
        path.append(location)
    }
    
    return path
}
