//
//  ContactDetailsViewController.swift
//  Phone
//
//  Created by protel on 4.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var wpButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var temporaryIntroducingField: UITextView!
    
    var contactToView: Contact?
    var dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contactToView == nil {
            self.dismiss(animated: true, completion: nil)
        }
        unableButtonsIfNotAvailable()
        nameLabel.text = (contactToView?.name ?? "") + " " + (contactToView?.surname ?? "")
        temporaryIntroducingField.text = contactToView?.introduceSelf()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func unableButtonsIfNotAvailable() {
        if contactToView?.phoneNumbers.count == 0 {
            messageButton.isEnabled = false
            callButton.isEnabled = false
            wpButton.isEnabled = false
            payButton.isEnabled = false
        }
        if contactToView?.emails.count == 0 {
            mailButton.isEnabled = false
        }
    }
    
    
    @IBAction func goBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func messageClicked(_ sender: UIButton) {
        if contactToView?.phoneNumbers.count == 0 { return }
        guard let number = contactToView?.phoneNumbers.filter({$0.count>0}).last else {return}
        
        sendMessageTo(to: number)
    }
    
    @IBAction func callClicked(_ sender: UIButton) {
        if contactToView?.phoneNumbers.count == 0 {
            return
        }
        guard let nrToCall = contactToView?.phoneNumbers.filter({$0.count>0}).last else {return}
        
        if let url = URL(string: "tel://\(nrToCall)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            popSingleActionAlert("Cannot Make A Call", "This application is not authorized to make a phone call.")
        }
    }
    
    @IBAction func whatsappCallClicked(_ sender: UIButton) {
        popSingleActionAlert("Cannot Make A WhatsApp Call", "This application is not authorized to make a WhatsApp call.")
    }
    
    @IBAction func sendMailClicked(_ sender: UIButton) {
        if contactToView?.emails.count == 0 { return }
        guard let email = contactToView?.emails.filter({$0.count>0}).last else {return}
        
        sendEmailTo(to: email)
    }
    
    @IBAction func paymentClicked(_ sender: UIButton) {
        popSingleActionAlert("Cannot Make Payment", "This application is not authorized to access to Wallet.")
    }
    
    @IBAction func addToFavoritesClicked(_ sender: UIButton) {
        Contact.contactsCatalog[contactToView?.id ?? 0]?.becomeFavorited()
        dbHelper.refreshDbFromCatalog()
    }
    
    @IBAction func addToEmergencyClicked(_ sender: UIButton) {
        Contact.contactsCatalog[contactToView?.id ?? 0]?.becomeEmergencyContact()
        dbHelper.refreshDbFromCatalog()
    }
    
    @IBAction func blockClicked(_ sender: UIButton) {
        Contact.contactsCatalog[contactToView?.id ?? 0]?.becomeBlocked()
        dbHelper.refreshDbFromCatalog()
    }
}


extension ContactDetailsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendMessageTo(to number: String){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            popSingleActionAlert("Cannot Send SMS", "This application is not authorized to send SMS.")
        }
    }
}


extension ContactDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendEmailTo(to email: String){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p></p>", isHTML: true)

            present(mail, animated: true)
        } else {
            popSingleActionAlert("Cannot Send E-Mail", "This application is not authorized to send e-mail.")
        }
    }
}
