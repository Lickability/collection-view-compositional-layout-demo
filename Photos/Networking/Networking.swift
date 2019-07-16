//
//  Networking.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

protocol Networking {
    func performRequest<T: Decodable>(_ request: Request, completion: @escaping (Result<T, NetworkError>) -> Void)
}
