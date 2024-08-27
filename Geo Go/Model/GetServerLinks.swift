//
//  GetServerLinks.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation




struct GetServerLinks: Codable{
    let data: LinkData
    let error: Bool
    let message: String
}

struct LinkData: Codable {
    let chat_url: String
    let client_api_socket: String
    let client_body: String
    let client_info: String
    let client_news: String
    let client_lan: String
    let client_url: String
    let country: String
    let driver_body: String
    let driver_call_center: String
    let driver_reg: String
    let driver_socket: String
    let latitude: Double
    let longitude: Double
    let name: String
    let navi: String
    let reg_num_mask: String?
    let reverse: String
    let route: String
    let search: String
    let sign: String
    let socket: String
    let url: String
    let user_url: String
}
