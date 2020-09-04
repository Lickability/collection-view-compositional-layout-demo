//
//  LayoutSelectionTableViewController.swift
//  Photos
//
//  Created by Michael Liberatore on 5/29/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import UIKit

/// Displays a table view with the ability to choose from various collection view layouts to display.
final class LayoutSelectionTableViewController: UITableViewController {
    
    private let networkController: Networking = URLSession.shared
    private var photos: [Photo] = []
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        networkController.performRequest(PhotosRequest()) { [weak self] (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                self?.photos = photos
                print("Set photos")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - LayoutSelectionTableViewController
    
    // While the layouts declared in the following examples have common code,
    // we deliberately are repeating ourselves for readability in demonstrating
    // how to build each layout from start to finish.
    
    // MARK: Flow Layout
    
    @IBSegueAction private func makeFlowLayoutViewController(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            return layout
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .single)
        return PhotosCollectionViewController(collectionViewLayout: flowLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Basic Grid
    
    @IBSegueAction private func makeBasicGridCompositionalLayoutViewController(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20)))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20)), subitems: [item])
            let section = NSCollectionLayoutSection(group: containerGroup)
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .single)
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Boundary Supplementary Items
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithHeaders(_ coder: NSCoder) -> PhotosCollectionViewController? {
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
            
            // Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: 9, maximumNumberOfAlbums: nil))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Item-Based Supplementary Items
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithItemBasedSupplementaryItems(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            let fraction: CGFloat = 1 / 3
            let inset: CGFloat = 8
                        
            // Supplementary Item
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(30))
            let containerAnchor = NSCollectionLayoutAnchor(edges: [.bottom], absoluteOffset: CGPoint(x: 0, y: 10))
            let supplementaryItem = NSCollectionLayoutSupplementaryItem(layoutSize: layoutSize, elementKind: "new-banner", containerAnchor: containerAnchor)

            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [supplementaryItem])
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .single)
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Background Decoration Items
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithBackgroundDecorations(_ coder: NSCoder) -> PhotosCollectionViewController? {
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
            let sectionInset: CGFloat = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
            
            // Decoration Item
            let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
            let backgroundInset: CGFloat = 8
            backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: backgroundInset, leading: backgroundInset, bottom: backgroundInset, trailing: backgroundInset)
            section.decorationItems = [backgroundItem]
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: "background")
            return layout
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: 9, maximumNumberOfAlbums: nil))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Per-Section Layout
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithPerSectionLayout(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemsPerRow = sectionIndex + 3
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
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: 9, maximumNumberOfAlbums: 50))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Environment-Based Layout
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithEnvironmentBasedLayout(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
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
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: 9, maximumNumberOfAlbums: 50))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Nested Groups
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithNestedGroups(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
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
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: nil, maximumNumberOfAlbums: nil))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Orthogonal Scrolling Behavior
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithOrthogonalScrollingBehavior(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
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
            section.orthogonalScrollingBehavior = .groupPaging
            
            // Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: nil, maximumNumberOfAlbums: nil))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
    
    // MARK: Zooming Carousel
    
    @IBSegueAction private func makeCompositionalLayoutViewControllerWithZoomingCarousel(_ coder: NSCoder) -> PhotosCollectionViewController? {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
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
        
        let dataSource = PhotosDataSource(photos: photos, sectionStyle: .byAlbum(maximumItemsPerAlbum: nil, maximumNumberOfAlbums: nil))
        return PhotosCollectionViewController(collectionViewLayout: compositionalLayout, dataSource: dataSource, coder: coder)
    }
}
