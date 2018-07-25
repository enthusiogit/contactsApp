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
    let images = [#imageLiteral(resourceName: "phone"), #imageLiteral(resourceName: "Message"), #imageLiteral(resourceName: "video"), #imageLiteral(resourceName: "Email"), #imageLiteral(resourceName: "Share")]
    
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

extension GenerateController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "platformIdent", for: indexPath) as! platformsCell
        
        itemCell.image.image = images[indexPath.row]
        
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
