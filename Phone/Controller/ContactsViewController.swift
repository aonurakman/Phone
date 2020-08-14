//
//  ContactsViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var contactCountLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [Contact] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        let contactCount = Contact.contactsCatalog.count
        
        for key in Contact.contactsCatalog.keys {
            contacts.append(Contact.contactsCatalog[key]!)
        }
        
        displayContacts()
        
        switch contactCount {
        case 0...1:
            contactCountLabel.text = "\(contactCount) Contact"
        default:
            contactCountLabel.text = "\(contactCount) Contacts"
        }
        
        searchBar.backgroundImage = UIImage()
    }

    func displayContacts(){
        tableView.reloadData()
        
        if contacts.count == 0 {
            tableView.isHidden = true
        }
        else{
            tableView.isHidden = false
        }
    }
    
    @IBAction func tapOnUserCard(_ sender: UITapGestureRecognizer) {
        if UserDefaults.standard.integer(forKey: "userCardId") != 0 {
            print(UserDefaults.standard.integer(forKey: "userCardId"))
        }
    }
    
    
    
    @IBAction func contactAddClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "moveToAddContact", sender: self)
    }
}

extension ContactsViewController: ContainsTableView{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactsTableViewCell
        cell.nameLabel.text = contacts[indexPath.row].name
        cell.lastNameLabel.text = contacts[indexPath.row].surname
        if contacts[indexPath.row].isEmergencyContact.0 {
            cell.rightHandSideLogo.image = UIImage(systemName: "staroflife.fill")
            cell.rightHandSideLogo.tintColor = .red
        }
        else {
            cell.rightHandSideLogo.image = UIImage()
        }
        print("HEY")
        return cell
    }
    
    // Click on list item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
