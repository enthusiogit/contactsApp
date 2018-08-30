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

    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var scanFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.displaySuccess = { [weak self] in self?.displaySuccess() }
        viewModel.displayError = { [weak self] in self?.displayError() }
        
        setUpCameraView()
        self.session.startRunning()
        
        self.scanFrame.layer.borderWidth = 2
        self.scanFrame.layer.borderColor = UIColor.green.cgColor
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

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    self.session.stopRunning()
                    viewModel.saveData(qrString: object.stringValue!)    
                }
            }
        }
    }
    
    func displaySuccess() {
        let alert = UIAlertController(title: "Success", message: "Saved user to your contacts!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Error", message: "Error reading and saving QR code.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
