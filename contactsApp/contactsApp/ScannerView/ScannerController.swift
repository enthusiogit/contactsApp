//
//  ScannerController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let viewModel = ScannerViewModel()
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var savedUser: ContactStruct? = nil
    var gotQROutput: Bool = false

    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var scanFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.displaySuccess = { [weak self] (user: ContactStruct) in self?.displaySuccess(user) }
        viewModel.displayError = { [weak self] in self?.displayError() }
        
        setUpCameraView()
        
//        displaySuccess(ContactStruct(firstName: "first", lastName: "last", info: [], deviceID: "deviceID"))
        
        self.scanFrame.layer.borderWidth = 2
        self.scanFrame.layer.borderColor = UIColor.green.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allowScan()
    }
    
    func setUpCameraView() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("Failed to set input as camera")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = self.view.layer.bounds
        scannerView.layer.insertSublayer(video, at: 0)
        
        session.startRunning()
    }
    
    func allowScan() {
        gotQROutput = false
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if gotQROutput { return }
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    gotQROutput = true
                    viewModel.saveData(qrString: object.stringValue!)
                }
            }
        }
    }
    
    func displaySuccess(_ user: ContactStruct) {
        savedUser = user
        let alert = UIAlertController(title: "Success", message: "Saved user to your contacts!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: startSectionAlertAction))
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: viewUser))
        present(alert, animated: true, completion: nil)
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Error", message: "Error reading and saving QR code.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: startSectionAlertAction))
        present(alert, animated: true, completion: nil)
    }

    func viewUser(action: UIAlertAction) {
        guard let user = savedUser else { return }
        print("saved user:", user.firstName)
        performSegue(withIdentifier: "scannerToViewSeg", sender: nil)
    }
    
    func startSectionAlertAction(action: UIAlertAction) {
        allowScan()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scannerToViewSeg" {
            let navVC = segue.destination as! ContactsTabNavigationController
            let childVC = navVC.topViewController as! MainViewController
            childVC.fromScan = true
            childVC.userToPass = savedUser
        }
        savedUser = nil
    }
}
