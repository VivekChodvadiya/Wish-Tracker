//
//  MyWishesTableViewCell.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This Cell View is used for My wishes list

import UIKit

class MyWishesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet private weak var viwMainContainer: UIView!
    
    // MARK: - Properties
    
    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
