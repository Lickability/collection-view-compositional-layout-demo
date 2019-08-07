//
//  NetworkError.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Possible errors in networking that may occur.
enum NetworkError: Error {
    
    /// Data was expected, but no data was present in the response.
    case noData
    
    /// There was an error decoding the data.
    case decodingError(Error)
    
    /// Another type of networking error occurred.
    case otherNetworkingError(Error)
}
