//
//  NetworkError.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation



enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}


enum APError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}
