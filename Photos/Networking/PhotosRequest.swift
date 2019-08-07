//
//  PhotosRequest.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Represents a request to get a list of photos.
struct PhotosRequest: Request {
    private let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    
    // MARK: - Request
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
}
