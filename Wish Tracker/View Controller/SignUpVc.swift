//
//  SignUpVc.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for user signup
// User Input is full name, email id and password
// Redirect to login page if registration is successfull

import UIKit
import CoreData

class SignUpVc: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet var txtFullName: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
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
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Action
//  popViewController back button click
    @IBAction func onBtnBack(_ Sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//  signup button click and storing data on database
    @IBAction func onBtnSignup(_ Sender: UIButton) {
        if txtFullName.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter your full name.")
        } else if txtEmail.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter email address.")
        } else if !isValidEmail(txtEmail.text!) {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter valid email address.")
        } else if txtPassword.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter password.")
        } else if checkEmailAddressIsExist(email: txtEmail.text!.lowercased()) {
            let context = AppDelegate.shared.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            let registerUser = NSManagedObject(entity: entity!, insertInto: context)
            
            registerUser.setValue(txtEmail.text?.lowercased(), forKey: "email")
            registerUser.setValue(txtPassword.text?.lowercased(), forKey: "password")
            registerUser.setValue(txtFullName.text?.lowercased(), forKey: "fullName")
            registerUser.setValue(String(Date().timeIntervalSince1970), forKey: "userId")
            
            do {
                try context.save()
            } catch {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Signup unsuccessful.")
                print("Failed saving")
            }
            
            
            let alertController = UIAlertController(title: "Wish Tracker", message: "Signup successfully.", preferredStyle: UIAlertController.Style.alert)

            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            { action -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Email address already in used. \nPlease use different email address.")
        }
    }

//  check email is valid or not
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
