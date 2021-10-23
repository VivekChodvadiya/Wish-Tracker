//
//  ChangePasswordVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used Change password
// Input is old password, new password and confirm new password
// redirect to login page if password changed successfully

import UIKit
import CoreData

class ChangePasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viwOldPassword: UIView!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var userEmail = ""
    
//  manage this bool for is user comming from change password screen or login screen
    var isFromChangePassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//      if isFromChangePassword true then hide old password field
        if isFromChangePassword {
            viwOldPassword.isHidden = false
        } else {
            viwOldPassword.isHidden = true
        }
    }
    
//  changeUserPassword functionality
    func changeUserPassword() {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let entity:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "email = %@", userEmail)
        entity.predicate = predicate
        
        do {
            let test = try context.fetch(entity)
            
            if test.count > 0 {
                let updateUserObject = test[0] as! NSManagedObject
                updateUserObject.setValue(txtNewPassword.text, forKey: "password")

                do {
                    try context.save()
                    
                    let alertController = UIAlertController(title: "Wish Tracker", message: "Password changed successfully.", preferredStyle: UIAlertController.Style.alert)

                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    { action -> Void in
                        if self.isFromChangePassword {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.goToLoginPage()
                        }
                    })
                    self.present(alertController, animated: true, completion: nil)
                    
                } catch {
                    AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Failed to change password.")
                    print("Failed saving")
                }
            } else {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Something went wrong. Please try again after some times.")
            }
            
        } catch {
            print(error)
        }
    }
    
//  check database for old password is valid or not
    func checkOldPasswordValidOrNot(email: String, oldEnteredPassword: String) -> Bool {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        
        let res = try! context.fetch(fetchRequest)
        
        if res.count > 0 {
            for data in res as! [NSManagedObject] {
                let oldEmail = data.value(forKey: "email") as! String
                let oldPassword = data.value(forKey: "password") as! String
                print("email address: ", oldEmail)
                
                if oldEmail == email && oldPassword == oldEnteredPassword {
                    return true
                }
            }
        }
        
        return false
    }
    
//  redirect to login page
    func goToLoginPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVc.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ Sender: UIButton) {
        self.goToLoginPage()
    }
    
//  check validation and change user password on submit button click
    @IBAction func onBtnSubmit(_ Sender: UIButton) {
        if isFromChangePassword && txtOldPassword.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter old password.")
        } else if txtNewPassword.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter new password.")
        } else if txtConfirmNewPassword.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter confirm password.")
        } else if txtNewPassword.text! != txtConfirmNewPassword.text! {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Password and confirm password not match.")
        } else {
            if isFromChangePassword {
                if checkOldPasswordValidOrNot(email: userEmail, oldEnteredPassword: txtOldPassword.text!) {
                    changeUserPassword()
                } else {
                    AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Your old password is incorrect.")
                }
            } else {
                changeUserPassword()
            }
        }
    }
}
