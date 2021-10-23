//
//  IntroductionCollectionViewCell.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This Cell View is used for display images in pager

import UIKit

class IntroductionCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgIntroduction: UIImageView!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
