//
//  MainViewModel.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext?
    var users: [ContactStruct] = []
    var haveUser: Bool = false
    
    var reloadData: (()-> Void)?
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func populateData() {
        print("Populating shit. main view model")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            
            for data in result as! [NSManagedObject] {
                haveUser = true
                var user = ContactStruct(firstName: "", lastName: "", info: [])
                
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
                users.append(user)
            }
            if let reloadData = self.reloadData {
                reloadData()
            }
        } catch {
            print("Failed")
        }
    }
}