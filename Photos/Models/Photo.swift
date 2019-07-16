//
//  Photo.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
