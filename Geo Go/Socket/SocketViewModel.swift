//
//  SocketViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//

import SwiftUI
import SocketIO
import Combine

class SocketViewModel: ObservableObject {
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    private var orderId: Int64?
    private var cancellables: Set<AnyCancellable> = []
    
    init(source: MainViewModel) {
        source.$orderId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                if let orderId = newValue {
                    self?.orderId = orderId
                    self?.sendUserOrderIdAndLocs(orderId: orderId)
                }
            }
            .store(in: &cancellables)
        
        socketManager = SocketManager(
            socketURL: URL(string: "http://185.224.219.1:3007")!,
            config: [
                .log(true),
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

    func sendUserOrderIdAndLocs(orderId: Int64){
        let message = ModelSend(
            orderId: orderId,
            departureLocation: [DataHolder.location.latitude, DataHolder.location.longitude]
        )
        if let messageData = message.toDictionary() {
            socket.emit("listen-order", messageData)
        }
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
    
    @Published var sOrderInfo: SOrderInfo?
    @Published var sDriverLists: [SDriverData] = []
   


    private func setupListeners() {
        sendUserLocation()
        
        if orderId != nil{
            sendUserOrderIdAndLocs(orderId: orderId!)
        }
        socket.on("getCars"){ data, ack in
            if let cars: [SDriverData] = self.parseSocketData(data: data, type: [SDriverData].self) {
                DispatchQueue.main.async {
                    self.sDriverLists = cars
                }
            }
        }
        
        socket.on("listen-order") { [weak self] data, ack in
            guard let self = self else { return }
            print("Received listen-order event: \(data)")
            
            if let orderInfo: SOrderInfo = self.parseSocketData(data: data, type: SOrderInfo.self) {
                DispatchQueue.main.async {
                    self.sOrderInfo = orderInfo
                }
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
