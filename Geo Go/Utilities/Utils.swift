//
//  Utils.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation


func formatNumberWithSpaces(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    return "\(formatter.string(from: NSNumber(value: number))!) \(UserDefaults.standard.string(forKey: Constants.sign)!.lowercased())"
}

func formatNumberWtCurrency(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    return formatter.string(from: NSNumber(value: number))!
}

func getCreateOrderRoute(addressList: [UserSelectedAddress], bonusInt: Double) -> CreateOrderRequest {
    var routeORDER = [ClientAddress]()
    if let optionId = getOptionsId() {
        DataHolder.option.append(optionId)
    }
    
        if getPaymentMethod() == Constants.PAYMENT_TYPE_CASH {
            DataHolder.option.removeAll { $0 == Constants.cardOptionID }
        } else {
            DataHolder.option.append(Int64(Constants.cardOptionID))
        }
    
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


func imageNameForType(_ type: String) -> String {
    switch type {
        case Constants.CAR_PEREGON:
            return "car_peregon"
        case Constants.CAR_TYPE_3, Constants.CAR_KOMFORT:
            return "car_comfort"
        case Constants.CAR_DELIVERY:
            return "car_delivery"
        default:
            return "car_econom"
    }
}


func getImageUrl(orderDetails: OrderInfo) -> String{
    let phone = orderDetails.assignee?.call.numbers![0]
        .replacingOccurrences(of: "+", with: "")
    let url = "https://central.uz.taxi/bosh/get_photo.php?type=worker&phone="
    return "\(url)\(phone!)"

}


func formatTime(time: String) -> String {
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    
    if let date = inputFormatter.date(from: time) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDateString = outputFormatter.string(from: date)
        return formattedDateString
    } else {
        return "Time Format Failed"
    }
}

func formatDate(from originalDateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let date = dateFormatter.date(from: originalDateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return outputFormatter.string(from: date)
    } else {
        return "Time Format Failed"
    }
}

func convertISOToCustomFormat(isoDate: String) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoDateFormatter.date(from: isoDate) else {
        return  "unable to convert"
    }
    
    let customDateFormatter = DateFormatter()
    customDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return customDateFormatter.string(from: date)
}


func getUserPhone() -> String {
    let userPhone = UserDefaults.standard.string(forKey: Constants.USER_PHONE)!
    if ((userPhone.starts(with: "+"))) {
        return userPhone.replacing("+", with: "")
    }else{
        return userPhone;
    }
}

func getPaymentMethod() -> String {
    let paymentMethod:String = UserDefaults.standard.string(forKey: Constants.PAYMENT_METHOD) ?? "cash"
    return paymentMethod;
}



func setPaymentMethod(method: String) {
    UserDefaults.standard.setValue(method, forKey: Constants.PAYMENT_METHOD)
}

func privacyPolicyUrl(lang: String, url: String) -> String {
    switch lang {
        case "ru":
            return "\(url)/privacy-policy-ru/"
        case "kl":
            return "\(url)/jasirinliq-siyasati/"
        case "uz":
            return "\(url)/maxfiylik-siyosati/"
        default:
            return "\(url)/privacy-policy/"
    }
}

func termsOfUse(lang: String, url: String) -> String {
    switch lang {
        case "ru":
            return "\(url)/user-agreement-ru/"
        case "kl":
            return "\(url)/paydalaniwshi-kelisimi/"
        case "uz":
            return "\(url)/foydalanuvchi-kelishuvi/"
        default:
            return "\(url)/user-agreement/"
    }
}

