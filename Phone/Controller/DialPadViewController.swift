//
//  ViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit
import AVFoundation

extension String {
    func soundValue() -> Int{
        let soundDictionary: Dictionary<String,Int> = ["0":1200, "1":1201, "2":1202, "3":1203, "4":1204, "5":1205, "6":1206, "7":1207, "8":1208, "9":1209, "*": 1210, "#": 1211]
        return soundDictionary[self] ?? 0
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keypad = [oneButton,twoButton,threeButton,fourButton,fiveButton,sixButton,sevenButton,eightButton,nineButton,starButton,gridButton,zeroButton]
        disableComponentsIfFieldIsEmpty()
    }
    
    
    override func viewDidLayoutSubviews() {
        oneButton.layer.cornerRadius = oneButton.bounds.size.height * 0.5
        twoButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        threeButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        fourButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        fiveButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        sixButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        sevenButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        eightButton.layer.cornerRadius = oneButton.frame.size.height / 2
        nineButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        starButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        zeroButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        gridButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        callButton.layer.cornerRadius = oneButton.frame.size.height * 0.5
        entryField.inputView = UIView()
        
        disableComponentsIfFieldIsEmpty()
    }
    
    @IBAction func tapOnDialPad(_ sender: UIButton) {
        entryField.insertText(sender.accessibilityLabel ?? "")
        if let selectedRange = entryField.selectedTextRange {
            let cursorPosition = entryField.offset(from: entryField.beginningOfDocument, to: selectedRange.start)
            if cursorPosition == entryField.text!.count {
                entryField.endEditing(true)
            }
        }
        AudioServicesPlaySystemSound(SystemSoundID(sender.accessibilityLabel!.soundValue()))
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
    
    
    func disableComponentsIfFieldIsEmpty(){
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
        
        if sender.state == .began {
            AudioServicesPlaySystemSound(SystemSoundID(button.accessibilityLabel!.soundValue()))
            switch button.accessibilityLabel {
            case "*":
                entryField.insertText(",")
            case "0":
                entryField.insertText("+")
            case "#":
                entryField.insertText(";")
            default:
                print("1")
            }
        }
        
        if button.accessibilityLabel == "del"{
            tapOnDelete(button)
        }
        
        
    }
    
}

