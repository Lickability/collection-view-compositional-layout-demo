//
//  Networking.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Describes a type capable of making network requests.
protocol Networking {
    
    /// Performs the specified request.
    /// - Parameter request: The request to perform.
    /// - Parameter completion: Closure called upon success or failure.
    func performRequest<T: Decodable>(_ request: Request, completion: @escaping (Result<T, NetworkError>) -> Void)
}
