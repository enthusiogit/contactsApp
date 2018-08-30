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
    let images = [#imageLiteral(resourceName: "phone"), #imageLiteral(resourceName: "Message"), #imageLiteral(resourceName: "video"), #imageLiteral(resourceName: "Email"), #imageLiteral(resourceName: "Share")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let u = UtilitiesManager.shared.getUser() {
            user = u
        }
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
        
        QRString += "\"firstName\":\"" + user.firstName
        if let lastName = user.lastName, lastName != "" {
            QRString += "\",\"lastName\":\"" + lastName
        }
        QRString += "\",\"info\":["
        
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

extension GenerateController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "platformIdent", for: indexPath) as! platformsCell
        
        itemCell.image.image = images[indexPath.row]
        // FIXME get image names from UtilitiesManager.shared.getStoredNameFromDisplayName(info[indexPath.row])
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("You selected jam cell #\(indexPath.row)!")
//
//        // Get Jam ID
//        jamIDForSegue = viewModel.jam(at: indexPath.row).ID
//        self.performSegue(withIdentifier: "mainToWatchSeg", sender: indexPath.row)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mainToWatchSeg" {
//            let viewController = segue.destination as! WatchController
//            viewController.jamID = jamIDForSegue
//        }
//    }
}
