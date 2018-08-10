//
//  Structs.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/20/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import Foundation

struct ContactsApp: Decodable {
    let contactsApp: ContactStruct
    let deviceID: String
}

class ContactStruct: Decodable {
    var firstName: String
    var lastName: String
    var info: [ContactValue]
    
    init(firstName: String, lastName: String, info: [ContactValue]) {
        self.firstName = firstName
        self.lastName = lastName
        self.info = info
    }
    
    func getValueFromPlatform(_ platform: String) -> String? {
        for val in info {
            if val.platform == platform {
                return val.value
            }
        }
        return nil
    }
}

struct ContactValue: Decodable {
    let platform: String
    let value: String
}
