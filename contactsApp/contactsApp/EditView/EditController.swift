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
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var instagramLabel: UITextField!
    @IBOutlet weak var mediumLabel: UITextField!
    
    var fromGenerate: Bool = false
    
    //FIXME reload the get current user call after adding in your own data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        populateFields()
        
        if fromGenerate {
            print("from generate. setting back title to back")
            if self.navigationController?.navigationBar.topItem != nil {
                self.navigationController!.navigationBar.topItem!.title = "Back"
            }
        }
    }
    
    deinit {
        print("edit controller deinit")
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveData(avatar.currentImage!, firstLabel.text!, lastLabel.text!, jobLabel.text!, phonelabel.text!, emailLabel.text!, linkedinLabel.text!, twitterLabel.text!, snapchatLabel.text!, instagramLabel.text!, mediumLabel.text!, locationLabel.text!)
        
        if fromGenerate {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        guard let contact = viewModel.user else {
            print("User profile does not exist. returning")
            return
        }
        
        firstLabel.text = contact.firstName
        lastLabel.text = contact.lastName
        jobLabel.text = ""
        locationLabel.text = ""
        phonelabel.text = ""
        emailLabel.text = ""
        linkedinLabel.text = ""
        twitterLabel.text = ""
        mediumLabel.text = ""
        instagramLabel.text = ""
        snapchatLabel.text = ""
        
        for info in contact.info {
            switch (info.platform) {
            case "Job Title":
                jobLabel.text = info.value
            case "Phone Number":
                phonelabel.text = info.value
            case "Email":
                emailLabel.text = info.value
            case "LinkedIn":
                linkedinLabel.text = info.value
            case "Twitter":
                twitterLabel.text = info.value
            case "Snapchat":
                snapchatLabel.text = info.value
            case "Instagram":
                instagramLabel.text = info.value
            case "Medium":
                mediumLabel.text = info.value
            case "Location":
                locationLabel.text = info.value
            default:
                print("unknown platform")
            }
        }
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
