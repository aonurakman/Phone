//
//  Edit&AddContactViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class Edit_AddContactViewController: UIViewController {
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var basicInfoStack: UIStackView!
    @IBOutlet weak var addPhoneButton: UIButton!
    @IBOutlet weak var bigStack: UIStackView!
    
    var dbHelper = DBHelper()
    var delegate: NewContactDelegate?
    
    var phoneNumberToSave: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gestureCreator()
        insertFieldsIntoScroll()
        if phoneNumberToSave != nil {
            addFieldTapped(addPhoneButton)
            
        }
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

    
    @IBAction func addFieldTapped(_ sender: UIButton){
        guard let typeView = bigStack.subviews.filter({ $0.tag == sender.tag }).first as? UIStackView
            else { return }
        guard let objectToBeCopied = typeView.subviews.filter({ $0.tag == TagDictionary.fieldToCopy.rawValue }).last
            else { return }
        guard let fieldToBeAdded = try? (objectToBeCopied.copyObject() as? UIStackView)
            else { return }
        
        fieldToBeAdded.isHidden = false
        fieldToBeAdded.tag = TagDictionary.fieldToRead.rawValue
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.deleteFieldTapped))
        for sub in fieldToBeAdded.subviews {
            if sub.tag == TagDictionary.actionButton.rawValue {
                sub.addGestureRecognizer(gesture)
            }
            else if (sub is UITextField) && (phoneNumberToSave != nil) && (sender == addPhoneButton) {
                let field = sub as! UITextField
                field.text = phoneNumberToSave
                phoneNumberToSave = nil
            }
        }
        
        typeView.addArrangedSubview(fieldToBeAdded)
        fieldToBeAdded.widthAnchor.constraint(equalTo: typeView.widthAnchor).isActive = true
    }
    
    
    @objc @IBAction func deleteFieldTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UIButton else {
            return
        }
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
        var newContact = Contact(id: nil, image: nil, name: nil, surname: nil, company: nil, phoneNumbers: nil, emails: nil, emergencyByPass: false, ringtone: nil, textTone: nil, url: nil, addresses: nil, birthdays: nil, dates: nil, related: nil, social: nil, instantMessage: nil, notes: nil, prefix: nil, phoneticFirstName: nil, pronunciationFirstName: nil, middleName: nil, phoneticMiddleName: nil, phoneticLastName: nil, maidenName: nil, suffix: nil, nickname: nil, jobTitle: nil, department: nil, phoneticCompanyName: nil, linkedContacts: nil, favorited: false, blocked: false, isEmergencyContact: (false, ""))
        
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
        delegate?.didNewContactAdded()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
