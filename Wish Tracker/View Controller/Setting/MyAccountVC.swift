//
//  MyAccountVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for My account page
// Input is full name and Mobile number, email field is disable as we are using as uniq id
// fetch data from database as per userid
// update data on database on click of save button

import UIKit
import CoreData

class MyAccountVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.isEnabled = false
        
        getUserProfileData()
    }
    
//  fetch data from database as per UserId and filldata to txtEmail, txtFullName and txtMobileNumber
    func getUserProfileData() {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        let userId = UserDefaults.standard.object(forKey: "userId") as! String
        
        let predicate = NSPredicate(format: "userId = %@", userId)
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let data = result[0] as! NSManagedObject
            
            let email = data.value(forKey: "email") as! String
            let fullName = data.value(forKey: "fullName") as? String ?? ""
            let mobileNumber = data.value(forKey: "mobileNumber") as? String ?? ""
            
            self.txtEmail.text = email
            self.txtFullName.text = fullName
            self.txtMobileNumber.text = mobileNumber
            
        } catch {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: fetch_error.localizedDescription)
        }
    }
    
//  update userdata to database as per userid
    func updateUserData() {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let entity:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        let userId = UserDefaults.standard.object(forKey: "userId") as! String
        
        let predicate = NSPredicate(format: "userId = %@", userId)
        
        do {
            let test = try context.fetch(entity)
            
            let updateUserObject = test[0] as! NSManagedObject
            updateUserObject.setValue(txtMobileNumber.text, forKey: "mobileNumber")
            updateUserObject.setValue(txtFullName.text, forKey: "fullName")

            do {
                try context.save()
                
                let alertController = UIAlertController(title: "Wish Tracker", message: "Account details updated successfully.", preferredStyle: UIAlertController.Style.alert)

                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                { action -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alertController, animated: true, completion: nil)
                
            } catch {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Failed to update data")
                print("Failed saving")
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Action
//  popViewController on click of back button
    @IBAction func onBtnBack(_ Sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//  save button click
    @IBAction func onBtnSave(_ Sender: UIButton) {
        updateUserData()
    }
}
