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
        print("Populating shit")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            
            var count = 0
            for data in result as! [NSManagedObject] {
                haveUser = true
                
                if data.value(forKey: "firstName") != nil {
                    users[count].firstName = data.value(forKey: "firstName") as! String
                }
                if data.value(forKey: "lastName") != nil {
                    users[count].lastName = data.value(forKey: "lastName") as! String
                }
                if data.value(forKey: "jobTitle") != nil {
                    users[count].job = data.value(forKey: "jobTitle") as! String
                }
                if data.value(forKey: "phoneNumber") != nil {
                    users[count].email = data.value(forKey: "phoneNumber") as! String
                }
                if data.value(forKey: "email") != nil {
                    users[count].phoneNumber = data.value(forKey: "email") as! String
                }
                count += 1
            }
            reloadData!()
        } catch {
            print("Failed")
        }
    }
}
