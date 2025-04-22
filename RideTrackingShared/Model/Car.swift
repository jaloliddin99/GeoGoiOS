//
//  Car.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

public struct CarModel {
    public let regNum: String
    public let brand: String
    public let model: String
    public let color: String
    
    public init(regNum: String, brand: String, model: String, color: String) {
        self.regNum = regNum
        self.brand = brand
        self.model = model
        self.color = color
    }
}
