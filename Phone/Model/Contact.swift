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
    var phoneNumbers: Array<String>
    var emails: Array<String>
    var emergencyByPass: Bool
    var ringtone: String?
    var textTone: String?
    var url: Array<String>
    var addresses: Array<String>
    var birthdays: Array<String>
    var dates: Array<String>
    var related: Array<String>
    var social: Array<String>
    var instantMessage: Array<String>
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
    var isEmergencyContact: (Bool, String)
    
    init(id: Int?, image: UIImage?, name: String?, surname: String?, company: String?, phoneNumbers: Array<String>?, emails: Array<String>?, emergencyByPass: Bool?, ringtone: String?, textTone: String?, url: Array<String>?, addresses: Array<String>?, birthdays: Array<String>?, dates: Array<String>?, related: Array<String>?, social: Array<String>?, instantMessage: Array<String>?, notes: String?, prefix: String?, phoneticFirstName: String?, pronunciationFirstName: String?, middleName: String?, phoneticMiddleName: String?, phoneticLastName: String?, maidenName: String?, suffix: String?, nickname: String?, jobTitle: String?, department: String?, phoneticCompanyName: String?, linkedContacts: Dictionary<String, Contact>?, favorited: Bool, blocked: Bool?, isEmergencyContact: (Bool, String)) {
        self.id = id ?? ((Contact.contactsCatalog.keys.max() ?? 0) + 1)
        self.image = image
        self.name = name
        self.surname = surname
        self.company = company
        self.phoneNumbers = phoneNumbers ?? []
        self.emails = emails ?? []
        self.emergencyByPass = emergencyByPass ?? false
        self.ringtone = ringtone
        self.textTone = textTone
        self.url = url ?? []
        self.addresses = addresses ?? []
        self.birthdays = birthdays ?? []
        self.dates = dates ?? []
        self.related = related ?? []
        self.social = social ?? []
        self.instantMessage = instantMessage ?? []
        self.notes = notes
        self.prefix = prefix
        self.phoneticFirstName = phoneticFirstName
        self.pronunciationFirstName = pronunciationFirstName
        self.middleName = middleName
        self.phoneticMiddleName = phoneticMiddleName
        self.phoneticLastName = phoneticLastName
        self.maidenName = maidenName
        self.suffix = suffix
        self.nickname = nickname
        self.jobTitle = jobTitle
        self.department = department
        self.phoneticCompanyName = phoneticCompanyName
        self.linkedContacts = linkedContacts
        self.favorited = favorited
        self.blocked = blocked ?? false
        self.isEmergencyContact = isEmergencyContact
    }
    

    
    static subscript(id: Int) -> Contact? {
        return contactsCatalog[id]
    }
    
    mutating func addToCatalog(){
        Contact.contactsCatalog[self.id] = self
    }
    
    func introduceSelf(){
        print()
        //print(self)
        print("---ID:---")
        print(self.id)
        print("---NAME:---")
        print((self.name==nil || self.name?.count==0) ? "nil" : self.name!)
        print("---SURNAME:---")
        print((self.surname==nil || self.surname?.count==0) ? "nil" : self.surname!)
        print("---COMPANY:---")
        print((self.company==nil || self.company?.count==0) ? "nil" : self.company!)
    }
}
