//
//  Photo.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import Foundation

/// Encapsulates properties associated with a uniquely identifiable photo with multiple sizes.
struct Photo: Decodable {
	
	/// An identifier for an album to which this photo belongs.
    let albumId: Int
	
	/// The unique identifier for the photo.
    let id: Int
	
	/// A title associated with the photo.
    let title: String
	
	/// The url for a 600x600 representation of the photo.
    let url: URL
	
	/// The url for a 150x150 repreentation of the photo.
    let thumbnailUrl: URL
}
