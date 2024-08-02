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


func getCreateOrderRoute(addressList: [UserSelectedAddress], bonusInt: Double) -> CreateOrderRequest {
    var routeORDER = [ClientAddress]()
    if let optionId = getOptionsId() {
        DataHolder.option.append(optionId)
    }
    
//    if SharedPref.cashType == Constants.PAYMENT_TYPE_CASH {
//        DataHolder.option.removeAll { $0 == Constants.cardOptionID }
//    } else {
//        DataHolder.option.append(Constants.cardOptionID)
//    }
    
    addressList.forEach { address in
        routeORDER.append(
            ClientAddress(
                address: SearchedAddress(
                    name: address.addressName,
                    components: nil,
                    types: nil,
                    position: SearchPosition(lat: address.addressLocation.latitude, lon: address.addressLocation.longitude)
                ),
                entrance: nil,
                flat: nil,
                comment: nil,
                pickupPointId: nil
            )
        )
    }
    
    var time = ""
    getCurrentTime { currentTime in
        time = currentTime
    }
    
    if bonusInt == 0.0 {
        return CreateOrderRequest(
            paymentMethod: Constants.paymentMethod,
            tariff: DataHolder.tariffId,
            options: DataHolder.option,
            route: routeORDER,
            time: OrderTime(type: "absolute", value: time),
            comment: DataHolder.globalComment,
            fixCost: nil,
            useBonuses: nil,
            disableSms: nil,
            disableVoice: nil,
            enablePushUpdates: true,
            estimationToken: nil
        )
    } else {
        return CreateOrderRequest(
            paymentMethod: Constants.paymentMethod,
            tariff: DataHolder.tariffId,
            options: DataHolder.option,
            route: routeORDER,
            time: OrderTime(type: "absolute", value: time),
            comment: DataHolder.globalComment,
            fixCost: nil,
            useBonuses: bonusInt,
            disableSms: nil,
            disableVoice: nil,
            enablePushUpdates: true,
            estimationToken: nil
        )
    }
}

func getCurrentTime(block: @escaping (String) -> Void) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let date = Date()
    let formattedDate = dateFormatter.string(from: date)
    block(formattedDate)
}
