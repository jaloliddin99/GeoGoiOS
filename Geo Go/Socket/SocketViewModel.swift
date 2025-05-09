//
//  SocketViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//

import SwiftUI
import SocketIO
import Combine

func parseSocketData<T: Decodable>(data: [Any], type: T.Type) -> T? {
    guard let json = data.first else { return nil }
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
        return decodedData
    } catch {
        print("Error parsing data into \(T.self): \(error)")
        return nil
    }
}


struct SDriverData: Codable, Equatable {
    let driverId: String
    let lat: Double
    let long: Double
    let bearing: Double
    let type: String
    
    static func == (lhs: SDriverData, rhs: SDriverData) -> Bool {
        return lhs.driverId == rhs.driverId &&
        lhs.lat == rhs.lat &&
        lhs.long == rhs.long &&
        lhs.bearing == rhs.bearing &&
        lhs.type == rhs.type
    }
}

struct SOrderInfo: Codable {
    let orderId: Int
    let driverId: String
    let driverFullName: String
    let driverRating: Double
    let orderStatus: Int
    let carNumber: String
}

struct SDriverRealTimeData: Codable {
    let bearing: Float64
    let lat: Double
    let lon: Double
    let speed: Float64
}


enum SocketConnectionState: String {
    case connected
    case error
    case disconnected
    case reconnect
}

struct Message: Codable {
    let lat: Double
    let long: Double
    let userId: String
    let type: String
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return nil
        }
        return dict
    }
    }



struct ModelSend: Codable {
    let orderId: Int64
    let departureLocation: [Double]
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return nil
        }
        return dict
    }
}
