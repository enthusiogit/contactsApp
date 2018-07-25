//
//  Structs.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/20/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation

class ContactStruct {
    var firstName: String
    var lastName: String
    var info: [ContactValue]
    
    init(firstName: String, lastName: String, info: [ContactValue]) {
        self.firstName = firstName
        self.lastName = lastName
        self.info = info
    }
}

struct ContactValue {
    let platform: String
    let value: String
}
