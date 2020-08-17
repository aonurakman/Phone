//
//  PhoneAppManager.swift
//  Phone
//
//  Created by protel on 13.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

typealias ContainsTableView = UITableViewDelegate & UITableViewDataSource

protocol NewContactDelegate {
    func didNewContactAdded()
}

enum TagDictionary: Int {
    case basicInfo = 100, ringtoneButton = 101, textToneButton = 102, notesStack = 103, phoneStack = 104, emailStack = 105, urlStack = 106, addressStack = 107, bdayStack = 108, datesStack = 109, relatedStack = 110, socialStack = 111, instantStack = 112
    case fieldToCopy = 4, hidden = 3, fieldToRead = 2, actionButton = 1, regular = 0
}

struct PhoneAppManager {

}
