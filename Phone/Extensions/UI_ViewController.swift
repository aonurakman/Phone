//
//  UI_ViewController.swift
//  Phone
//
//  Created by protel on 13.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

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


extension UIViewController {
    func popSingleActionAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
