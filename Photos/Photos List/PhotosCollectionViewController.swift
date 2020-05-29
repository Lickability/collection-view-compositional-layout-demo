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
	
	let compositionalLayout: UICollectionViewCompositionalLayout = {
		let fraction: CGFloat = 1 / 3
		let inset: CGFloat = 2.5
		
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		// Section
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	private let compositionalLayoutWithSectionBackgrounds: UICollectionViewCompositionalLayout = {
		let fraction: CGFloat = 1 / 3
		let inset: CGFloat = 2.5

		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

		// Section
		let section = NSCollectionLayoutSection(group: group)
		let sectionInset: CGFloat = 16
		section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)

		// Decoration Item
		let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
		let backgroundInset: CGFloat = 8
		backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: backgroundInset, leading: backgroundInset, bottom: backgroundInset, trailing: backgroundInset)
		section.decorationItems = [backgroundItem]

		let layout = UICollectionViewCompositionalLayout(section: section)
		layout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: "background")

		return layout
	}()
	
	private let compositionalLayoutWithHeaders = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
		let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 3 : 6
		let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
		let inset: CGFloat = 2.5

		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

		// Section
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

		// Supplementary Item
		let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
		let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
		section.boundarySupplementaryItems = [headerItem]

		return section
	})
	
	private let nestedGroupCompositionalLayout: UICollectionViewCompositionalLayout = {
		let inset: CGFloat = 2.5

		// Items
		let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
		let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
		largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

		let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
		let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
		smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		
		// Nested Group
		let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
		let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
		
		// Outer Group
		let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
		let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup, nestedGroup])
		
		// Section
		let section = NSCollectionLayoutSection(group: outerGroup)
		section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		
		// Supplementary Item
		let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
		let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
		section.boundarySupplementaryItems = [headerItem]

		section.orthogonalScrollingBehavior = .groupPagingCentered
		
		// Uncomment for a fun animation when scrolling…
			section.visibleItemsInvalidationHandler = { (items, point, something) in
				items.forEach { $0.transform = CGAffineTransform(scaleX: abs(1 - (point.x / 1000)), y: abs(1 - (point.x / 1000))) }
			}
		
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	private let zoomingCardLayout: UICollectionViewCompositionalLayout = {
		let fraction: CGFloat = 1.0 / 3.0
		
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

		// Section
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 2.5, bottom: 0, trailing: 2.5)
		section.orthogonalScrollingBehavior = .continuous
		section.visibleItemsInvalidationHandler = { (items, offset, environment) in
			items.forEach { item in
				let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
				let minScale: CGFloat = 0.7
				let maxScale: CGFloat = 1.1
				let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
				item.transform = CGAffineTransform(scaleX: scale, y: scale)
			}
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
		let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
		return CGSize(width: itemDimension, height: itemDimension)
    }
}
