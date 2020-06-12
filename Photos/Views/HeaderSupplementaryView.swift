//
//  HeaderSupplementaryView.swift
//  Photos
//
//  Created by Michael Liberatore on 8/2/19.
//  Copyright © 2019 Lickability. All rights reserved.
//

import UIKit

/// A very basic supplementary view that displays a title.
final class HeaderSupplementaryView: UICollectionReusableView {
	
	/// Encapsulates the properties required to display the contents of the view.
	struct ViewModel {
		
		/// The title to display in the view.
		let title: String
	}
	
	@IBOutlet private weak var label: UILabel!
	
	/// The cell’s view model. Setting the view model updates the display of the view’s contents.
	var viewModel: ViewModel? {
		didSet {
			label.text = viewModel?.title
		}
	}
}
