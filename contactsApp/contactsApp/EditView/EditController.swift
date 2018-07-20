//
//  EditController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/19/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class EditController: UIViewController {
    let viewModel = EditViewModel()

    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var firstLabel: UITextField!
    @IBOutlet weak var lastLabel: UITextField!
    @IBOutlet weak var jobLabel: UITextField!
    @IBOutlet weak var phonelabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var linkedinLabel: UITextField!
    @IBOutlet weak var twitterLabel: UITextField!
    @IBOutlet weak var snapchatLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.populateData()
    }

    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func avatarPress(_ sender: Any) {
    }

}
