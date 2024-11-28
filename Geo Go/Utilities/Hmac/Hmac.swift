//
//  Hmac.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import Foundation

class NaiveHmacSigner {

    static func hmac(algorithm: CCHmacAlgorithm, secret: Data, data: String) -> Data {
        let key = secret
        let data = data.data(using: .utf8)!
        
        var result = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        result.withUnsafeMutableBytes { resultBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    CCHmac(algorithm, keyBytes.baseAddress, key.count, dataBytes.baseAddress, data.count, resultBytes.baseAddress)
                }
            }
        }
        return result
    }

    static func dateSignature() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }

    static func authSignature(id: Int, key: String, method: String, path: String) -> String {
        let identity = String(id)
        guard let secret = Data(base64Encoded: key) else { return "Invalid key" }
        
        let date = dateSignature()
        let nonce = String(Int(Date().timeIntervalSince1970 * 1000))
        
        let data = method + path + date + nonce
        let digest = hmac(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), secret: secret, data: data).base64EncodedString()
        
        return "hmac \(identity):\(nonce):\(digest)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


