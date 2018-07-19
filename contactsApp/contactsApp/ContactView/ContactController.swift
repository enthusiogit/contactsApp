//
//  ContactController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class ContactController: UIViewController {
    var userID: String?
    let platforms = ["Phone Number", "Linkedin", "Twitter", "Medium", "Snapchat"]
    let usernames = ["408-978-0789", "@shotcaller789", "@justabigballer", "@thewriter", "@bigboi36"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ContactController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return platforms.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let expanded = tableView.dequeueReusableCell(withIdentifier: "contactExpandedCell", for: indexPath) as! ContactExpandedCell
            
            expanded.name.text = "Steven Worrall"
            
            return expanded
        } else {
            let contact = tableView.dequeueReusableCell(withIdentifier: "platformCell", for: indexPath) as! PlatformCell
            
            contact.platformName.text = platforms[indexPath.row - 1]
            contact.platformUsername.text = usernames[indexPath.row - 1]
            
            return contact
        }
    }
}
