//
//  Routing.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation


struct GraphopperNavResponse: Codable {
    let hints: NavHints
    let paths: [NavPath]
}

struct NavHints: Codable {
    let visitedNodesAverage: Double
    let visitedNodesSum: Double
    
    enum CodingKeys: String, CodingKey {
        case visitedNodesAverage = "visited_nodes.average"
        case visitedNodesSum = "visited_nodes.sum"
    }
}

struct NavPath: Codable {
    let instructions: [NavInstruction]
    let distance: Double
    let bbox: [Double]
    let time: Double
    let points: String
    let snappedWaypoints: String
    
    enum CodingKeys: String, CodingKey {
        case instructions, distance, bbox, time, points
        case snappedWaypoints = "snapped_waypoints"
    }
}

struct NavInstruction: Codable {
    let distance: Double
}


struct RouteCoordinatesLatLng: Codable {
    let lat: Double
    let lon: Double
}
