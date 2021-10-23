//
//  SettingVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for Setting page
// From this page redirect to Myaccount, Change password, AboutUs, contact us and logout

import UIKit

class SettingVC: UIViewController {
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action
//  popViewController onclick of backbutton
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//  Open MyAccountVC on click of My Account
    @IBAction func onBtnMyAccount(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  Open ChangePasswordVC on click of Change password
    @IBAction func onBtnChangePassword(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.isFromChangePassword = true
        vc.userEmail = UserDefaults.standard.object(forKey: "email") as! String
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  share app functionality on click of share button
    @IBAction func onBtnShare(_ sender: UIButton) {
        let text = "This is the text....."
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
//  Open AboutUsVC on click of AboutUs
    @IBAction func onBtnAboutUs(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  Open ContactUsVC on click of ContactUs
    @IBAction func onBtnContactUs(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  logout functionality on click of logout
//  remove saved object of userId and email
//  redirect to login page
    @IBAction func onBtnLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Wish Tracker", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "email")
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
