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
    var currUser: ContactStruct?
    
    var reloadData: (()-> Void)?
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        resetUser()
    }
    
    func resetUser() {
        currUser = UtilitiesManager.shared.getUser()
    }
    
    func populateData() {
        print("Populating shit. main view model")
        
        users = []
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.context?.fetch(request)
            
            for data in result as! [NSManagedObject] {
                haveUser = true
                let user = ContactStruct(firstName: "", lastName: "", info: [])
                
                if let firstName = data.value(forKey: "firstName") {
                    user.firstName = firstName as! String
                }
                if let lastName = data.value(forKey: "lastName") {
                    user.lastName = lastName as! String
                }
                if let job = data.value(forKey: "jobTitle") {
                    user.info.append(ContactValue(platform: "Job", value: job as! String))
                }
                if let phoneNumber = data.value(forKey: "phoneNumber") {
                    user.info.append(ContactValue(platform: "Phone Number", value: phoneNumber as! String))
                }
                if let email = data.value(forKey: "email") {
                    user.info.append(ContactValue(platform: "Email", value: email as! String))
                }
                if let value = data.value(forKey: "linkedin") {
                    user.info.append(ContactValue(platform: "LinkedIn", value: value as! String))
                }
                if let value = data.value(forKey: "twitter") {
                    user.info.append(ContactValue(platform: "Twitter", value: value as! String))
                }
                if let value = data.value(forKey: "snapchat") {
                    user.info.append(ContactValue(platform: "Snapchat", value: value as! String))
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
