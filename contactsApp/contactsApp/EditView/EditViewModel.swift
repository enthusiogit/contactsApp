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
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        user = UtilitiesManager.shared.getUser()
//        if let cachedUser = UtilitiesManager.shared.getUser() {
//            user = cachedUser
//        } else if let coreUser = UtilitiesManager.shared.findUser() {
//            user = coreUser
//        } else {
//            print("no profile started")
//            user = ContactStruct(firstName: "", lastName: "", info: [])
//        }
    }
    
    func saveData(_ image: UIImage, _ firstName: String, _ lastName: String, _ jobLabel: String, _ phonelabel: String, _ emailLabel: String, _ linkedinLabel: String, _ twitterLabel: String, _ snapchatLabel: String) {
        print("Saving shit")
        
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
        let contact = ContactsApp(contactsApp: user, deviceID: UtilitiesManager.shared.deviceID)
        if UtilitiesManager.shared.saveContact(myself: true, contact: contact) {
            print("successfully saved user info")
        } else {
            print("failed to save user info")
        }
    }
    
}
