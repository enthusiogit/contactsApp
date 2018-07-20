//
//  EditViewModel.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/20/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext
    var tempContact: ContactStruct
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        tempContact = ContactStruct(firstName: "", lastName: "", job: "", email: "", phoneNumber: "")
    }
    
    func populateData() {
        print("Populating shit")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                if data.value(forKey: "firstName") != nil {
                    tempContact.firstName = data.value(forKey: "firstName") as! String
                } else if data.value(forKey: "lastName") != nil {
                    tempContact.lastName = data.value(forKey: "lastName") as! String
                } else if data.value(forKey: "jobTitle") != nil {
                    tempContact.job = data.value(forKey: "jobTitle") as! String
                } else if data.value(forKey: "phoneNumber") != nil {
                    tempContact.email = data.value(forKey: "phoneNumber") as! String
                } else if data.value(forKey: "email") != nil {
                    tempContact.phoneNumber = data.value(forKey: "email") as! String
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func saveData() {
        print("Saving shit")
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        let newContact = NSManagedObject(entity: entity!, insertInto: context)
        
        newContact.setValue("Steven", forKey: "firstName")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
}
