//
//  NetworkError.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodingError(Error)
    case otherNetworkingError(Error)
}
