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
    var currentUser: NSManagedObject?
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        user = UtilitiesManager.shared.getUser()!
    }
    
    func saveData(_ image: UIImage, _ firstName: String, _ lastName: String, _ jobLabel: String, _ phonelabel: String, _ emailLabel: String, _ linkedinLabel: String, _ twitterLabel: String, _ snapchatLabel: String) {
        print("Saving shit")
        
        if UtilitiesManager.shared.haveUser {
            print("last: ", lastName)
            currentUser?.setValue(true, forKey: "isMyself")
            currentUser?.setValue(firstName, forKey: "firstName")
            currentUser?.setValue(lastName, forKey: "lastName")
            currentUser?.setValue(jobLabel, forKey: "jobTitle")
            currentUser?.setValue(phonelabel, forKey: "phoneNumber")
            currentUser?.setValue(emailLabel, forKey: "email")
            currentUser?.setValue(linkedinLabel, forKey: "linkedin")
            currentUser?.setValue(twitterLabel, forKey: "twitter")
            currentUser?.setValue(snapchatLabel, forKey: "snapchat")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
                return
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
            currentUser = NSManagedObject(entity: entity!, insertInto: context)
            
            currentUser?.setValue(deviceID, forKey: "deviceID")
            currentUser?.setValue(true, forKey: "isMyself")
            currentUser?.setValue(firstName, forKey: "firstName")
            currentUser?.setValue(lastName, forKey: "lastName")
            currentUser?.setValue(jobLabel, forKey: "jobTitle")
            currentUser?.setValue(phonelabel, forKey: "phoneNumber")
            currentUser?.setValue(emailLabel, forKey: "email")
            currentUser?.setValue(linkedinLabel, forKey: "linkedin")
            currentUser?.setValue(twitterLabel, forKey: "twitter")
            currentUser?.setValue(snapchatLabel, forKey: "snapchat")

            do {
                try context.save()
            } catch {
                print("Failed saving")
                return
            }
        }
        var info: [ContactValue] = []
        if jobLabel != "" {
            info.append(ContactValue(platform: "Job", value: jobLabel))
        }
        if phonelabel != "" {
            info.append(ContactValue(platform: "Phone Number", value: phonelabel))
        }
        if emailLabel != "" {
            info.append(ContactValue(platform: "Email", value: emailLabel))
        }
        if linkedinLabel != "" {
            info.append(ContactValue(platform: "LinkedIn", value: linkedinLabel))
        }
        if twitterLabel != "" {
            info.append(ContactValue(platform: "Twitter", value: twitterLabel))
        }
        if snapchatLabel != "" {
            info.append(ContactValue(platform: "Snapchat", value: snapchatLabel))
        }
        
        let user = ContactStruct(firstName: firstName, lastName: lastName, info: info)
        UtilitiesManager.shared.cacheUser(user: user)
    }
    
}
