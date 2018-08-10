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
        
        haveUser = (getUser() != nil)
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
                    if let lastName = data.value(forKey: "lastName") {
                        user.lastName = lastName as! String
                    }
                    
                    for i in 0..<PlatformStoredNames.count {
                        if let val = data.value(forKey: PlatformStoredNames[i]) {
                            user.info.append(ContactValue(platform: PlatformDisplayNames[i], value: val as! String))
                        }
                    }
                    print("user:", user.toString())
                    
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
    
    func getCachedUser() -> ContactStruct? {
        if let user = userCache.object(forKey: "userInfo" as NSString) {
            return user
        }
        return nil
    }
    
    func getUser() -> ContactStruct? {
        if let cachedUser = getCachedUser() {
            print("getting user from cache")
            return cachedUser
        } else if let coreUser = findUser() {
            print("getting user from core data")
            cacheUser(user: coreUser)
            return coreUser
        }
        return nil
    }
    
    func saveContact(myself: Bool, contact: ContactsApp) -> Bool {
        _ = findUser()
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        var currentUser: NSManagedObject
        if myself, currentUserObject != nil {
            currentUser = currentUserObject!
            print("myself and already have profile saved")
        } else {
            currentUser = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        currentUser.setValue(contact.deviceID, forKey: "deviceID")
        currentUser.setValue(myself, forKey: "isMyself")
        currentUser.setValue(contact.contactsApp.firstName, forKey: "firstName")
        currentUser.setValue(contact.contactsApp.lastName, forKey: "lastName")
        for val in contact.contactsApp.info {
            if let storedName = getStoredNameFromDisplayName(val.platform) {
                currentUser.setValue(val.value, forKey: storedName)
            }
            
//            switch (val.platform) {
//            case "Job":
//                 currentUser.setValue(val.value, forKey: "jobTitle")
//            case "Phone Number":
//                currentUser.setValue(val.value, forKey: "phoneNumber")
//            case "Email":
//                currentUser.setValue(val.value, forKey: "email")
//            case "LinkedIn":
//                currentUser.setValue(val.value, forKey: "linkedin")
//            case "Twitter":
//                currentUser.setValue(val.value, forKey: "twitter")
//            case "Snapchat":
//                currentUser.setValue(val.value, forKey: "snapchat")
//            default:
//                print("unknown platform")
//            }
        }
        
        do {
            try context.save()
            if myself {
                print("caching user")
                cacheUser(user: contact.contactsApp)
            }
            return true
        } catch {
            print("Failed saving")
            return false
        }
    }
    
    func getStoredNameFromDisplayName(_ name: String) -> String? {
        for storedName in PlatformStoredNames {
            if name == storedName {
                return storedName
            }
        }
        return nil
    }
    
    func getDisplayNameFromStoredName(_ name: String) -> String? {
        for displayName in PlatformDisplayNames {
            if name == displayName {
                return displayName
            }
        }
        return nil
    }
}
