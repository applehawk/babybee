//
//  UIViewController.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func sendOpenScreen( screenName : String ) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screenName)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func sendAction( actionName : String, categoryName : String, label: String, value: NSNumber ) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        let builder = GAIDictionaryBuilder.createEventWithCategory(categoryName, action: actionName, label: label, value: value);
        
        tracker.send( builder.build() as [NSObject : AnyObject])
        
        FIRAnalytics.logEventWithName(actionName,
                                      parameters:
            ["category" : categoryName,
                "label" : label, "value":value])
    }
}