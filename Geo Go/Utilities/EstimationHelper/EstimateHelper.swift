//
//  EstimateHelper.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 08/07/24.
//



import Foundation

func getEstimateRideRequest(serviceTariff: ServiceTariff, route: [RouteCoordinates]) -> EstimateRideRequest {
    
    var optionsList: [Int64] = []
    optionsList.append(contentsOf: DataHolder.option)
    
    if let optionId = getOptionsId2(tariffId: serviceTariff.id) {
        optionsList.append(optionId)
    }
    
    let paymentMethod = PaymentMethod(kind: Constants.paymentType, id: nil, name: nil, enoughMoney: nil)
    
    let estimateRideRequest = EstimateRideRequest(
        tariff: serviceTariff.id,
        paymentMethod: paymentMethod,
        options: optionsList,
        route: route
    )
    
    return estimateRideRequest
}

private func getOptionsId2(tariffId: Int64) -> Int64? {
    var optionId: Int64? = nil
    
    DataHolder.serviceTariffConstant?.forEach { serviceTariff in
        if tariffId == serviceTariff.id {
            switch DataHolder.complainOptions {
            case 0:
                optionId = nil
            case 1:
                serviceTariff.options.forEach {
                    if $0.name == "1" { optionId = $0.id }
                }
            case 2:
                serviceTariff.options.forEach {
                    if $0.name == "2" { optionId = $0.id }
                }
            case 3:
                serviceTariff.options.forEach {
                    if $0.name == "3" { optionId = $0.id }
                }
            case 4:
                serviceTariff.options.forEach {
                    if $0.name == "4" { optionId = $0.id }
                }
            case 5:
                serviceTariff.options.forEach {
                    if $0.name == "5" { optionId = $0.id }
                }
            default:
                break
            }
        }
    }
    
    return optionId
}


func getOptionsId() -> Int64? {
    var optionId: Int64? = nil
    if let serviceTariffConstant = DataHolder.serviceTariffConstant {
        for serviceTariff in serviceTariffConstant {
            if DataHolder.tariffId == serviceTariff.id {
                switch DataHolder.complainOptions {
                    case 0:
                        optionId = nil
                    case 1:
                        for option in serviceTariff.options {
                            if option.name == "1" {
                                optionId = option.id
                            }
                        }
                    case 2:
                        for option in serviceTariff.options {
                            if option.name == "2" {
                                optionId = option.id
                            }
                        }
                    case 3:
                        for option in serviceTariff.options {
                            if option.name == "3" {
                                optionId = option.id
                            }
                        }
                    case 4:
                        for option in serviceTariff.options {
                            if option.name == "4" {
                                optionId = option.id
                            }
                        }
                    case 5:
                        for option in serviceTariff.options {
                            if option.name == "5" {
                                optionId = option.id
                            }
                        }
                    default:
                        break
                }
                break
            }
        }
    }
    return optionId
}
