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
    let utility = UtilitiesManager.shared
    
    var reloadData: (()-> Void)?
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        resetUser()
    }
    
    func resetUser() {
        currUser = utility.getUser()
    }
    
    func populateData() {
        print("Populating shit. main view model")
        
        users = []
        
//        for _ in 0...5 {
//            users.append(currUser!)
//        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.context?.fetch(request)

            for data in result as! [NSManagedObject] {
                if let b = data.value(forKey: "isMyself") as? Bool, b == false {
                    haveUser = true
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
                    users.append(user)
                }
            }

            if let reloadData = self.reloadData {
                reloadData()
            }
        } catch {
            print("Failed")
        }
    }
}
