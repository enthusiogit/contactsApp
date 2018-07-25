//
//  GenerateController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/21/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class GenerateController: UIViewController {
    let stng = "@steven_worrall, @steven"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func generateTouch(_ sender: Any) {
        //FIXME chang sharpness of image
        // https://stackoverflow.com/questions/22374971/ios-7-core-image-qr-code-generation-too-blur
        
        let data = compileString().data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let img = UIImage(ciImage: (filter?.outputImage)!)
        
        performSegue(withIdentifier: "updateQRImageSeg", sender: img)
    }
    
    func compileString() -> String {
        var QRString = UtilitiesManager.shared.recoginizer
        
        QRString += ", "
        QRString += "firstName: "
        QRString += "Steven, "
        
        print(QRString)
        
        return QRString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! QRViewController
        vc.imgURL = sender as? UIImage
    }
    
    
}
