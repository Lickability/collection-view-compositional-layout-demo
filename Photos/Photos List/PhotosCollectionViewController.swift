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
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	private let multiSectionCompositionalLayout: UICollectionViewCompositionalLayout = {
		return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
			let countPerRow = environment.traitCollection.horizontalSizeClass == .compact ? sectionIndex + 3 : (sectionIndex + 3) * 2
			
			// Item
			let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .fractionalHeight(1))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
			
			// Group
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.0 / CGFloat(countPerRow)))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: countPerRow)
			
			let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: "header", alignment: .top)
			supplementaryItem.pinToVisibleBounds = true
			
			// Section
			let section = NSCollectionLayoutSection(group: group)
			section.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
			section.boundarySupplementaryItems = [supplementaryItem]
			
			return section
		}
	}()
	
	private let nestedGroupCompositionalLayout: UICollectionViewCompositionalLayout = {
		// Item
		let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
		largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
		
		let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
		smallItem.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
		
		// Inner Group
		let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
		let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smallItem])
		
		// Outer Group
		let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
		let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize, subitems: [largeItem, verticalGroup, verticalGroup])
		
		let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: "header", alignment: .top)
		
		// Section
		let section = NSCollectionLayoutSection(group: mainGroup)
		section.boundarySupplementaryItems = [supplementaryItem]
		section.orthogonalScrollingBehavior = .continuous
		
//		section.visibleItemsInvalidationHandler = { (items, point, something) in
//			items.forEach { $0.transform = CGAffineTransform(scaleX: abs(1 - (point.x / 1000)), y: abs(1 - (point.x / 1000))) }
//		}
		
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	private let zoomingCardLayout: UICollectionViewCompositionalLayout = {
		let fraction: CGFloat = 1.0 / 3.0
		
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: "header", alignment: .top)

		// Section
        let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
		section.boundarySupplementaryItems = [supplementaryItem]
		section.orthogonalScrollingBehavior = .continuous
		section.visibleItemsInvalidationHandler = { (items, offset, _) in
			guard items.count > 3 else { return }
			print("frame x: \(items[3].frame.midX)")
			print("offset x: \(offset.x)")
//			print("frame: \(item.frame)")
//			print("bounds: \(item.bounds)")
//			for item in items where item.representedElementCategory == .cell {
//				print(offset)
//				print(
//				print("frame: \(item.frame)")
//				print("bounds: \(item.bounds)")
//			}
		}
        
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	// MARK: - UIViewController
    
    override func viewDidLoad() {
		collectionView.collectionViewLayout = zoomingCardLayout
		
        networkController.performRequest(PhotosRequest()) { [weak self] (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
					guard let self = self else {
						return
					}
					
					self.dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum, collectionView: self.collectionView)
                }
            case .failure(let error):
                print(error)
            }
        }
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
