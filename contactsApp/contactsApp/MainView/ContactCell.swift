//
//  ContactCell.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var avatar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToDeleteSwipe))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        swipeRight.delegate = self
//        contactView.addGestureRecognizer(swipeRight)
    }
    
//    @objc func respondToDeleteSwipe(gesture: UIGestureRecognizer) {
//        print("DELETE")
//    }
}
