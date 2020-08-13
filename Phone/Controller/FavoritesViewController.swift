//
//  FavoritesViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
extension UIViewController { // Required for keyboard dismiss on tap
    func gestureCreator(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



class FavoritesViewController: UIViewController {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var photoStack: UIStackView!
    @IBOutlet weak var basicInfoStack: UIStackView!
    @IBOutlet weak var phoneNrStack: UIStackView!
    
    @IBOutlet weak var prefixField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var phoFirstNameField: UITextField!
    @IBOutlet weak var proFirstNameField: UITextField!
    @IBOutlet weak var midNameField: UITextField!
    @IBOutlet weak var phoMidNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoLastNameField: UITextField!
    @IBOutlet weak var maidenNameField: UITextField!
    @IBOutlet weak var suffixField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var jobTitleField: UITextField!
    @IBOutlet weak var departmentField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var phoCompanyField: UITextField!
    @IBOutlet weak var proCompanyField: UITextField!
    
    @IBOutlet weak var phoneFieldStack: UIStackView!
    
    
    var dbHelper = DBHelper()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gestureCreator()
        scrollView.addSubview(bigView)
        bigView.translatesAutoresizingMaskIntoConstraints = false
        bigView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        bigView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        bigView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        bigView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        bigView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    @IBAction func createDB(_ sender: UIBarButtonItem) {
        dbHelper.openDatabase()
        dbHelper.createTable()
    }
    
    

    
    @IBAction func addFieldTapped(_ sender: UIButton) {
        var objectToBeCopied: UIView = phoneFieldStack
        for element in sender.superview?.superview?.subviews ?? [] {
            if (element.tag < 111) && (element.tag > 99) {
                objectToBeCopied = element
            }
        }
        let fieldToBeAdded = try? (objectToBeCopied.copyObject() as! UIStackView)
        fieldToBeAdded?.isHidden = false
        fieldToBeAdded?.tag = 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.deleteFieldFieldTapped))
        for sub in fieldToBeAdded?.subviews ?? [] {
            if sub.tag == 1 {
                sub.addGestureRecognizer(gesture)
            }
        }
        let superView = sender.superview?.superview as! UIStackView
        superView.addArrangedSubview(fieldToBeAdded!)
        fieldToBeAdded?.widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
        
    }
    

    @objc @IBAction func deleteFieldFieldTapped(_ sender: UITapGestureRecognizer) {
        print("TAP")
        let view = sender.view as! UIButton
        view.superview?.isHidden = true
        view.superview?.removeFromSuperview()
    }
    
    @IBAction func addFieldClicked(_ sender: UIButton) {
        hiddenSearch: for element in basicInfoStack.subviews {
            if element.tag == 3 {
                element.isHidden = false
                element.tag = 0
                break
            }
        }
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var newContact = Contact(id: 0, favorited: false, blocked: false, emergencyContact: (false, ""))
        var bigStack: UIStackView?
        for stack in bigView.subviews {
            bigStack = stack as? UIStackView
        }
        for stack in bigStack?.subviews ?? [] {
            print(stack.tag)
            switch stack.tag {
            case 100:
                var basicInfo: Array<String> = []
                for element in stack.subviews {
                    let field = element as! UITextField
                    basicInfo.append(field.text ?? "")
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
            case 101:
                newContact.ringtone = "Default"
            case 102:
                newContact.textTone = "Default"
            case 103:
                for element in stack.subviews {
                    if element.tag == 2 {
                        let field = element as! UITextView
                        newContact.notes = field.text
                    }
                }
            case 104...112:
                var data: Array<String> = []
                for element in stack.subviews {
                    if element.tag == 2 {
                        for sub in element.subviews {
                            if sub is UITextField {
                                let field = sub as! UITextField
                                data.append(field.text ?? "nah")
                            }
                        }
                    }
                }
                print(data)
                switch stack.tag {
                case 104:
                    newContact.phoneNumbers = data
                case 105:
                    newContact.emails = data
                case 106:
                    newContact.url = data
                case 107:
                    newContact.addresses = data
                case 108:
                    newContact.birthdays = data
                case 109:
                    newContact.dates = data
                case 110:
                    newContact.related = data
                case 111:
                    newContact.social = data
                case 112:
                    newContact.instantMessage = data
                default:
                    print("Error occurred")
                }
            default:
                print("Error occurred!")
            }
        }
        newContact.addToCatalog()
        print(Contact.contactsCatalog)
        dbHelper.insert(newContact: newContact)
        print(dbHelper.read()[0])
    }
    
    
    
}
