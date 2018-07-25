//
//  Utilities.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/23/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UtilitiesManager {
    static let shared = UtilitiesManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext
    var user: ContactStruct
    var haveUser: Bool = false
    var currentUser: NSManagedObject?
    
    let recoginizer: String
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        recoginizer = "contactsApp"
        
        findUser()
    }
    
    func findUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.predicate = NSPredicate(format: "isMyself == %@", NSNumber(value: true))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.count == 1 {
                for data in result as! [NSManagedObject] {
                    haveUser = true
                    currentUser = data
                    
                    if let firstName = data.value(forKey: "firstName") {
                        user.firstName = firstName as! String
                    }
                    if let lastName = data.value(forKey: "firstName") {
                        user.lastName = lastName as! String
                    }
                    if let job = data.value(forKey: "jobTitle") {
                        user.info.append(ContactValue(platform: "Job", value: job as! String))
                    }
                    if let email = data.value(forKey: "email") {
                        user.info.append(ContactValue(platform: "Email", value: email as! String))
                    }
                    if let phoneNumber = data.value(forKey: "phoneNumber") {
                        user.info.append(ContactValue(platform: "Phone Number", value: phoneNumber as! String))
                    }
                    print("user:", user)
                }
            }
        } catch {
            print("Failed")
        }
    }
}
