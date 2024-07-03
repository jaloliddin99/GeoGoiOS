//
//  RegistrationRequest.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 28/06/24.
//

import Foundation



struct RegisterUserResponse: Codable{
    let id: Int?
    let code: Int?
    let message: String?
}
struct RegistrationRequest: Codable{
    let confirmationType: String
    let phone: String
    let info: ClientInfo
}

struct ClientInfo: Codable{
    let firstName: String
}


struct ConfirmMessageResponse: Codable, Equatable{
    let id : Int64
    let key : String
}
