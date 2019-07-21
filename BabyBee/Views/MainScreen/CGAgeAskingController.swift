//
//  CGAgeAskingController.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit


protocol CGAgeAskingDelegate {
    func ageConfirm(_ date: Date )
    func ageCancelled()
}

class CGAgeAskingController : UIAlertController {
    
    var confirmAction : UIAlertAction?
    var textFieldBirthDate : UITextField?
    var datePicker : UIDatePicker = UIDatePicker()
    
    let userDefaults = UserDefaults.standard
    var ageAskingDelegate : CGAgeAskingDelegate? = nil;

    @objc func dataChanged(_ picker: UIDatePicker) {
        if let textField = textFieldBirthDate {
            textField.text = picker.date.convertDateToGOSTDateString()
            confirmAction?.isEnabled = textField.text != ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTextField { textField in
            self.textFieldBirthDate = textField
            textField.inputView = self.datePicker
            textField.placeholder = CGBirthDatePlaceholder
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeIntervalSinceNow: 0)
        datePicker.addTarget(self, action: #selector(CGAgeAskingController.dataChanged(_:)), for: .valueChanged)
        
        let cancelAction = UIAlertAction(title: CGCancelTitle, style: .cancel) { (action) in
            if let delegate = self.ageAskingDelegate {
                delegate.ageCancelled()
            }
        }
        self.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: CGConfirmTitle, style: .default) { (action) in
            let birthDate = self.datePicker.date;
            // Send to delegate Confirmation
            if let delegate = self.ageAskingDelegate {
                delegate.ageConfirm(birthDate);
            }
        }
        self.confirmAction = confirmAction
        confirmAction.isEnabled = false
        self.addAction(confirmAction)
    }

}
