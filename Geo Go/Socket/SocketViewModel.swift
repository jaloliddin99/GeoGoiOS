//
//  SocketViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//

import SwiftUI
import SocketIO

class SocketViewModel: ObservableObject {
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    
    init() {
        socketManager = SocketManager(
            socketURL: URL(string: "http://185.224.219.1:3007")!,
            config: [
//                .log(true),
                .compress,
                .connectParams(["EIO": "2"]),
                .forceWebsockets(true),
                .reconnects(true)
            ]
        )
        socket = socketManager.defaultSocket
        
        
        socket.on(clientEvent: .connect) { _, _ in
            self.setupListeners()
        }
        
        connect()
    }

    func connect() {
        guard socket.status != .connected else {
            return
        }
        socket.connect()
    }
    
    func disconnect() {
        guard socket.status != .disconnected else { return }
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    @Published var connectionState: SocketConnectionState = .disconnected

    
    
    deinit {
        disconnect()
    }

    
    func sendUserLocation(){
        let message = Message(
            lat: DataHolder.location.latitude,
            long: DataHolder.location.longitude,
            userId: getUserPhone(),
            type: "all"
        )
        
        if let messageData = message.toDictionary() {
            socket.emit("user", messageData)
        }
    }
    
    private func setupListeners() {
        sendUserLocation()
        socket.on("getCars"){ data, ack in
            if let cars: [SDriverData] = self.parseSocketData(data: data, type: [SDriverData].self) {
                
            }
        }
        socket.on("listen-order") { [weak self] data, ack in
            guard let self = self else { return }
            print("Received listen-order event: \(data)")
            
            if let orderInfo: SOrderInfo = self.parseSocketData(data: data, type: SOrderInfo.self) {
               
            }
        }
        
    }
    
    
    private func parseSocketData<T: Decodable>(data: [Any], type: T.Type) -> T? {
        guard let json = data.first else {
            print("Error: Data is not in expected format.")
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("Error parsing data into \(T.self): \(error)")
            return nil
        }
    }
}

struct SDriverData: Codable {
    let driverId: String
    let lat: Double
    let long: Double
    let type: String
}

struct SOrderInfo: Codable {
    let orderId: Int
    let driverFullName: String
    let driverRating: Double
    let orderStatus: Int
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
