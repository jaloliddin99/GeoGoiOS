//
//  Estimate.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 08/07/24.
//

import Foundation
import CoreLocation

// estimate response

struct EstimateResponse: Codable {
    var cost: EstimateCost
    let distance: Double
}

struct EstimateCost: Codable {
    var type: String
    let amount: Double
    let modifier: EstimateCostModifier?
    let calculation: String
}

struct EstimateCostModifier: Codable {
    let type: String?
    let value: Double?
}


// estimate body

struct EstimateRideRequest: Codable {
    let tariff: Int64
    let paymentMethod: PaymentMethod
    let options: [Int64]?
    let route: [RouteCoordinates]
}

struct RouteCoordinates: Codable {
    let lat : Double
    let lon : Double
    let type : String?
}


func mapToRouteCoordinates(addresses: [UserSelectedAddress]) -> [RouteCoordinates] {
    return addresses.map { address in
        RouteCoordinates(
            lat: address.addressLocation.latitude,
            lon: address.addressLocation.longitude,
            type: address.addressName
        )
    }
}

func getCoorWithDriverLoc(orderInfo: OrderInfo) -> [String] {
    guard let driverLocation = orderInfo.assignee?.location else { return []}
    guard let clientLocation = orderInfo.route.count > 0 ? orderInfo.route[0].point.coordinates : nil else { return []}
    
    return [
        "\(clientLocation.lat),\(clientLocation.lon)",
        "\(driverLocation.lat),\(driverLocation.lon)"
    ]
}


func getCoorWithDriverLocation(orderInfo: OrderInfo) -> [UserSelectedAddress] {
    guard let driverLocation = orderInfo.assignee?.location else { return []}
    let location = CLLocationCoordinate2D(latitude: driverLocation.lat, longitude: driverLocation.lon)
    guard let clientLocation = orderInfo.route.count > 0 ? orderInfo.route[0].point.coordinates : nil else { return []}

    let cLocation = CLLocationCoordinate2D(latitude: clientLocation.lat, longitude: clientLocation.lon)
    return [
        UserSelectedAddress(addressName: "", addressLocation: cLocation),
        UserSelectedAddress(addressName: "", addressLocation: location),
    ]
}




func mapToRouteCoordinatesLatLng(coordinates: [UserSelectedAddress]) -> [String] {
    return coordinates.map { coordinates in
        "\(coordinates.addressLocation.latitude),\(coordinates.addressLocation.longitude)"
    }
}

func changeCost(res: EstimateResponse, list: inout [ServiceTariff]) {
    for i in list.indices {
        if res.cost.type == String(list[i].id) {
            list[i].minCost = res.cost.amount
            
            if let modifier = res.cost.modifier {
                switch modifier.type {
                case "add":
                    if let price = modifier.value {
                        list[i].Type = "add"
                        list[i].costChangeStep2 = price
                        list[i].costChangeAllowed = true
                    }
                case "multiply":
                    if let price = modifier.value {
                        list[i].Type = "multiply"
                        let priceCost = res.cost.amount * (price != 0 ? price : 1)
                        list[i].minCost = priceCost
                        list[i].costChangeStep2 = priceCost - res.cost.amount
                        list[i].costChangeAllowed = true
                    }
                default:
                    list[i].Type = "constant"
                    list[i].costChangeAllowed = false
                    list[i].costChangeStep2 = 0.0
                }
            } else {
                list[i].Type = "constant"
                list[i].costChangeAllowed = false
                list[i].costChangeStep2 = 0.0
            }
            
            list[i].showEstimation = false
            

        }
    }
}

func setShortOrderInfoProperties(res: DateOrderHistory, list: inout [ShortOrderInfo], orderId: Int64){
    for i in list.indices {
        if orderId == list[i].id {
            list[i].time = res.completionDate
            list[i].toPay = res.toPay
            list[i].total = res.total
            list[i].usedBonuses = res.usedBonuses
            return
        }
    }
    
}

