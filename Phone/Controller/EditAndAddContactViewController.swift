//
//  Edit&AddContactViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

//
//  FavoritesViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

enum TagDictionary: Int {
    case basicInfo = 100, ringtoneButton = 101, textToneButton = 102, notesStack = 103, phoneStack = 104, emailStack = 105, urlStack = 106, addressStack = 107, bdayStack = 108, datesStack = 109, relatedStack = 110, socialStack = 111, instantStack = 112
    case hidden = 3, fieldToRead = 2, actionButton = 1, regular = 0
}

class EditAndAddContactViewController: UIViewController {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var basicInfoStack: UIStackView!
    
    var dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gestureCreator()
        insertFieldsIntoScroll()
    }
    
    func insertFieldsIntoScroll() {
        scrollView.addSubview(bigView)
        bigView.translatesAutoresizingMaskIntoConstraints = false
        bigView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        bigView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        bigView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        bigView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        bigView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    @IBAction func addFieldTapped(_ sender: UIButton) {
        var objectToBeCopied: UIView?
        for element in sender.superview?.superview?.subviews ?? [] {
            if (element.tag <= TagDictionary.instantStack.rawValue) && (element.tag > TagDictionary.textToneButton.rawValue) {
                objectToBeCopied = element
            }
        }
        
        if objectToBeCopied == nil {
            return
        }
        
        let fieldToBeAdded = try? (objectToBeCopied?.copyObject() as! UIStackView)
        fieldToBeAdded?.isHidden = false
        fieldToBeAdded?.tag = TagDictionary.fieldToRead.rawValue
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.deleteFieldFieldTapped))
        for sub in fieldToBeAdded?.subviews ?? [] {
            if sub.tag == TagDictionary.actionButton.rawValue {
                sub.addGestureRecognizer(gesture)
            }
        }
        let superView = sender.superview?.superview as! UIStackView
        superView.addArrangedSubview(fieldToBeAdded!)
        fieldToBeAdded?.widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
        
    }
    

    @objc @IBAction func deleteFieldFieldTapped(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIButton
        view.superview?.isHidden = true
        view.superview?.removeFromSuperview()
    }
    
    @IBAction func addNewBasicInfoField(_ sender: UIButton) {
        hiddenSearch: for element in basicInfoStack.subviews {
            if element.tag == TagDictionary.hidden.rawValue {
                element.isHidden = false
                element.tag = TagDictionary.regular.rawValue
                break
            }
        }
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        var newContact = Contact(id: nil, image: nil, name: nil, surname: nil, company: nil, phoneNumbers: nil, emails: nil, emergencyByPass: false, ringtone: nil, textTone: nil, url: nil, addresses: nil, birthdays: nil, dates: nil, related: nil, social: nil, instantMessage: nil, notes: nil, prefix: nil, phoneticFirstName: nil, pronunciationFirstName: nil, middleName: nil, phoneticMiddleName: nil, phoneticLastName: nil, maidenName: nil, suffix: nil, nickname: nil, jobTitle: nil, department: nil, phoneticCompanyName: nil, linkedContacts: nil, favorited: false, blocked: false, emergencyContact: (false, ""))
        
        var bigStack: UIStackView?
        for stack in bigView.subviews {
            bigStack = stack as? UIStackView
        }
        for stack in bigStack?.subviews ?? [] {
            print(stack.tag)
            switch stack.tag {
            case TagDictionary.basicInfo.rawValue:
                var basicInfo: Array<String?> = []
                for element in stack.subviews {
                        let field = element as! UITextField
                        basicInfo.append(field.text)
                }
                newContact.prefix = basicInfo[0]
                newContact.name = basicInfo[1]
                newContact.phoneticFirstName = basicInfo[2]
                newContact.pronunciationFirstName = basicInfo[3]
                newContact.middleName = basicInfo[4]
                newContact.phoneticMiddleName = basicInfo[5]
                newContact.surname = basicInfo[6]
                newContact.phoneticLastName = basicInfo[7]
                newContact.maidenName = basicInfo[8]
                newContact.suffix = basicInfo[9]
                newContact.nickname = basicInfo[10]
                newContact.jobTitle = basicInfo[11]
                newContact.department = basicInfo[12]
                newContact.company = basicInfo[13]
                newContact.phoneticCompanyName = basicInfo[14]
                newContact.pronunciationFirstName = basicInfo[15]
            case TagDictionary.ringtoneButton.rawValue:
                newContact.ringtone = "Default"
            case TagDictionary.textToneButton.rawValue:
                newContact.textTone = "Default"
            case TagDictionary.notesStack.rawValue:
                for element in stack.subviews {
                    if element.tag == TagDictionary.fieldToRead.rawValue {
                        let field = element as! UITextView
                        newContact.notes = field.text
                    }
                }
                
            case TagDictionary.phoneStack.rawValue...TagDictionary.instantStack.rawValue:
                var data: Array<String> = []
                for element in stack.subviews {
                    if element.tag == TagDictionary.fieldToRead.rawValue {
                        for sub in element.subviews {
                            if sub is UITextField {
                                let field = sub as! UITextField
                                if (field.text?.count ?? 0) > 0 {
                                    data.append(field.text!)
                                }
                            }
                        }
                    }
                }
                print(data)
                switch stack.tag {
                case TagDictionary.phoneStack.rawValue:
                    newContact.phoneNumbers = data
                case TagDictionary.emailStack.rawValue:
                    newContact.emails = data
                case TagDictionary.urlStack.rawValue:
                    newContact.url = data
                case TagDictionary.addressStack.rawValue:
                    newContact.addresses = data
                case TagDictionary.bdayStack.rawValue:
                    newContact.birthdays = data
                case TagDictionary.datesStack.rawValue:
                    newContact.dates = data
                case TagDictionary.relatedStack.rawValue:
                    newContact.related = data
                case TagDictionary.socialStack.rawValue:
                    newContact.social = data
                case TagDictionary.instantStack.rawValue:
                    newContact.instantMessage = data
                default:
                    print("Error!")
                }
            default:
                print("Could not recognize entry field.")
            }
        }
        newContact.addToCatalog()
        dbHelper.insert(newContact: newContact)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
