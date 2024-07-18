//
//  Utils.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation


func formatNumberWithSpaces(_ number: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    return "\(formatter.string(from: NSNumber(value: number))!) \(UserDefaults.standard.string(forKey: Constants.sign)!.lowercased())"
}
