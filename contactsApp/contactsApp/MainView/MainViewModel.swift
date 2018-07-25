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
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        resetUser()
    }
    
    func resetUser() {
        currUser = UtilitiesManager.shared.getUser()
    }
}
