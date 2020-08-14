//
//  DBHelper.swift
//  Phone
//
//  Created by protel on 12.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTables()
    }

    let dbPath: String = "myDatabase.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("Could not open database...")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTables() {
        let createMainTableString = " CREATE TABLE IF NOT EXISTS contact(Id INTEGER PRIMARY KEY, name TEXT, surname TEXT, company TEXT, emergencyByPass INT, ringtone TEXT, textTone TEXT, notes TEXT, prefix TEXT, phoFirstName TEXT, proFirstName TEXT, middleName TEXT, phoMiddlename TEXT, phoLastName TEXT, maidenName TEXT, suffix TEXT, nickname TEXT, jobTitle TEXT, department TEXT, phoCompanyName TEXT, favorited INT, blocked INT); "
        let createSecondaryTableString = " CREATE TABLE IF NOT EXISTS contactAdditionalData(Id INTEGER NOT NULL, dataType INT NOT NULL, data TEXT, FOREIGN KEY (Id) REFERENCES contact(Id)); "
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createMainTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Main table created.")
            } else {
                print("Main table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
        
        var secondaryCreateTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createSecondaryTableString, -1, &secondaryCreateTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(secondaryCreateTableStatement) == SQLITE_DONE
            {
                print("Secondary table created.")
            } else {
                print("Secondary table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(secondaryCreateTableStatement)
    }
    
    
    func insert(newContact: Contact)
    {
        let contacts = read()
        for person in contacts
        {
            if person.id == newContact.id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO contact (Id, name, surname, company, emergencyByPass, ringtone, textTone, notes, prefix, phoFirstName, proFirstName, middleName, phoMiddlename, phoLastName, maidenName, suffix, nickname, jobTitle, department, phoCompanyName, favorited, blocked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(newContact.id))
            sqlite3_bind_text(insertStatement, 2, ((newContact.name ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, ((newContact.surname ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, ((newContact.company ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32((newContact.emergencyByPass ?? false) ? 1 : 0))
            sqlite3_bind_text(insertStatement, 6, ((newContact.ringtone ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, ((newContact.textTone ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, ((newContact.notes ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, ((newContact.prefix ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, ((newContact.phoneticFirstName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, ((newContact.pronunciationFirstName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, ((newContact.middleName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, ((newContact.phoneticMiddleName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 14, ((newContact.phoneticLastName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 15, ((newContact.maidenName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 16, ((newContact.suffix ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 17, ((newContact.nickname ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 18, ((newContact.jobTitle ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 19, ((newContact.department ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 20, ((newContact.phoneticCompanyName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 21, Int32((newContact.favorited) ? 1 : 0))
            sqlite3_bind_int(insertStatement, 22, Int32((newContact.blocked) ? 1 : 0))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        gatherAdditionalDataOfNewContact(newContact)
    }
    
    func gatherAdditionalDataOfNewContact(_ newContact: Contact) {
        for phone in newContact.phoneNumbers {
            addSecondaryData(id: newContact.id, type: 0, data: phone)
        }
        
        for mail in newContact.emails {
            addSecondaryData(id: newContact.id, type: 1, data: mail)
        }
        
        for address in newContact.addresses {
            addSecondaryData(id: newContact.id, type: 2, data: address)
        }
        
        for url in newContact.url {
            addSecondaryData(id: newContact.id, type: 3, data: url)
        }
        
        for bday in newContact.birthdays {
            addSecondaryData(id: newContact.id, type: 4, data: bday)
        }
        
        for date in newContact.dates{
            addSecondaryData(id: newContact.id, type: 5, data: date)
        }
        
        for related in newContact.related {
            addSecondaryData(id: newContact.id, type: 6, data: related)
        }
        
        for socail in newContact.social {
            addSecondaryData(id: newContact.id, type: 7, data: socail)
        }
        
        for insMessage in newContact.instantMessage {
            addSecondaryData(id: newContact.id, type: 8, data: insMessage)
        }
    }
    
    func addSecondaryData(id: Int, type: Int, data: String){
        let secondaryInsertStatementString = "INSERT INTO contactAdditionalData (Id, dataType, data) VALUES (?, ?, ?);"
        var secondaryInsertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, secondaryInsertStatementString, -1, &secondaryInsertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(secondaryInsertStatement, 1, Int32(id))
            sqlite3_bind_int(secondaryInsertStatement, 2, Int32(type))
            sqlite3_bind_text(secondaryInsertStatement, 3, (data as NSString).utf8String, -1, nil)
            
            if sqlite3_step(secondaryInsertStatement) == SQLITE_DONE {
                print("Successfully inserted secondary data row.")
            } else {
                print("Could not insert secondary data row.")
            }
        } else {
            print("secondary INSERT statement could not be prepared.")
        }
        sqlite3_finalize(secondaryInsertStatement)
    }
    
    func getSavedContactsForFirstLaunch() {
        let contacts = self.read()
        print("CONTACTS RETRIEVED FROM MEMORY")
        for var contact in contacts {
            contact.addToCatalog()
            contact.introduceSelf()
        }
        
    }
    
    func read() -> [Contact] {
        let queryStatementString = "SELECT * FROM contact;"
        let secondaryQueryStatementString = "SELECT * FROM contactAdditionalData"
        
        var queryStatement: OpaquePointer? = nil
        var secondaryQueryStatement: OpaquePointer? = nil
        
        var contacts : Dictionary<Int,Contact> = [:]
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let newContact = Contact(id: Int(sqlite3_column_int(queryStatement, 0)), image: nil, name: String(describing: String(cString: sqlite3_column_text(queryStatement, 1))), surname: String(describing: String(cString: sqlite3_column_text(queryStatement, 2))), company: String(describing: String(cString: sqlite3_column_text(queryStatement, 3))), phoneNumbers: nil, emails:nil, emergencyByPass: Int(sqlite3_column_int(queryStatement, 4)) == 1, ringtone: String(describing: String(cString: sqlite3_column_text(queryStatement, 5))), textTone: String(describing: String(cString: sqlite3_column_text(queryStatement, 6))), url: nil, addresses: nil, birthdays: nil, dates: nil, related: nil, social: nil, instantMessage: nil, notes: String(describing: String(cString: sqlite3_column_text(queryStatement, 7))), prefix: String(describing: String(cString: sqlite3_column_text(queryStatement, 8))), phoneticFirstName: String(describing: String(cString: sqlite3_column_text(queryStatement, 9))), pronunciationFirstName: String(describing: String(cString: sqlite3_column_text(queryStatement, 10))), middleName: String(describing: String(cString: sqlite3_column_text(queryStatement, 11))), phoneticMiddleName: String(describing: String(cString: sqlite3_column_text(queryStatement, 12))), phoneticLastName: String(describing: String(cString: sqlite3_column_text(queryStatement, 13))), maidenName: String(describing: String(cString: sqlite3_column_text(queryStatement, 14))), suffix: String(describing: String(cString: sqlite3_column_text(queryStatement, 15))), nickname: String(describing: String(cString: sqlite3_column_text(queryStatement, 16))), jobTitle: String(describing: String(cString: sqlite3_column_text(queryStatement, 17))), department: String(describing: String(cString: sqlite3_column_text(queryStatement, 18))), phoneticCompanyName: String(describing: String(cString: sqlite3_column_text(queryStatement, 19))), linkedContacts: [:], favorited: Int(sqlite3_column_int(queryStatement, 20)) == 1, blocked: Int(sqlite3_column_int(queryStatement, 21)) == 1, emergencyContact: (false,""))
                contacts[newContact.id] = newContact
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        
        
        if sqlite3_prepare_v2(db, secondaryQueryStatementString, -1, &secondaryQueryStatement, nil) == SQLITE_OK {
            while sqlite3_step(secondaryQueryStatement) == SQLITE_ROW {
                switch sqlite3_column_int(secondaryQueryStatement, 1) {
                case 0:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.phoneNumbers.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 1:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.emails.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 2:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.addresses.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 3:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.url.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 4:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.birthdays.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 5:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.dates.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 6:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.related.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 7:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.social.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                case 8:
                    contacts[Int(sqlite3_column_int(secondaryQueryStatement, 0))]?.instantMessage.append(String(describing: String(cString: sqlite3_column_text(secondaryQueryStatement, 2))))
                default:
                    print("Unrecognized data")
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(secondaryQueryStatement)
        
        var finalContacts: [Contact] = []
        
        for key in contacts.keys {
            finalContacts.append(contacts[key]!)
        }
        return finalContacts
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM contact WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
