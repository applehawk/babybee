//
//  CGAgeAskingController.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit


protocol CGAgeAskingDelegate {
    func ageConfirm( date: NSDate );
    func ageCancelled();
}

class CGAgeAskingController : UIAlertController {
    
    var confirmAction : UIAlertAction?
    var textFieldBirthDate : UITextField?
    var datePicker : UIDatePicker = UIDatePicker()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var ageAskingDelegate : CGAgeAskingDelegate? = nil;

    func dataChanged(picker: UIDatePicker) {
        if let textField = textFieldBirthDate {
            textField.text = picker.date.convertDateToGOSTDateString()
            confirmAction?.enabled = textField.text != ""
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addTextFieldWithConfigurationHandler { (textField) in
            self.textFieldBirthDate = textField
            textField.inputView = self.datePicker
            textField.placeholder = CGBirthDatePlaceholder
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: #selector(CGAgeAskingController.dataChanged(_:)),
                             forControlEvents: UIControlEvents.ValueChanged );
        
        let cancelAction = UIAlertAction(title: CGCancelTitle, style: .Cancel) { (action) in
            if let delegate = self.ageAskingDelegate {
                delegate.ageCancelled()
            }
        }
        self.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: CGConfirmTitle, style: .Default) { (action) in
            let birthDate = self.datePicker.date;
            // Send to delegate Confirmation
            if let delegate = self.ageAskingDelegate {
                delegate.ageConfirm(birthDate);
            }
        }
        self.confirmAction = confirmAction
        confirmAction.enabled = false
        self.addAction(confirmAction)
    }

}