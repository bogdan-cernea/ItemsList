//
//  DataManager.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManager {
    
    static let shared = DataManager()
    var session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
    
    enum APIError: Error {
        case invalidStatusCode
        case missingResponseData
        case invalidResponseData
    }
    
    func getItems(completion: @escaping (Result<List, Error>) -> Void) -> URLSessionDataTask {
        let task = self.session.dataTask(with: self.url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.invalidStatusCode))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.missingResponseData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8),
                    let responseString = String(data: utf8Data, encoding: .utf8) {
                    let swiftyJsonVar = JSON(parseJSON: responseString)
                    //handle success
                    let jsonData = try swiftyJsonVar.rawData(options: .fragmentsAllowed)
                    let list = try decoder.decode(List.self, from: jsonData)
                    print(list)
                    completion(.success(list))
                } else {
                    completion(.failure(APIError.invalidResponseData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
}
