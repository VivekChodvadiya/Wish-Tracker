//
//  LoginVc.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for user login
// User Input is full email id and password
// Redirect to home page is email and password is matched with database

import UIKit
import CoreData

class LoginVc: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // https://stackoverflow.com/a/47726035
//  check username and password on database and do login
    func checkForUserNameAndPasswordMatch() {
        
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        
        let predicate = NSPredicate(format: "email = %@", txtEmail.text!.lowercased())
        
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                let data = result[0] as! NSManagedObject
                
                let email = data.value(forKey: "email") as! String
                let password = data.value(forKey: "password") as! String
                let userId = data.value(forKey: "userId") as! String
                
                if email == txtEmail.text?.lowercased() && password == txtPassword.text?.lowercased() {
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter valid email or password.")
                }
                
            } else {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter valid email or password.")
            }
            
        } catch {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: fetch_error.localizedDescription)
        }
        
    }
    
    // MARK: - Action
//  check validation and auth user
    @IBAction func onBtnLogin(_ Sender: UIButton) {
        if txtEmail.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter email address.")
        } else if !isValidEmail(txtEmail.text!) {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter valid email address.")
        } else if txtPassword.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter password.")
        } else {
            checkForUserNameAndPasswordMatch()
        }
    }
    
//  open signup screen on signup button click
    @IBAction func onBtnSignup(_ Sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVc") as! SignUpVc
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  open forgot password screen on forot password label click
    @IBAction func onBtnForgotPassword(_ Sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  check email valid or not
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
