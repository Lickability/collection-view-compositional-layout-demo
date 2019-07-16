//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import UIKit


final class PhotosCollectionViewController: UICollectionViewController {
    private let networkController: Networking = URLSession.shared
    
    override func viewDidLoad() {
        networkController.performRequest(PhotosRequest()) { (result: Result<[Photo], NetworkError>) in
            print(result)
        }
    }
}
