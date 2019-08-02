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
		case byAlbum
	}
	
	init(photos: [Photo], sectionStyle: SectionStyle, collectionView: UICollectionView) {
		switch sectionStyle {
		case .single:
			self.sections = [Section(items: photos.map { Section.Item(identifier: $0.id, title: $0.title, thumbnailURL: $0.thumbnailUrl)})]
			
		case .byAlbum:
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
			for key in sortedKeys {
				guard let items = sectionNumberToItems[key] else { continue }
				sections.append(Section(items: items))
			}
			
			self.sections = sections
		}
		
				
		super.init()
		
		registerCells(in: collectionView)
	}
	
	private func registerCells(in collectionView: UICollectionView) {
		collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
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
}
