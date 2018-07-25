//
//  QRViewController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/24/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {
    var imgURL: UIImage?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImage.image = imgURL
        
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func closePress(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
