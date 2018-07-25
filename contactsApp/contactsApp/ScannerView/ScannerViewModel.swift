//
//  ScannerViewModel.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/21/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScannerViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext
    var userString: String?
    
    var displayError: (()-> Void)?
    var displaySuccess: (()-> Void)?
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveData(qrString: String) {
        print("Saving shit")
        userString = qrString
        
        print("json string:", qrString)
        let data = Data(qrString.utf8)
        do {
            let result = try JSONDecoder().decode(ContactsApp.self, from: data)
            print("user:", result.contactsApp)
            print("firstName:", result.contactsApp.firstName)
            print("lastName:", result.contactsApp.lastName)
            for val in result.contactsApp.info {
                print(val.platform + ":", val.value)
            }
            if UtilitiesManager.shared.saveContact(myself: false, contact: result) {
                print("successfully saved new contact")
            } else {
                print("failed to save new contact")
            }
            
        } catch {
            print("error parsing json. err:", error)
            return
        }
    }
}
