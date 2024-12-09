//
//  SocketManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/11/24.
//
import Foundation
import SocketIO

class CustomSocketManager: ObservableObject {
    static let shared = CustomSocketManager()
    var socket: SocketIOClient!
    
    private init() {
        let socketManager = SocketManager(
            socketURL: URL(string: "http://185.224.219.1:3007")!,
            config: [
                .log(true),
                .compress
            ]
        )
        socket = socketManager.defaultSocket
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
    
    func on(event: String, completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket.on(event, callback: completion)
    }
    
    func emit(event: String, data: [String: Any]) {
        guard socket.status == .connected else {
            print("Cannot emit. Socket is not connected.")
            return
        }
        socket.emit(event, data)
    }
    
}
