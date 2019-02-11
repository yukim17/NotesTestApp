//
//  NetworkManager.swift
//  NotesTestApp
//
//  Created by Екатерина on 03.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func requestWith(method: String, completion : @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) {
        let url = URL(string: Config.baseURL)
        var request = URLRequest(url: url!)
        request.setValue(Config.token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        let parameters = "a=\(method)"
        request.httpBody = parameters.data(using: .utf8)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        dataTask.resume()
    }
    
    func requestWith(params: [String : String], method: String, completion : @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) {
        let url = URL(string: Config.baseURL)
        var request = URLRequest(url: url!)
        request.setValue(Config.token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        var parameters = "a=\(method)"
        for param in params {
            parameters = parameters + "&\(param.key)=\(param.value)"
        }
        request.httpBody = parameters.data(using: .utf8)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        dataTask.resume()
    }
}
