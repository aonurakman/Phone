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
    @IBOutlet weak var userCardView: UIView!
    @IBOutlet weak var headerStack: UIStackView!
    
    var contacts: [Contact] = []
    var contactsAlphabetical: Dictionary<Character,[Contact]> = [:]
    var sectionTitles: [Character] = []
    var currentlySelectedRowIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    var dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        
        tableView.tableFooterView = contactCountLabel
        tableView.tableHeaderView = headerStack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getContacts()
    }
    
    func getContacts(){
        contacts = dbHelper.read()
        seperateContactsAlphabetically()
        displayContacts()
        
        switch contacts.count {
        case 0:
            contactCountLabel.text = "No Contacts"
        case 1:
            contactCountLabel.text = "\(contacts.count) Contact"
        default:
            contactCountLabel.text = "\(contacts.count) Contacts"
        }
    }
    
    func seperateContactsAlphabetically() {
        contactsAlphabetical.removeAll()
        sectionTitles.removeAll()
        
        for contact in contacts {
            let initial: Character = ((contact.surname?.first?.uppercased() ?? contact.name?.first?.uppercased()) as Character?) ?? "#"
            if contactsAlphabetical[initial] == nil {
                sectionTitles.append((initial))
                contactsAlphabetical[initial] = []
            }
            contactsAlphabetical[initial]?.append(contact)
        }
        sectionTitles.sort(by: {$0<$1})
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToAddContact" {
            let navController = segue.destination as? UINavigationController
            let viewController = navController?.viewControllers.first as? Edit_AddContactViewController
            viewController?.delegate = self
        }
        else if segue.identifier == "displayDetail" {
            let navController = segue.destination as? UINavigationController
            let viewController = navController?.viewControllers.first as? ContactDetailsViewController
            guard let cell = tableView.cellForRow(at: currentlySelectedRowIndex) as! ContactsTableViewCell? else { return }
            viewController?.contactToView = Contact.contactsCatalog[cell.id]
        }
    }
}

extension ContactsViewController: NewContactDelegate {
    func didNewContactAdded(){
        getContacts()
    }
}

extension ContactsViewController: ContainsTableView{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactsTableViewCell
        
        guard let contact = contactsAlphabetical[sectionTitles[indexPath.section]]?[indexPath.row]
            else { return cell}
        
        cell.nameLabel.text = contact.name
        cell.lastNameLabel.text = contact.surname
        cell.id = contact.id
        if contact.surname?.count == 0 {
            cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
        else {
            cell.lastNameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
        
        if contacts[indexPath.row].isEmergencyContact.0 {
            print("Found emergency contact!")
            cell.rightHandSideLogo.image = UIImage(systemName: "staroflife.fill")
            cell.rightHandSideLogo.tintColor = .red
        }
        else {
            cell.rightHandSideLogo.image = UIImage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentlySelectedRowIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "displayDetail", sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsAlphabetical.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        if let values = contactsAlphabetical[key] {
            return values.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sectionTitles[section])"
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles : [String] = []
        for title in sectionTitles {
            titles.append("\(title)")
        }
        return titles
    }
    
}
