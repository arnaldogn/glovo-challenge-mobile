//
//  APIManager.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Decodable>(url: String, completion: @escaping (T?, Error?) -> ())
}

class APIManager: APIManagerProtocol {
    internal func request<T: Decodable>(url: String, completion: @escaping (T?, Error?) -> ()) {
        let components = URLComponents(string: url)
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (dataResponse, response, error) in
            DispatchQueue.main.async {
                guard let dataResponse = dataResponse else { return completion(nil, error) }
                let decoder = JSONDecoder()
                let collection = try? decoder.decode(T.self, from: dataResponse)
                completion(collection, nil)
            }
        }
        task.resume()
    }
}
