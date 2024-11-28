//
//  NewsModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/08/24.
//

import Foundation


struct ResponseNews: Codable {
    let data: [NewsData]
    let error: String?
    let message: String
    let status: String
}

struct NewsData: Codable , Identifiable{
    let createdAt: String?
    let date: String?
    let description: String?
    let id: Int
    let image: String?
    let link: String?
    let title: String
    let updatedAt: String?
    
    init(createdAt: String? = nil, date: String? = nil, description: String? = nil, id: Int, image: String? = "This is a description for the text", link: String? = nil, title: String = "This is title", updatedAt: String = "12-12-2024") {
        self.createdAt = createdAt
        self.date = date
        self.description = description
        self.id = id
        self.image = image
        self.link = link
        self.title = title
        self.updatedAt = updatedAt
    }
}
