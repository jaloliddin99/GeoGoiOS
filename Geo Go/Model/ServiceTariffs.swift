//
//  ServiceTariffs.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import Foundation

struct ServiceResponse: Codable {
    var kind: String
    var serviceId: String
    var settings: ServiceSettings?
    var tariffs: [ServiceTariff]?
}

struct ServiceSettings: Codable {
    var cardPaymentAllowed: Bool
    var dispatcherCall: DispatcherCall
    var mainInterface: String
}


struct DispatcherCall: Codable {
    var allow: String
    var number: String?
}


struct ServiceTariff: Codable, Identifiable {
    var id: Int64
    var name: String
    var icon: String
    var description: String?
    var options: [TariffOption]
    var minCost: Double
    var cost: Double?
    var costChangeAllowed: Bool
    var costChangeStep: Double?
    var costChangeStep2: Double?
    var hint: String?
    var showEstimation: Bool
    var `Type`: String?
}

struct TariffOption: Codable, Identifiable {
    var id: Int64
    var name: String
    var value: Double
    var mandatory: Bool
}


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

struct LatLng: Codable{
    var latitude: Double
    var longitude: Double
}

struct UserSelectedAddress: Codable{
    var addressName: String
    var addressLocation: LatLng
}


class ServiceTariffSample {
    
    static let sampleData = ServiceResponse(
        kind: "Basic",
        serviceId: "001",
        settings: ServiceSettings(
            cardPaymentAllowed: true,
            dispatcherCall: DispatcherCall(
                allow: "Yes",
                number: "123-456-7890"
            ),
            mainInterface: "iOS"
        ),
        tariffs: [
            ServiceTariff(
                id: 1001,
                name: "Economy",
                icon: "car_econom", // Replace with actual asset name if needed
                description: "Affordable travel for daily commuters.",
                options: [
                    TariffOption(
                        id: 201,
                        name: "Extra luggage",
                        value: 5.0,
                        mandatory: false
                    ),
                    TariffOption(
                        id: 202,
                        name: "Pet friendly",
                        value: 7.0,
                        mandatory: false
                    )
                ],
                minCost: 10.0,
                cost: 12.0,
                costChangeAllowed: true,
                costChangeStep: 1.0,
                costChangeStep2: 0.5,
                hint: "Ideal for short city trips.",
                showEstimation: true,
                Type: "Fixed"
            ),
            ServiceTariff(
                id: 1002,
                name: "Premium",
                icon: "car_comfort", // Replace with actual asset name if needed
                description: "Luxury ride with premium features.",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 2.0,
                costChangeStep2: 1.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            ),
            ServiceTariff(
                id: 1003,
                name: "Premium",
                icon: "car_delivery", // Replace with actual asset name if needed
                description: "Luxury ride with premium features.",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 2.0,
                costChangeStep2: 1.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            ),
            ServiceTariff(
                id: 1004,
                name: "Premium",
                icon: "car_peregon",
                description: "Luxury ride with premium features.",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 2.0,
                costChangeStep2: 1.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            )
        ]
    )

}
