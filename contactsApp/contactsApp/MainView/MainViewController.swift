//
//  ViewController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var userIDToPass: String?
    let contacts = ["Souvik", "Steven", "Alec", "Moyo", "Kiara"]
    let locations = ["San Francisco", "San Jose", "Los Angeles", "Sacramento", "Middle of Fucking Nowhere"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return contacts.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let personal = tableView.dequeueReusableCell(withIdentifier: "personalCell", for: indexPath) as! PersonalCell
            
            personal.name.text = "Steven Worrall"
            
            return personal
        } else {
            let contact = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
            
            contact.name.text = contacts[indexPath.row - 1]
            contact.location.text = locations[indexPath.row - 1]
            
            return contact
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != 0 {
            userIDToPass = contacts[indexPath.row - 1]
            self.performSegue(withIdentifier: "viewContactSeg", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewContactSeg" {
            let viewController = segue.destination as! ContactController
            viewController.userID = userIDToPass
        }
    }
}

