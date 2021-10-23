//
//  MyWishModel.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This Model View is used for MyWish database

import Foundation

class MyWish {
    
    var wishId: String
    var userId: String
    var title: String
    var desc: String
    var isComplete: Bool
    var date: Date
    var location: String
    var wishImage: Data
    
    init(data: [String: Any]) {
        wishId = data["wishId"] as? String ?? ""
        userId = data["userId"] as? String ?? ""
        title = data["title"] as? String ?? ""
        desc = data["desc"] as? String ?? ""
        isComplete = data["isComplete"] as? Bool ?? false
        date = data["date"] as? Date ?? Date()
        location = data["location"] as? String ?? ""
        wishImage = data["wishImage"] as? Data ?? Data()
    }
    
    class func getArray(data: [Any]) -> [MyWish] {
        var temp = [MyWish]()
        for dict in data {
            temp.append(MyWish(data: dict as! [String : Any]))
        }
        
        return temp
    }
}
