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
    var user: ContactStruct
    var haveUser: Bool = false
    var currentUser: NSManagedObject?
    
    var populateFields: (()-> Void)?
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        user = ContactStruct(firstName: "", lastName: "", info: [])
    }
    
    func populateData() {
        print("Populating shit. edit view model")
        
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
            populateFields!()
        } catch {
            print("Failed")
        }
    }
    
    func saveData(_ image: UIImage, _ firstLabel: String, _ lastLabel: String, _ jobLabel: String, _ phonelabel: String, _ emailLabel: String, _ linkedinLabel: String, _ twitterLabel: String, _ snapchatLabel: String) {
        print("Saving shit")
        
        if haveUser {
            print("last: ", lastLabel)
            currentUser?.setValue(true, forKey: "isMyself")
            currentUser?.setValue(firstLabel, forKey: "firstName")
            currentUser?.setValue(lastLabel, forKey: "lastName")
            currentUser?.setValue(jobLabel, forKey: "jobTitle")
            currentUser?.setValue(phonelabel, forKey: "phoneNumber")
            currentUser?.setValue(emailLabel, forKey: "email")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
            currentUser = NSManagedObject(entity: entity!, insertInto: context)
            
            currentUser?.setValue(true, forKey: "isMyself")
            currentUser?.setValue(firstLabel, forKey: "firstName")
            currentUser?.setValue(lastLabel, forKey: "lastName")
            currentUser?.setValue(jobLabel, forKey: "jobTitle")
            currentUser?.setValue(phonelabel, forKey: "phoneNumber")
            currentUser?.setValue(emailLabel, forKey: "email")

            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
}
