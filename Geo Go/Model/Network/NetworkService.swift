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
        
        if isPrintable {
            print("inside of sendRequest function")
        }
        
        var urlComponents = URLComponents(string: url != nil ? url! : baseUrl)
        
        if let path = path {
            urlComponents?.path += "/" + path
        }
        if isPrintable {
            print("inside of sendRequest function 2")
        }
        if let params = params {
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems
        }
        if isPrintable {
            print("inside of sendRequest function 3")
        }
      
        guard let url = urlComponents?.url else {
            completed(.failure(.invalidURL))
            return
        }
        
        if isPrintable {
            print("inside of sendRequest function 4")
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if isPrintable {
            print("inside of sendRequest function 5")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = body
        }
        
        if isPrintable{
            print("Url Data \(url)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let er = error {
                completed(.failure(.unableToComplete))
                return
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
