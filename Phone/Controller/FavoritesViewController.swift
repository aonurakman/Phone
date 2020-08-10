//
//  FavoritesViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(bigView)
        bigView.translatesAutoresizingMaskIntoConstraints = false
        bigView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        bigView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        bigView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        bigView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        bigView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
