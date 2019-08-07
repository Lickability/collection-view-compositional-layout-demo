//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Michael Liberatore on 7/16/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import UIKit

/// Displays a list of photos in a collection view.
final class PhotosCollectionViewController: UICollectionViewController {
    private let networkController: Networking = URLSession.shared
    private var photos: [Photo] = []
	
	private var dataSource: PhotosDataSource? {
		didSet {
			collectionView.dataSource = dataSource
			collectionView.reloadData()
		}
	}
	
	// MARK: - UIViewController
    
    override func viewDidLoad() {
        
        networkController.performRequest(PhotosRequest()) { [weak self] (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
					guard let self = self else {
						return
					}
					
					self.dataSource = PhotosDataSource(photos: photos, sectionStyle: .single, collectionView: self.collectionView)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
