//
//  SocketManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//

import Foundation
import SocketIO

enum SocketConnectionState {
    case connected
    case error
    case disconnected
    case reconnect
}

class CustomSocketManager: ObservableObject{
    static let shared = CustomSocketManager()

    
    var socket: SocketIOClient!
    @Published var connectionState: SocketConnectionState = .disconnected
    @Published var socketData: String = "No data yet"
    
    
    init() {
        let socketURL = URL(string: "http://185.224.219.1:3007/")!
        let socketManager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        
        socket = socketManager.defaultSocket
        
        setupSocket()
    }
    
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    
    func on(event: String, completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket?.on(event, callback: completion)
    }
    
    private func setupSocket() {
        socket.on(clientEvent: .connect) { _, _ in
            print("================ connected")
            
            DispatchQueue.main.async {
                self.connectionState = .connected
            }
        }
        socket.on(clientEvent: .error) { _, _ in
            print("================ error")
            
            DispatchQueue.main.async {
                self.connectionState = .error
            }
        }
        socket.on(clientEvent: .disconnect) { _, _ in
            print("================ disconnected")
            
            DispatchQueue.main.async {
                self.connectionState = .disconnected
            }
        }
        socket.on(clientEvent: .reconnect) { _, _ in
            print("================ reconnect")
            DispatchQueue.main.async {
                self.connectionState = .reconnect
            }
        }
        socket.on(clientEvent: .statusChange) { _, _ in
            print("================ statusChange")
            DispatchQueue.main.async {
                self.connectionState = .reconnect
            }
        }
        
        socket.connect()
        
    }
    
    
    
}
