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
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        let newContact = NSManagedObject(entity: entity!, insertInto: context)

        newContact.setValue("Steven", forKey: "firstName")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
            self.displayError!()
        }
    }
}
