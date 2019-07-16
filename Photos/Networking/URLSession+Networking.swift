//
//  URLSession+Networking.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

extension URLSession: Networking {
    
    // MARK: - Networking
    
    func performRequest<T: Decodable>(_ request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) {
        dataTask(with: request.urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(.otherNetworkingError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
