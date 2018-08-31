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
                    let user = ContactStruct(firstName: "", lastName: "", info: [], deviceID: "")
                    
                    if let firstName = data.value(forKey: "firstName") {
                        user.firstName = firstName as! String
                    }
                    if let lastName = data.value(forKey: "lastName") {
                        user.lastName = lastName as? String
                    }
                    if let deviceID = data.value(forKey: "deviceID") {
                        user.deviceID = deviceID as! String
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
    
    func saveContact(myself: Bool, contact: ContactStruct) -> Bool {
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
        currentUser.setValue(contact.firstName, forKey: "firstName")
        currentUser.setValue(contact.lastName, forKey: "lastName")
        for val in contact.info {
            print("platform display name:", val.platform)
            if let storedName = getStoredNameFromDisplayName(val.platform) {
                print("platform stored name:", val.platform)
                currentUser.setValue(val.value, forKey: storedName)
            }
        }
        
        do {
            try context.save()
            if myself {
                print("caching user")
                cacheUser(user: contact)
            }
            return true
        } catch {
            print("Failed saving")
            return false
        }
    }
    
    func deleteContact(contact: ContactStruct) {
        print("deviceID:", contact.deviceID)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.predicate = NSPredicate(format: "deviceID == %@", contact.deviceID)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.count == 1 {
                for object in result as! [NSManagedObject] {
                    print("delete user")
                    context.delete(object)
                }
            }
        } catch {
            print("failed to delete contact")
        }
    }
    
    func getStoredNameFromDisplayName(_ name: String) -> String? {
        for i in 0..<PlatformDisplayNames.count {
            if name == PlatformDisplayNames[i] {
                return PlatformStoredNames[i]
            }
        }
        return nil
    }
    
    func getDisplayNameFromStoredName(_ name: String) -> String? {
        for i in 0..<PlatformStoredNames.count {
            if name == PlatformStoredNames[i] {
                return PlatformDisplayNames[i]
            }
        }
        return nil
    }
}
