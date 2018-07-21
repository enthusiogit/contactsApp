//
//  EditController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/19/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class EditController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    let viewModel = EditViewModel()

    @IBOutlet weak var scrollView: UIScrollView!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        viewModel.populateFields = { [weak self] in self?.populateFields() }
        
        viewModel.populateData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveData(avatar.currentImage!, firstLabel.text!, lastLabel.text!, jobLabel.text!, phonelabel.text!, emailLabel.text!, linkedinLabel.text!, twitterLabel.text!, snapchatLabel.text!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func avatarPress(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
        }
    }
    
    func setUpView() {
        avatar.imageView?.contentMode = UIViewContentMode.scaleAspectFill

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatar.setImage(image, for: UIControlState.normal)
        } else {
            //FIXME display error message
            print("couldnt get image")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func populateFields() {
        let contact = viewModel.user
        
        firstLabel.text = contact.firstName
        lastLabel.text = contact.lastName
        for info in contact.info {
            switch (info.platform) {
            case "Job":
                jobLabel.text = info.value
            case "Phone Number":
                phonelabel.text = info.value
            case "Email":
                emailLabel.text = info.value
            default:
                print("unknown platform")
            }
        }
//        jobLabel.text = contact.info["Job"]
//        phonelabel.text = contact.info["Phone Number"]
//        emailLabel.text = contact.info["Email"]
        linkedinLabel.text = "@steven_worrall"
        twitterLabel.text = ""
        snapchatLabel.text = ""
        
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func keyboardWillShow(noti: Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

}
