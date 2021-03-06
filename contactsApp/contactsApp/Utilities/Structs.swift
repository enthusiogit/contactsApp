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
    var lastName: String?
    var info: [ContactValue]
    
    init(firstName: String, lastName: String, info: [ContactValue]) {
        self.firstName = firstName
        self.lastName = lastName
        self.info = info
    }
    
    func toString() -> String {
        var str = firstName
        if let last = lastName, last != "" {
            str +=  " " + last + "\n"
        }

        for val in info {
            str += val.platform + ": " + val.value + "\n"
        }
        return str
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

let PlatformDisplayNames = ["Job Title", "Phone Number", "Email", "LinkedIn", "Twitter", "Medium", "Instagram", "Snapchat"]

let PlatformStoredNames = ["job_Title", "phone_Number", "email", "linkedIn", "twitter", "medium", "instagram", "snapchat"]

