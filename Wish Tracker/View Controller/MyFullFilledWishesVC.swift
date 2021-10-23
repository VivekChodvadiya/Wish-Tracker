//
//  MyFullFilledWishesVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for my fullfiled wishes list
// fetch data from databases and display record according to isComplete bool

import UIKit
import CoreData

class MyFullFilledWishesVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblFullFilledWishList: UITableView!
    @IBOutlet weak var lblNoDataLabel: UILabel!
    
    // MARK: - Properties
    var arrWishList = [MyWish]()
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblFullFilledWishList.register(UINib(nibName: "MyWishesTableViewCell", bundle: nil), forCellReuseIdentifier: "MyWishesTableViewCell")
        tblFullFilledWishList.delegate = self
        tblFullFilledWishList.dataSource = self
        
        getWishList()
    }
    
//  fetch wishlist data from database
//  add data in arraylist
//  display data from arraylist
    func getWishList() {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WishList")
        let userId = UserDefaults.standard.object(forKey: "userId") as! String
        
        let predicate = NSPredicate(format: "userId = %@", userId)
        
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            
            self.arrWishList.removeAll()
            
            if result.count > 0 {
                for data in result as! [NSManagedObject] {
                    var dictionary = [String: Any]()
                    dictionary["wishId"] = data.value(forKey: "wishId") as! String
                    dictionary["userId"] = data.value(forKey: "userId") as! String
                    dictionary["title"] = data.value(forKey: "title") as! String
                    dictionary["desc"] = data.value(forKey: "desc") as! String
                    dictionary["isComplete"] = data.value(forKey: "isComplete") as! Bool
                    dictionary["date"] = data.value(forKey: "date") as! Date
                    if data.value(forKey: "location") != nil {
                        dictionary["location"] = data.value(forKey: "location") as!String
                    }
                    if data.value(forKey: "wishImage") != nil {
                        dictionary["wishImage"] = data.value(forKey: "wishImage") as! Data
                    }
                    
                    self.arrWishList.append(MyWish(data: dictionary))
                }
                
                self.arrWishList = self.arrWishList.filter { $0.isComplete == true }
                
                if self.arrWishList.count == 0 {
                    self.lblNoDataLabel.isHidden = false
                } else {
                    self.lblNoDataLabel.isHidden = true
                }
                
                self.tblFullFilledWishList.reloadData()
                
            } else {
                self.lblNoDataLabel.isHidden = false
                
                self.tblFullFilledWishList.reloadData()
            }
            
        } catch {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: fetch_error.localizedDescription)
        }
    }
    
//  delete record from database as per wishId
    func deleteMyWishData(wishId: String) {
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "WishList")
        let predicate = NSPredicate(format: "wishId = %@", wishId)
        
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                let data = result[0] as! NSManagedObject
                context.delete(data)
                
                do {
                    try context.save()
                    self.getWishList()
                } catch {
                    AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Delete unsuccessful.")
                }
            } else {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Something went wrong. Please try again after some times.")
            }
        } catch {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: fetch_error.localizedDescription)
        }
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyFullFilledWishesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyWishesTableViewCell", for: indexPath) as! MyWishesTableViewCell
        
        let data = arrWishList[indexPath.row]
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.desc
        
        // https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        cell.lblDate.text = formatter.string(from: data.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrWishList[indexPath.row]
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyWishDetailsVC") as! MyWishDetailsVC
        vc.wishObj = data
        vc.isFromFullFilledWish = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = arrWishList[indexPath.row]
        
        if (editingStyle == .delete) {
            self.deleteMyWishData(wishId: data.wishId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
