//
//  ChatModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/12/24.
//

import Foundation


struct ChatMessage: Codable {
    let createdAt: String
    let fromUser: String
    let id: Int
    let isDelete: Bool
    let isRead: Bool
    let isReadDate: String
    let message: String
    let orderId: String
    let toUser: String
    let translatedMessage: String
    let updatedAt: String
    let userChatId: Int
    
    func toMessageObject(mePhoneNumber: String) -> MessageObject {
        let isMe = self.fromUser == mePhoneNumber
        return MessageObject(
            creatorId: mePhoneNumber,
            message: message,
            messageId: id,
            chatDate: createdAt,
            isMe: isMe,
            isRead: isRead,
            isDelete: isDelete
        )
    }
}

struct MessageObject: Codable {
    let creatorId: String
    let message: String
    let messageId: Int
    let chatDate: String
    let isMe: Bool
    let isRead: Bool
    let isDelete: Bool
}

struct ModelChat: Codable {
    let chatMessages: [ChatMessage]?
    let createdAt: String
    let firstUser: String
    let id: Int
    let isDelete: Bool
    let orderId: String
    let secondUser: String
    let type: String
    let updatedAt: String
}

struct ModelChatReceive: Codable {
    let createdAt: String
    let fromUser: String
    let id: Int
    let isDelete: Bool
    let isRead: Bool
    let isReadDate: Bool?
    let message: String
    let orderId: String
    let toUser: String
    let translatedMessage: String?
    let updatedAt: String
    let userChatId: Int
}
