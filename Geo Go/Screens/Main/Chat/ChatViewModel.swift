//
//  ChatViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/12/24.
//

import Foundation
import Combine
import SwiftUI
@_spi(Experimental) import MapboxMaps
import SocketIO

final class ChatViewModel: ObservableObject{
    
    @Published var messageObserver: [MessageObject] = []
   
    init() {
        setupSocket()
    }
    
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    
    
    private func setupSocket() {
        socketManager = SocketManager(
            socketURL: URL(string: "https://feed.geogo.io")!,
            config: [
                .log(false),
                .forceWebsockets(true),
                .reconnectAttempts(-1),
                .reconnectWait(10),
                .version(SocketIOVersion(rawValue: 2)!)
            ]
        )
        socket = socketManager.defaultSocket
        socket.on(clientEvent: .connect) { _, _ in
            guard let phone = UserDefaults.standard.string(forKey: Constants.USER_PHONE) else { return }
          
            print("chat socket connected ")
            guard let carNum = UserDefaults.standard.string(forKey: Constants.DRIVER_CAR_NUM) else { return }
            
            guard let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") else { return }
            
            self.setupChat(DataHolder.orderId, carNum, phone, fcmToken)
            self.startObserving(phone)
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
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    
    func setupChat(_ orderId: Int64, _ carNumber: String, _ phone: String, _ fToken: String) {
        print("setupChat started with orderId: \(orderId), carNumber: \(carNumber), phone: \(phone), fToken: \(fToken) ")

        let addUser: [String: Any] = [
            "userId": orderId,
            "userLan": DataHolder.lang,
            "firebaseToken": fToken
        ]
        socket.emit("addUser", addUser)
        
        DataHolder.messageList.removeAll()
        socket.off("getChat")
        socket.on("getChat") {  [weak self] data, ack in
            guard let self = self else { return }
            if let chat: ModelChat = parseSocketData(data: data, type: ModelChat.self) {
                
                print("getchat received")
                DataHolder.chatId = chat.id
                emitUnreadMessages(chat.id, phone)
                if let chatMessages: [ChatMessage] = chat.chatMessages {
                    
                    let list: [MessageObject] = chatMessages.map { message in
                        message.toMessageObject(mePhoneNumber: phone)
                    }
                    list.forEach { obj in
                        DataHolder.messageList.append(obj)
                    }
                }
                
                DataHolder.messageList.forEach { it in
                    if (!it.isMe && !it.isRead) {
                        self.readMessage(it.messageId)
                    }
                }
            }
            
        }
        
        socket.off("getUsers")
        socket.on("getUsers"){ data, d  in
            let createChat: [String: Any] = [
                "firstUser": phone,
                "secondUser": carNumber,
                "type": "withUser",
                "orderId": orderId
            ]
            self.socket.emit("createChat", createChat)
        }
    }
    
    private func emitUnreadMessages(_ chatId: Int, _ userId: String) {
        let createChat: [String: Any] = [
            "chatId": chatId,
            "userId": userId
        ]
        socket.emit("unreadMessages", createChat)
    }
    
    private func readMessage(_ messageId: Int) {
        let createChat: [String: Any] = [
            "messageId": messageId
        ]
        socket?.emit("readMessage", createChat)
    }
    
    func startObserving(_ phone: String){
        socket.off("getMessage")
        print("startObserving started")

        socket.on("getMessage") { [weak self] data, ack in
            guard let self = self else { return }
            if let it: ModelChatReceive = parseSocketData(data: data, type: ModelChatReceive.self) {
                print("startObserving arrived")

                let mePhoneNumber = phone
                let isMe = it.fromUser == mePhoneNumber
                emitUnreadMessages(DataHolder.chatId, phone)
                DataHolder.messageList.removeAll { obj in
                    obj.messageId == it.id
                }
                
                if (!isMe && !it.isRead) {
                    readMessage(it.id)
                }
                
                DataHolder.messageList.append(
                    MessageObject(
                        creatorId: it.fromUser,
                        message: it.message,
                        messageId: it.id,
                        chatDate: it.createdAt,
                        isMe: isMe,
                        isRead: it.isRead,
                        isDelete: it.isDelete
                    )
                )
                
                let newList1 = DataHolder.messageList
                    .sorted { $0.messageId < $1.messageId }
                    .reduce(into: [MessageObject]()) { uniqueList, message in
                        if !uniqueList.contains(where: { $0.messageId == message.messageId }) {
                            uniqueList.append(message)
                        }
                    }
                messageObserver = newList1
                
            }
           
        }
    }
    
    func sendMessage(_ orderId: Int64,
                     _ chatId: Int,
                     _ toUser: String,
                     _ message: String,
                     _ phone: String)
    {
        print("sendMessage is sent ")

        let sendMessage: [String: Any] = [
            "fromUser": phone,
            "toUser": toUser,
            "orderId": orderId,
            "chatId": chatId,
            "message": message
        ]
        socket.emit("sendMessage", sendMessage)
    }
    
    
    
    deinit {
        disconnect()
    }
    
}
