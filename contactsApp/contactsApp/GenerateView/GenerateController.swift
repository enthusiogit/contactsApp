//
//  GenerateController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/21/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class GenerateController: UIViewController {
    private unowned let utility = UtilitiesManager.shared
    
    var user: ContactStruct? = nil
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noInfoView: UIVisualEffectView!
    
    var selected: [String : Bool] = [:]// ["Job Title": true, "Phone Number": true, "Email": true, "LinkedIn": true, "Twitter": true]
//    let images = [#imageLiteral(resourceName: "phone"), #imageLiteral(resourceName: "Message"), #imageLiteral(resourceName: "video"), #imageLiteral(resourceName: "Email"), #imageLiteral(resourceName: "Share")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let u = UtilitiesManager.shared.getUser() {
            user = u
            noInfoView.isHidden = true
            setSelected()
        } else {
            print("curr user dne")
            noInfoView.isHidden = false
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if let u = UtilitiesManager.shared.getUser() {
//            user = u
//        }
//        collectionView.reloadData()
//    }
    
    func setSelected() {
        guard let u = user else { return }
        for val in u.info {
            selected[val.platform] = true
        }
        collectionView.reloadData()
    }
    
    @IBAction func generateTouch(_ sender: Any) {
        //FIXME chang sharpness of image
        // https://stackoverflow.com/questions/22374971/ios-7-core-image-qr-code-generation-too-blur
        
        guard let u = user else {
            print("user is nil")
            return
        }
        
        let jsonString = compileString(u)
        print("jsonString:", jsonString)
        let qrData = jsonString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(qrData, forKey: "inputMessage")
        
        guard let outputImage = filter?.outputImage else {
            print("failed to create qr code image")
            // FIXME SHOW ERROR MODAL
            return
        }
        let img = UIImage(ciImage: outputImage).resizeImageTo(newWidth: 150.0)
        
        performSegue(withIdentifier: "updateQRImageSeg", sender: img)
    }
    
    func compileString(_ user: ContactStruct) -> String {
        var QRString = "{\"" + UtilitiesManager.shared.recoginizer + "\":{"
        
        QRString += "\"firstName\":\"" + user.firstName + "\""
        if let lastName = user.lastName, lastName != "" {
            QRString += "\",\"lastName\":\"" + lastName + "\""
        }
        QRString += ",\"deviceID\":\"" + UtilitiesManager.shared.deviceID + "\""
        QRString += ",\"info\":["
        
        var i = 0
        let count = user.info.count
        for val in user.info {
            if selected[val.platform] == true {
                QRString += "{\"platform\":\"" + val.platform + "\","
                QRString += "\"value\":\"" + val.value + "\"}"
            }
            i += 1
            if selected[val.platform] == true, i < count {
                QRString += ","
            }
        }
        
        QRString += "]}}"
        
        return QRString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateQRImageSeg" {
            let vc = segue.destination as! QRViewController
            vc.imgURL = sender as? UIImage
        } else if segue.identifier == "generateToEditSeg" {
            let navVC = segue.destination as! ContactsTabNavigationController
            let childVC = navVC.topViewController as! MainViewController
            childVC.fromGenerate = true
        }
    }
    
}

extension GenerateController: UIGestureRecognizerDelegate {
    
    func setupGestures() {
        let noInfoTap = UITapGestureRecognizer(target: self, action: #selector(self.respondToNoInfoTap))
        noInfoTap.delegate = self
        noInfoView.addGestureRecognizer(noInfoTap)
    }
    
    @objc func respondToNoInfoTap(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: "generateToEditSeg", sender: nil)
    }
}

extension GenerateController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (user == nil) ? 0 : user!.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "platformIdent", for: indexPath) as! platformsCell
        
        guard let u = user, let imageName = utility.getStoredNameFromDisplayName(u.info[indexPath.row].platform), let selected = selected[u.info[indexPath.row].platform] else { return itemCell }
        
        let image = UIImage(imageLiteralResourceName: imageName)
        
//        var image = UIImage(imageLiteralResourceName: imageName)
//        let size = CGSize(width: 80.0, height: 80.0)
//        if image.size != size {
//            image = image.resized(to: size)
//        }
        
        itemCell.image.image = image
        itemCell.alphaLayer.isHidden = selected
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected jam cell #\(indexPath.row)!")
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "platformIdent", for: indexPath) as! platformsCell
        
        guard let u = user, selected[u.info[indexPath.row].platform] != nil else { return }
        let selectedNow = !selected[u.info[indexPath.row].platform]!
        print("selectedNow:", selectedNow)
        itemCell.alphaLayer.isHidden = selectedNow
        selected[u.info[indexPath.row].platform] = selectedNow
        collectionView.reloadData()
    }
}
