//
//  Request.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Describes a request.
protocol Request {
    
    /// A `URLRequest` representation of the receiver.
    var urlRequest: URLRequest { get }
}
