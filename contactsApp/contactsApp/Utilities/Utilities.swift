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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext
    var haveUser: Bool = false
    var currentUser: NSManagedObject?
    
    let recoginizer: String
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        recoginizer = "contactsApp"
        
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
                    currentUser = data
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
}
