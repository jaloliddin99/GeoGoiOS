//
//  DriverLocation.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import Foundation
import SwiftUI

public struct DriverLocation {
    public let lat: Double
    public let lon: Double
    
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
