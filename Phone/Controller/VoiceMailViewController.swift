//
//  VoiceMailViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class VoiceMailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func callVmTapped(_ sender: UIButton) {
        popSingleActionAlert("Cannot Call Voicemail", "This application is not authorized to make voicemail calls.")
    }
    
}


