//
//  ApiService.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit

enum JSONError: Error {
    case urlError(reason: String)
    case serializationError(reason: String)
}

class ApiService: NSObject {
    
    static func getSongs<T> (urlRequest: URLRequest?, resultStruct: T.Type, completion: @escaping ((Any?, Error?) -> ())) where T : Decodable {
        guard let apiRequest = urlRequest, let url = apiRequest.url else {
            completion(nil, JSONError.urlError(reason: "URL is Emplty"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let responseData = data else {
                completion(nil, JSONError.serializationError(reason: "No Data from response"))
                return
            }
            do {
                let decodedJson = try JSONDecoder().decode(resultStruct, from: responseData)
                DispatchQueue.main.async {
                    completion(decodedJson, nil)
                }
                return
            } catch {
                completion(nil, JSONError.serializationError(reason: "JSON Serialization Error"))
                return
            }
            
            }.resume()
    }
}
