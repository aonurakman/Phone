//
//  Contact.swift
//  Phone
//
//  Created by protel on 6.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit
//import AVFoundation

struct Contact {
    static var contactsCatalog: Dictionary<Int,Contact> = Dictionary()
    var id: Int
    var image: UIImage?
    var name: String?
    var surname: String?
    var company: String?
    var phoneNumbers: Array<String>?
    var emails: Array<String>?
    var emergencyByPass: Bool?
    var ringtone: String?
    var textTone: String?
    var url: Array<String>?
    var addresses: Array<String>?
    var birthdays: Array<String>?
    var dates: Array<String>?
    var related: Array<String>?
    var social: Array<String>?
    var instantMessage: Array<String>?
    var notes: String?
    var prefix: String?
    var phoneticFirstName: String?
    var pronunciationFirstName: String?
    var middleName: String?
    var phoneticMiddleName: String?
    var phoneticLastName: String?
    var maidenName: String?
    var suffix: String?
    var nickname: String?
    var jobTitle: String?
    var department: String?
    var phoneticCompanyName: String?
    var linkedContacts: Dictionary<String,Contact>?
    var favorited: Bool
    var blocked: Bool
    var emergencyContact: (Bool, String)
    
    static subscript(id: Int) -> Contact? {
        return contactsCatalog[id]
    }
    
    mutating func addToCatalog(){
        self.id = (Contact.contactsCatalog.keys.max() ?? 0) + 1
        Contact.contactsCatalog[self.id] = self
    }
}
