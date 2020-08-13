//
//  ViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit
import AVFoundation

class DialPadViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var addNrButton: UIButton!
    
    var keypad: Array<UIButton> = []
    var dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper.getSavedContactsForFirstLaunch()
        
        keypad = [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, starButton, gridButton, zeroButton, callButton, deleteButton]
        disableComponentsNothingDialed()
    }
    
    override func viewDidLayoutSubviews() {
        for btn in keypad {
            btn.layer.cornerRadius = btn.frame.size.height * 0.5
        }
        entryField.inputView = UIView()
        
        disableComponentsNothingDialed()
    }
    
    
    
    @IBAction func tapOnDialPad(_ sender: UIButton) {
        entryField.insertText(sender.tag.dialPadValue())
        
        if let selectedRange = entryField.selectedTextRange {
            let cursorPosition = entryField.offset(from: entryField.beginningOfDocument, to: selectedRange.start)
            if cursorPosition == entryField.text!.count {
                entryField.endEditing(true)
            }
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(sender.tag.dialPadValue().soundValue()))
    }
    
    
    @IBAction func tapOnDelete(_ sender: UIButton) {
        entryField.deleteBackward()
    }
    
    @IBAction func tapOnCallButton(_ sender: UIButton) {
        if entryField.text == "" {
            return
        }
        if let url = URL(string: "tel://\(entryField.text!)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func tapOnAddNumber(_ sender: UIButton) {
    }
    
    
    func disableComponentsNothingDialed(){
        let shouldDisable: Bool = entryField.text == ""
        deleteButton.tintColor = shouldDisable ? UIColor.clear : UIColor.systemGray4
        addNrButton.setTitleColor(shouldDisable ? UIColor.clear : UIColor.link, for: UIControl.State.normal)
        deleteButton.isEnabled = shouldDisable ? false : true
        addNrButton.isEnabled = shouldDisable ? false : true
        if shouldDisable {
            entryField.endEditing(true)
        }
    }
    
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        
        let button = sender.delegate as! UIButton
        print("huh")
        
        if sender.state == .began {
            switch button.tag {
            case 12:
                tapOnDelete(button)
            default:
                tapOnDialPad(button)
            }
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(button.tag.dialPadValue().soundValue()))
        if button.tag == 12{
            tapOnDelete(button)
        }
        
        if sender.state == .ended {
            switch button.tag {
            case 10:
                if entryField.text?.count != 1 {
                    tapOnDelete(button)
                    entryField.insertText(",")
                }
            case 0:
                tapOnDelete(button)
                entryField.insertText("+")
            case 11:
                if entryField.text?.count != 1 {
                    tapOnDelete(button)
                    entryField.insertText(";")
                }
            case 1:
                tapOnDelete(button)
                popSingleActionAlert("Cannot Call Voicemail", "This application is not authorized to make voicemail calls.")
            case 12:
                tapOnDelete(button)
            default:
                print("Long press completed")
            }
        }
    }
}

