//
//  BackgroundSupplementaryView.swift
//  Photos
//
//  Created by Michael Liberatore on 5/15/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import UIKit

/// A basic decoration view used for section backgrounds.
final class BackgroundDecorationView: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layer.cornerRadius = 8
		backgroundColor = UIColor(white: 0.85, alpha: 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
