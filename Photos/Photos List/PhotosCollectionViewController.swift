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
	
	private let flowLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
		layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		return layout
	}()
	
	private let compositionalLayout: UICollectionViewCompositionalLayout = {
		let fraction: CGFloat = 1.0 / 3.0
		
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		// Section
        let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
		
        
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	// MARK: - UIViewController
    
    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
		collectionView.collectionViewLayout = compositionalLayout
		
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

//		let width = collectionView.bounds.width
//		let numberOfItemsPerRow: CGFloat = 3
//		let itemDimension = floor(width / numberOfItemsPerRow)
//      return CGSize(width: itemDimension, height: itemDimension)
    }
}
