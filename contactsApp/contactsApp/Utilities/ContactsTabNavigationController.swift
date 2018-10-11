//
//  ContactsTabNavigationController.swift
//  contactsApp
//
//  Created by Shouvik Paul on 10/11/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class ContactsTabNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var fromGenerate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromGenerate {
            
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        print("willshow:", self.viewControllers)
        
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        print("didshow:", self.viewControllers)
        
    }
}
