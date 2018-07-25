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
    let userCache = NSCache<NSString, ContactStruct>()
   
    let deviceID: String
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext
    var haveUser: Bool = false
    var currentUserObject: NSManagedObject?
    
    let recoginizer: String
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        recoginizer = "contactsApp"
        deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        if getUser() == nil {
            _ = findUser()
        } else {
            haveUser = true
        }
    }
    
    func findUser() -> ContactStruct? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.predicate = NSPredicate(format: "isMyself == %@", NSNumber(value: true))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.count == 1 {
                for data in result as! [NSManagedObject] {
                    haveUser = true
                    currentUserObject = data
                    let user = ContactStruct(firstName: "", lastName: "", info: [])
                    
                    if let firstName = data.value(forKey: "firstName") {
                        user.firstName = firstName as! String
                    }
                    if let lastName = data.value(forKey: "firstName") {
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
                    
                    cacheUser(user: user)
                    return user
                }
            }
        } catch {
            print("Failed")
            return nil
        }
        return nil
    }
    
    func cacheUser(user: ContactStruct) {
        userCache.setObject(user, forKey: "userInfo" as NSString)
    }
    
    func getUser() -> ContactStruct? {
        if let user = userCache.object(forKey: "userInfo" as NSString) {
            return user
        }
        return nil
    }
    
    func saveContact(myself: Bool, contact: ContactsApp) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        var currentUser: NSManagedObject
        if myself, currentUserObject != nil {
            currentUser = currentUserObject!
        } else {
            currentUser = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        currentUser.setValue(contact.deviceID, forKey: "deviceID")
        currentUser.setValue(myself, forKey: "isMyself")
        currentUser.setValue(contact.contactsApp.firstName, forKey: "firstName")
        currentUser.setValue(contact.contactsApp.lastName, forKey: "lastName")
        for val in contact.contactsApp.info {
            switch (val.platform) {
            case "Job":
                 currentUser.setValue(val.value, forKey: "jobTitle")
            case "Phone Number":
                currentUser.setValue(val.value, forKey: "phoneNumber")
            case "Email":
                currentUser.setValue(val.value, forKey: "email")
            case "LinkedIn":
                currentUser.setValue(val.value, forKey: "linkedin")
            case "Twitter":
                currentUser.setValue(val.value, forKey: "twitter")
            case "Snapchat":
                currentUser.setValue(val.value, forKey: "snapchat")
            default:
                print("unknown platform")
            }
        }
        
        do {
            try context.save()
            if myself {
                cacheUser(user: contact.contactsApp)
            }
            return true
        } catch {
            print("Failed saving")
            return false
        }
    }
}
