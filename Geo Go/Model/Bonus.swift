//
//  Bonus.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 27/07/24.
//

import Foundation


struct BonusResponse: Codable {
    let balance: Double
    let capabilities: Capabilities
}

struct Capabilities: Codable {
    var type: String
    var min: Double
    var max: Double
    var options: [Double]?
}
