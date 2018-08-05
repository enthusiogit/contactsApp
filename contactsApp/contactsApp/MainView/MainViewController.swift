//
//  ViewController.swift
//  contactsApp
//
//  Created by Steven Worrall on 7/18/18.
//  Copyright © 2018 Enthusio. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    var userIDToPass: String?
    var userToPass: ContactStruct?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadData = { [weak self] in self?.reloadData() }
        viewModel.populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        viewModel.resetUser()
        viewModel.populateData()
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.viewModel.users.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let personal = tableView.dequeueReusableCell(withIdentifier: "personalCell", for: indexPath) as! PersonalCell
            
            personal.name.text = (viewModel.currUser?.firstName)! + " " + (viewModel.currUser?.lastName)!
            
            return personal
        } else {
            let contact = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
            
            contact.name.text = self.viewModel.users[indexPath.row - 1].firstName + " " + self.viewModel.users[indexPath.row - 1].lastName
            contact.location.text = self.viewModel.users[indexPath.row - 1].info[0].value
            
            return contact
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "editProfileSeg", sender: indexPath.row)
        } else {
//            userIDToPass = contacts[indexPath.row - 1]
            userToPass = viewModel.users[indexPath.row - 1]
            self.performSegue(withIdentifier: "viewContactSeg", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewContactSeg" {
            let viewController = segue.destination as! ContactController
//            viewController.userID = userIDToPass
            viewController.user = userToPass
        }
    }
}

