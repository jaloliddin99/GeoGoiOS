//
//  NearDrivers.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//


struct NDriver: Codable {
    let id: Int
    let location: DriverLocation
}

struct DriverLocation: Codable {
    let lat: Double
    let lon: Double
}
