//
//  ContactCell.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var avatar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
