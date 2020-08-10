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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contactCount = Contact.contactsCatalog.count
        switch contactCount {
        case 0...1:
            contactCountLabel.text = "\(contactCount) Contact"
        default:
            contactCountLabel.text = "\(contactCount) Contacts"
        }
        
        searchBar.backgroundImage = UIImage()
    }
    
    @IBAction func tapOnUserCard(_ sender: UITapGestureRecognizer) {
        if UserDefaults.standard.integer(forKey: "userCardId") != 0 {
            print(UserDefaults.standard.integer(forKey: "userCardId"))
        }
    }

    
    
    func popSingleActionAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
    @IBAction func contactAddClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "moveToAddContact", sender: self)
        
    }
    
    
    
    

}
