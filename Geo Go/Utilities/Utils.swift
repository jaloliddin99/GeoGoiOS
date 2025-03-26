//
//  Utils.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/07/24.
//

import Foundation
import UIKit

func formatNumberWithSpaces(_ number: Double) -> String {
    return "\(number) \(UserDefaults.standard.string(forKey: Constants.sign)!.lowercased())"
}

func getFontHeight(_ fontSize: CGFloat, _ weight: UIFont.Weight) -> CGFloat {
    let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    return font.lineHeight
}

func getCurrencySymbol() -> String {
    return UserDefaults.standard.string(forKey: Constants.sign)!.lowercased()
}


func getOrderPrice() -> Double {
    return UserDefaults.standard.double(forKey: Constants.MIN_COST)
}


func formatNumberWtCurrency(_ number: Double) -> String {
    return String(Int(number))
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

import CoreLocation
func generateCurvedPath(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, heightFactor: Double = 0.05) -> [CLLocationCoordinate2D] {
    let lat1 = start.latitude.degreesToRadians
    let lon1 = start.longitude.degreesToRadians
    let lat2 = end.latitude.degreesToRadians
    let lon2 = end.longitude.degreesToRadians
    
    let delta = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))
    let sinDelta = sin(delta)
    
    guard sinDelta > 0 else { return [start, end] } // Direct line if points are the same or antipodal
    
    var path: [CLLocationCoordinate2D] = []
    
    let steps = 1000
    for i in 0...steps {
        let fraction = Double(i) / Double(steps)
        let A = sin((1 - fraction) * delta) / sinDelta
        let B = sin(fraction * delta) / sinDelta
        
        let x = A * cos(lat1) * cos(lon1) + B * cos(lat2) * cos(lon2)
        let y = A * cos(lat1) * sin(lon1) + B * cos(lat2) * sin(lon2)
        let z = A * sin(lat1) + B * sin(lat2)
        
        let exaggeratedZ = z + heightFactor * sin(fraction * .pi)
        
        let lat = atan2(exaggeratedZ, sqrt(x * x + y * y))
        let lon = atan2(y, x)
        
        path.append(CLLocationCoordinate2D(latitude: lat.radiansToDegrees, longitude: lon.radiansToDegrees))
    }
    
    return path
}
extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}

func imageNameForType(_ type: String) -> String {
    switch type {
        case Constants.CAR_PEREGON:
            return "car_peregon"
        case Constants.CAR_TYPE_3:
            return "car_comfort"
        case Constants.CAR_DELIVERY:
            return "car_peregon"
        default:
            return "car_econom"
    }
}


func getImageUrl(orderDetails: OrderInfo) -> String{
    let phone = orderDetails.assignee?.call.numbers![0]
        .replacingOccurrences(of: "+", with: "")
    let url = "https://central.uz.taxi/bosh/get_photo.php?type=worker&phone="
    guard let ph = phone else { return url }
    return "\(url)\(ph)"
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

func makePhoneCall(_ orderInfo: OrderInfo) {
    if let number = orderInfo.assignee?.call.numbers?.first, let url = URL(string: "tel://\(number)") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
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


func searchAddress(
    _ lang: String,
    _ name: String?,
    _ house: String?,
    _ road: String?,
    _ neighbourhood: String?,
    _ village: String?,
    _ state: String?,
    _ town: String?
) -> String {
    
    let defaultResponse: String
    switch lang {
        case "uz":
            defaultResponse = "Xaritadagi nuqta"
        case "en":
            defaultResponse = "Point on the map"
        case "kaa":
            defaultResponse = "Kartadaǵı noqat"
        default:
            defaultResponse = "Точка на карте"
    }
    
    let result: String
    switch true {
        case house != nil && road == nil && neighbourhood == nil && state == nil && name == nil:
            result = house ?? defaultResponse
            
        case house != nil && neighbourhood != nil && road == nil && name == nil:
            result = "\(neighbourhood!), \(house!)"
            
        case house != nil && road != nil:
            result = "\(road!), \(house!)"
            
        case road != nil && name != nil:
            result = name!
            
        case neighbourhood != nil && house == nil && road == nil:
            result = neighbourhood!
            
        case village != nil && house == nil && road == nil && name == nil && neighbourhood == nil:
            result = defaultResponse
            
        case state != nil && house == nil && road == nil && name == nil && neighbourhood == nil && village == nil:
            result = defaultResponse
            
        default:
            result = defaultResponse
    }
    
    return result.replacingOccurrences(of: "улица", with: "")
        .replacingOccurrences(of: "проезд", with: "пр-д")
}
