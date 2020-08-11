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
    

    
    @IBAction func addFieldTapped(_ sender: UIButton) {
        var objectToBeCopied: UIView = phoneFieldStack
        for element in sender.superview?.superview?.subviews ?? [] {
            if element.tag == 2 {
                objectToBeCopied = element
            }
        }
        let fieldToBeAdded = try? (objectToBeCopied.copyObject() as! UIStackView)
        fieldToBeAdded?.isHidden = false
        fieldToBeAdded?.tag = 0
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
        hiddenSearch: for element in basicInfoStack.subviews ?? [] {
            if element.tag == 3 {
                element.isHidden = false
                break
            }
        }
    }
    
    
}
