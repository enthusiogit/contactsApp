//
//  ScannerController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class ScannerController: UIViewController {

    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var scanFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanFrame.layer.borderWidth = 2
        self.scanFrame.layer.borderColor = UIColor.purple.cgColor
    }
}
