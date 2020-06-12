//
//  PhotoCell.swift
//  Photos
//
//  Created by Michael Liberatore on 7/17/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import UIKit
import Kingfisher

/// Represents a single photo.
final class PhotoCell: UICollectionViewCell {
    
	/// Encapsulates the properties required to display the contents of the cell.
    struct ViewModel {
		
		/// A unique identifier associated with the image displayed in the cell.
        let identifier: Int
		
		/// The URL of the image displayed in the cell.
        let imageURL: URL
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
	/// The cell’s view model. Setting the view model updates the display of the cell contents.
    var viewModel: ViewModel? {
        didSet {
			imageView.kf.cancelDownloadTask()
            imageView.kf.setImage(with: viewModel?.imageURL)
        }
    }
}
