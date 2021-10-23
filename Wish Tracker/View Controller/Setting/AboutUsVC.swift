//
//  AboutUsVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for AboutUsVC

import UIKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var txtAboutUs: UITextView!
    
//  set txtContactUs text
    override func viewDidLoad() {
        super.viewDidLoad()

        txtAboutUs.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    }
    
    // MARK: - Actions
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
