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
    
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
	
	// MARK: - UIViewController
    
    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        flowLayout?.minimumInteritemSpacing = 5
        flowLayout?.minimumLineSpacing = 5
        flowLayout?.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        networkController.performRequest(PhotosRequest()) { [weak self] (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PhotosCollectionViewController {
	
	// MARK: - UICollectionViewDataSource
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
             return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.item]
        cell.viewModel = PhotoCell.ViewModel(identifier: photo.id, imageURL: photo.thumbnailUrl)
        
        return cell
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	// MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = 5
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
