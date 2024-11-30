//
//  SocketViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//

import SwiftUI
import SocketIO

class SocketViewModel: ObservableObject {
    private let socketManager = CustomSocketManager.shared
    var socket: SocketIOClient!
    
    init() {
        setupListeners()
        socket = socketManager.socket
    }
    
    func connect() {
        socketManager.connect()
    }
    
    func disconnect() {
        socketManager.disconnect()
    }
    
    
    private func setupListeners() {
        socketManager.on(event: "chat message") { [weak self] data, _ in
            guard let self = self else { return }
            if let message = data.first as? String {
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        let message = Message(
            lat: DataHolder.location.latitude,
            long: DataHolder.location.longitude,
            userId: getUserPhone(),
            type: "all"
        )
        
        if let messageData = message.toDictionary() {
            socket.emit("user", messageData)
        } else {
            print("Failed to convert message to dictionary")
        }

        socketManager.on(event: "connect") { _, _ in
            print("Connected to the server")
        }
        
        socketManager.on(event: "disconnect") { _, _ in
            print("Disconnected from the server")
        }
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
}
