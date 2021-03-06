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
    var user: ContactStruct?
    var platforms: [String] = []
    var platformValues: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for info in (user?.info)! {
            platforms.append(info.platform)
            platformValues.append(info.value)
        }
    }
}

extension ContactController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return platforms.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let expanded = tableView.dequeueReusableCell(withIdentifier: "contactExpandedCell", for: indexPath) as! ContactExpandedCell
            
            expanded.name.text = (user?.firstName)! + " " + (user?.lastName)!
            
            expanded.messageButton.addTarget(self, action: #selector(messageButtonTapped), for: UIControlEvents.touchUpInside)
            
            expanded.callButton.addTarget(self, action: #selector(phoneButtonTapped), for: UIControlEvents.touchUpInside)
            
            return expanded
        } else {
            let contact = tableView.dequeueReusableCell(withIdentifier: "platformCell", for: indexPath) as! PlatformCell
            
            contact.platformName.text = platforms[indexPath.row - 1]
            contact.platformUsername.text = platformValues[indexPath.row - 1]
            
            return contact
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 60
        }
    }
    
    @IBAction func messageButtonTapped() -> Void {
        
    }
    
    @IBAction func phoneButtonTapped() -> Void {
        print("calling")
        
        guard let number = user?.getValueFromPlatform("Phone Number") else {
            print("we dont have the number");
            return
        }
        
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
