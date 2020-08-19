//
//  ContactsTableViewCell.swift
//  Phone
//
//  Created by protel on 14.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var rightHandSideLogo: UIImageView!
    
    var id: Int = 0
}
