//
//  MyWishDetailsVC.swift
//  Wish Tracker


// Author name : Vivek Chodvadiya
// This View controller is used for detail view of mywish
// Display all details of specific wish
// mark wish is completed functionality on click of mark to complete wish
// set isComplete bool as true on database when user click on mark wish complete button

import UIKit
import CoreData

class MyWishDetailsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblLocatin: UILabel!
    @IBOutlet private weak var imgWish: UIImageView!
    @IBOutlet private weak var lblLocatinHeader: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMarkToCompleteWish: UIButton!
    
    // MARK: - Properties
    var isFromFullFilledWish = false
    var wishObj: MyWish!
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromFullFilledWish {
            btnMarkToCompleteWish.isHidden = true
        }
        
        setData()
    }
    
//  set data to the view
    func setData() {
        lblTitle.text = wishObj.title
        lblDescription.text = wishObj.desc
        
        // https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        lblDate.text = formatter.string(from: wishObj.date)
        if !wishObj.location.isEmpty {
            lblLocatin.text = wishObj.location
        } else {
            lblLocatin.isHidden = true
            lblLocatinHeader.isHidden = true
        }
        imgWish.image = UIImage(data: (wishObj.wishImage))
    }
    
//  set isComplete bool as true on database when user click on mark wish complete button
    func markToCompleteWish() {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let entity:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WishList")
        entity.predicate = NSPredicate(format: "wishId = %@", wishObj.wishId)
        
        let userId = UserDefaults.standard.object(forKey: "userId") as! String
        
        do {
            let test = try context.fetch(entity)
            
            let updateWish = test[0] as! NSManagedObject
            updateWish.setValue(wishObj.wishId, forKey: "wishId")
            updateWish.setValue(wishObj.title, forKey: "title")
            updateWish.setValue(wishObj.desc, forKey: "desc")
            updateWish.setValue(userId, forKey: "userId")
            updateWish.setValue(Date(), forKey: "date")
            updateWish.setValue(true, forKey: "isComplete")
            
            do {
                try context.save()
                
                self.navigationController?.popViewController(animated: true)
                
            } catch {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Failed to update data")
                print("Failed saving")
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//    mark complete wish button click
    @IBAction private func onBtnMarkToCompleteWish(_ sender: UIButton) {
        markToCompleteWish()
    }
}

