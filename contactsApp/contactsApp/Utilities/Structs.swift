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
    
    func toString() -> String {
        var str = firstName + " " + lastName + "\n"
        for val in info {
            str += val.platform + ": " + val.value + "\n"
        }
        return str
    }
}

struct ContactValue: Decodable {
    let platform: String
    let value: String
}

let PlatformDisplayNames = ["Job Title", "Phone Number", "Email", "LinkedIn", "Twitter", "Snapchat"]

let PlatformStoredNames = ["jobTitle", "phoneNumber", "email", "linkedin", "twitter", "snapchat"]

