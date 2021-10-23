//
//  ForgotPasswordVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used Forgot password
// Match email with database and if email is matching then redirect to changepassword screen

import UIKit
import CoreData

class ForgotPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//   checkEmailAddressIsExist or not for new users
    func checkEmailAddressIsExist(email: String) -> Bool {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        
        let res = try! context.fetch(fetchRequest)
        
        for data in res as! [NSManagedObject] {
            let oldEmail = data.value(forKey: "email") as! String
            print("email address: ", oldEmail)
            
            if oldEmail == email {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ Sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//  forgot password button click
    @IBAction func onBtnSend(_ Sender: UIButton) {
        if txtEmail.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter your register email address.")
        } else {
            if checkEmailAddressIsExist(email: txtEmail.text!.lowercased()) {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                vc.userEmail = txtEmail.text!.lowercased()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter your valid register email address.")
            }
        }
    }
}
