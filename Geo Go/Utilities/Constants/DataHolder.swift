//
//  DataHolder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import Foundation
import CoreLocation

class DataHolder {
    
    static var locationHolder = Array<UserSelectedAddress>()
    
    static var serviceTariffConstant: [ServiceTariff]? = nil
    static var selectedTariff: ServiceTariff?
    static var complainOptions: Int64 = 0
    static var option: [Int64] = []

    static var listOptions: [OptionsClass] = []

    static var status = 0
    static var condensedLinkedList = LinkedList<MyPoint>()

    static var bonusPrice = 0
    
    static var tariffId: Int64 = 0
    static var orderId: Int64 = 0
    static var globalComment = ""
    
    static var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    private static var latitude: Double = 41.33851520919809
    private static var longitude: Double = 69.33460926588599
    
    static var lang = "en"
    
}
