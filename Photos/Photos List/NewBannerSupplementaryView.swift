//
//  NewBannerSupplementaryView.swift
//  Photos
//
//  Created by Michael Liberatore on 6/5/20.
//  Copyright © 2020 Lickability. All rights reserved.
//

import UIKit

/// A supplementary banner view containing the text "NEW".
final class NewBannerSupplementaryView: UICollectionReusableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
}
