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
}

class ContactStruct: Decodable {
    var firstName: String
    var lastName: String?
    var info: [ContactValue]
    var deviceID: String
    
    init(firstName: String, lastName: String, info: [ContactValue], deviceID: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.info = info
        self.deviceID = deviceID
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

let PlatformDisplayNames = ["Phone Number", "Email", "Job Title", "Location", "LinkedIn", "Twitter", "Medium", "Instagram", "Snapchat"]

let PlatformStoredNames = ["phone_Number", "email", "job_Title", "location", "linkedIn", "twitter", "medium", "instagram", "snapchat"]

