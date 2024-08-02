//
//  GenerateResponse.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import Foundation



struct GenerateReturn {
    var data: String
    var hmac: String
    var url: String
}

struct MethodGenerate {
    let type: String
    let url: String
    var id: String
}

class GenerateResponse {
    private var userId: Int
    private var userToken: String
    private var mainUrl: String

    init(userId: Int, userToken: String, mainUrl: String) {
        self.userId = userId
        self.userToken = userToken
        self.mainUrl = mainUrl
    }

    func localList() -> [MethodGenerate] {
        return [
            MethodGenerate(type: "POST", url: "/api/client/mobile/4.0/orders", id: "orders"),
            MethodGenerate(type: "POST", url: "/api/client/mobile/1.0/promo-code-activations", id: "activations"),
            MethodGenerate(type: "GET", url: "/api/client/mobile/2.0/history", id: "history"),
            MethodGenerate(type: "GET", url: "/api/client/mobile/2.0/orders", id: "ordersGet"),
            MethodGenerate(type: "POST", url: "/api/client/mobile/2.0/estimate", id: "estimate"),
            MethodGenerate(type: "POST", url: "/api/client/mobile/1.1/service", id: "getAvailableService"),
            MethodGenerate(type: "GET", url: "/api/client/mobile/2.1/bonuses", id: "bonuses"),
            MethodGenerate(type: "POST", url: "/api/client/mobile/1.0/registration/fcm", id: "firebase"),
            MethodGenerate(type: "POST", url: "/api/client/mobile/2.0/drivers", id: "drivers"),
            MethodGenerate(type: "GET", url: "/api/client/mobile/1.0/payment-methods", id: "payment")
        ]
    }

    func generateHmacData(id: String) -> GenerateReturn {
        let list = localList()
        var generateReturn = GenerateReturn(data: "", hmac: "", url: "")
        for methodGenerate in list {
            if methodGenerate.id == id {
                let data = NaiveHmacSigner.dateSignature()
                let hmac = NaiveHmacSigner.authSignature(id: userId, key: userToken, method: methodGenerate.type, path: methodGenerate.url)
                let responseUrl = (id == "history") ? "\(mainUrl)\(methodGenerate.url.replacingOccurrences(of: "/api", with: ""))?offset=0&length=16" : "\(mainUrl)\(methodGenerate.url.replacingOccurrences(of: "/api", with: ""))"
                generateReturn = GenerateReturn(data: data, hmac: hmac, url: responseUrl)
            }
        }
        return generateReturn
    }
    
    
    func generateHmacDataForOrderId(id: String, orderId: Int64) -> GenerateReturn {
          var generateReturn = GenerateReturn(data: "", hmac: "", url: "")

          let data = NaiveHmacSigner.dateSignature()
          let pathSuffix: String
          let method: String

          switch id {
          case "position":
              method = "PUT"
              pathSuffix = "orders/\(orderId)/position"
          case "payment":
              method = "GET"
              pathSuffix = "payment-methods"
          case "cancelOrder":
              method = "DELETE"
              pathSuffix = "orders/\(orderId)"
          case "feedback":
              method = "POST"
              pathSuffix = "orders/\(id)/feedback" // Here, id is reused which looks like a potential issue in the original code.
          case "getOrderDetails":
              method = "GET"
              pathSuffix = "orders/\(orderId)"
          case "fix_order":
              method = "GET"
              pathSuffix = "orders/\(orderId)/fix-cost"
          case "finished":
              method = "GET"
              pathSuffix = "orders/\(orderId)/finished"
          case "editOrderRoute":
              method = "POST"
              pathSuffix = "orders/\(orderId)/route"
          case "editOptions":
              method = "POST"
              pathSuffix = "orders/\(orderId)/options"
          default:
              return generateReturn
          }

          let hmac = NaiveHmacSigner.authSignature(id: userId, key: userToken, method: method, path: "/api/client/mobile/1.0/\(pathSuffix)")
          let responseUrl = "\(mainUrl)/client/mobile/1.0/\(pathSuffix)"
          
          generateReturn = GenerateReturn(data: data, hmac: hmac, url: responseUrl)
          return generateReturn
      }

}
