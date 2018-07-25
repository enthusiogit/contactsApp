//
//  GenerateController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/21/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class GenerateController: UIViewController {
    var user: ContactStruct = ContactStruct(firstName: "", lastName: "", info: [])
    var selected = ["Job": true, "Phone Number": true, "Email": true, "LinkedIn": true, "Twitter": true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UtilitiesManager.shared.getUser()!
    }
    
    @IBAction func generateTouch(_ sender: Any) {
        //FIXME chang sharpness of image
        // https://stackoverflow.com/questions/22374971/ios-7-core-image-qr-code-generation-too-blur
        
        let jsonString = compileString()
        print("jsonString:", jsonString)
        let qrData = jsonString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(qrData, forKey: "inputMessage")
        
        let img = UIImage(ciImage: (filter?.outputImage)!)
        
        performSegue(withIdentifier: "updateQRImageSeg", sender: img)
    }
    
    func compileString() -> String {
        var QRString = "{\"" + UtilitiesManager.shared.recoginizer + "\":{"
        
        QRString += "\"firstName\":\"" + user.firstName + "\",\"lastName\":\"" + user.lastName + "\",\"info\":["
        var i = 0
        let count = user.info.count
        for val in user.info {
            if selected[val.platform] == true {
                QRString += "{\"platform\":\"" + val.platform + "\","
                QRString += "\"value\":\"" + val.value + "\"}"
            }
            i += 1
            if i < count {
                QRString += ","
            }
        }
        
        QRString += "]},"
        QRString += "\"deviceID\":\"" + UtilitiesManager.shared.deviceID + "\"}"
        
        return QRString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! QRViewController
        vc.imgURL = sender as? UIImage
    }
    
    
}
