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
    let id: Int
    var image: UIImage?
    var name: String?
    var surname: String?
    var company: String?
    var phoneNumbers: Dictionary<String,String>?
    var emails: Dictionary<String,String>
    var emergencyByPass: Bool?
    var ringtone: String?
    var ringVibration: String?
    var textTone: String?
    var textVibration: String?
    var url: Dictionary<String,String>?
    var addresses: Dictionary<String,String>?
    var birthdays: Dictionary<String,Date>?
    var related: Dictionary<String,String>?
    var social: Dictionary<String,String>?
    var instantMessage: Dictionary<String,String>?
    var notes: String?
    var prefix: String?
    var phoneticFirstName: String?
    var pronunciationFirstName: String?
    var middleName: String?
    var phoneticMiddleName: String?
    var phoneticLastName: String?
    var maidenName: String
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
}
