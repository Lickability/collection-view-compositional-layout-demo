//
//  PhotosDataSource.swift
//  Photos
//
//  Created by Michael Liberatore on 8/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import UIKit

/// The data source associated with a list of photos.
class PhotosDataSource: NSObject {
	
	/// Represents a section in the data source.
	struct Section {
		
		/// Represents an item in the data source.
		struct Item {
			
			/// The unique identifier of the item.
			let identifier: Int
			
			/// The title associated with the item.
			let title: String
			
			/// The URL for the item’s thumbnail photo.
			let thumbnailURL: URL
		}
		
		/// The items that comprise the section.
		let items: [Item]
	}
	
	/// The sections that comprise the data source.
	let sections: [Section]
	
	/// Describes the ways that items can be distributed across sections.
	enum SectionStyle {
		
		/// Items are all found in one section.
		case single
		
		/// Items are distributed across multiple sections based on their album identifier.
        case byAlbum(maximumItemsPerAlbum: Int?, maximumNumberOfAlbums: Int?)
	}
	
	/// Creates a new instance of `PhotosDataSource`.
	/// - Parameter photos: The photo models that comprise the data source.
	/// - Parameter sectionStyle: How items are distributed across sections.
	init(photos: [Photo], sectionStyle: SectionStyle) {
		switch sectionStyle {
		case .single:
			self.sections = [Section(items: photos.map { Section.Item(identifier: $0.id, title: $0.title, thumbnailURL: $0.thumbnailUrl)})]
			
        case .byAlbum(let maximumItemsPerAlbum, let maximumNumberOfAlbums):
			var sectionNumberToItems: [Int: [Section.Item]] = [:]
			
			for photo in photos {
				let item = Section.Item(identifier: photo.id, title: photo.title, thumbnailURL: photo.thumbnailUrl)
				
				if let existingItems = sectionNumberToItems[photo.albumId] {
					sectionNumberToItems[photo.albumId] = existingItems + [item]
				} else {
					sectionNumberToItems[photo.albumId] = [item]
				}
			}
			
			let sortedKeys = sectionNumberToItems.keys.sorted()
			
			var sections: [Section] = []
            for key in Array(sortedKeys.prefix(maximumNumberOfAlbums ?? sortedKeys.count)) {
				guard let items = sectionNumberToItems[key] else { continue }
                sections.append(Section(items: Array(items.prefix(maximumItemsPerAlbum ?? items.count))))
			}
			
			self.sections = sections
		}
		
				
		super.init()
	}
}

extension PhotosDataSource: UICollectionViewDataSource {
	
	// MARK: - UICollectionViewDataSource
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[section].items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
             return UICollectionViewCell()
        }
        
		let photo = sections[indexPath.section].items[indexPath.item]
        cell.viewModel = PhotoCell.ViewModel(identifier: photo.identifier, imageURL: photo.thumbnailURL)
        
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "header":
		guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as? HeaderSupplementaryView else {
			return HeaderSupplementaryView()
		}
		
		headerView.viewModel = HeaderSupplementaryView.ViewModel(title: "Section \(indexPath.section + 1)")
		return headerView
        
        case "new-banner":
            let bannerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewBannerSupplementaryView", for: indexPath)
            bannerView.isHidden = indexPath.row % 5 != 0 // show on every 5th item
            return bannerView
        
        default:
            assertionFailure("Unexpected element kind: \(kind).")
            return UICollectionReusableView()
        }
	}
}
