//
//  PaymentMethod.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 01/08/24.
//

import Foundation


struct PaymentMethod: Codable {
    var kind: String
    var id: String?
    var name: String?
    var enoughMoney: Bool?
}

struct PaymentMethodParent: Codable {
    var prevServiceId: String
    var paymentMethod: PaymentMethod
}
