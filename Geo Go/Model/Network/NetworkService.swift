//
//  NetworkService.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation

import UIKit

class NetworkService{
    static let shared = NetworkService()
    
    private let cache = NSCache<NSString, UIImage>()
    private let baseUrl = "http://botmaker.uz:7777/server/get"
    
    func sendRequest<T: Decodable>(
        url: String? = nil,
        path: String? = nil,
        params: [String: String]? = nil,
        body: Data? = nil,
        method: String = "GET",
        headers: [String: String]? = nil,
        isPrintable: Bool = false,
        completed: @escaping (Result<T, APError>) -> Void
    ) {
        var urlComponents = URLComponents(string: url != nil ? url! : baseUrl)
        
        if let path = path {
            urlComponents?.path += "/" + path
        }
        
        if let params = params {
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            completed(.failure(.invalidURL))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = body
        }
        
        if isPrintable{
            print("Url Data \(url)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            if isPrintable {
                print("HTTP response : \(String(describing: response))")
            }
            
        
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            if isPrintable{
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
            }
           
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                print("Error occurred: \(error)")
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void ) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    
    
    
    
}
