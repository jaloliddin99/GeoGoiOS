//
//  Constants.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation


class Constants{
    
    
    static let driverCallCenter: String = "driverCallCenter"
    static let servername: String = "servername"
    static let driverApi: String = "driverApi"
    static let clientApi: String = "clientApi"
    static let baseUrl: String = "baseUrl"
    static let deptId: String = "deptId"
    static let driverMask: String = "driverMask"
    static let sign: String = "sign"
    static let naviUrl: String = "naviUrl"
    static let residence: String = "residence"
    static let gpxUrl: String = "gpxUrl"
    static let driverSocket: String = "driverSocket"
    static let clientLan: String = "clientLan"
    static let clientInfo: String = "clientInfo"
    static let reverse: String = "reverse"
    static let userUrl: String = "userUrl"
    static let chatUrl: String = "chatUrl"
    static let clientApiSocket: String = "clientApiSocket"
    static let clientBody: String = "clientBody"
    static let driverBody: String = "driverBody"
    static let route: String = "route"
    static let search: String = "search"
    
    
    static let owner: String = "key_owner"
    static let secret: String = "key_secret"
    static let identity: String = "key_identity"
    
    static let HIVE_PROFILE: String = "17db57a7034701b697c8845c7f508d89"
    static let CONFIRMATION_TYPE: String = "sms"
    
    static let isUserLoggedIn: String =  "isUserLoggedIn"
    static let userLoginKey: String = "userLoginKey"
    static let userLoginId: String = "userLoginId"
    
    static let FORMAT: String = "jsonv2"
    
    static let FIX_ORDER = "fix_order"
    static let FEEDBACK = "feedback"
    static let ACTIVATIONS = "activations"
    static let FIREBASE = "firebase"
    static let GET_ORDER_DETAILS = "getOrderDetails"
    static let HISTORY = "history"
    static let POSITION = "position"
    static let ORDERS_GET = "ordersGet"
    static let FINISHED = "finished"
    static let PAYMENT = "payment"
    static let ESTIMATE = "estimate"
    
    static let paymentType = "cash"

    static let SEND_RATING_URL = "http://157.230.124.56:8000/api/v1/ratings"
    static let SEND_COMPLAINS = "http://157.230.124.56:8000/api/v1/complains"
    
    
    static let GEOCODE_TOKEN = "ge-8f137223ed5b405d"
    
    static var latitude: Double = 41.33851520919809
    static var longitude: Double = 69.33460926588599
    
    static var CAR_TYPE_3 = "carType_3"
    static var CAR_KOMFORT = "carType_4"
    static var CAR_DELIVERY = "carType_10"
    static var CAR_PEREGON = "carType_7"
    
    
    static let NAVI_BASE_URL = "https://route2.uz.taxi/route?key=9db0a28e-4851-433f-86c7-94b8a695fb18"
    
    static let paymentMethod = PaymentMethod(
        kind: "cash", id: "191000000026125", name: "Beznal", enoughMoney: true
        )
    
    
    
    static let BLUE_ICON_ID = "blue"
    static let SOURCE_ID = "source_id"
    static let LAYER_ID = "layer_id"
    static let TERRAIN_URL_TILE_RESOURCE = "mapbox://mapbox.mapbox-terrain-dem-v1"
    static let MARKER_ID_PREFIX = "view_annotation_"
    static let SELECTED_ADD_COEF_PX: CGFloat = 50
    
    static let geoJSONDataSourceIdentifier = "geoJSON-data-source"

    
}
