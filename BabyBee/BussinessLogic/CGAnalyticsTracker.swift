//
//  AnalyticsTracker.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import Firebase

@objc protocol CGAnalyticsTrackerProtocol {
    func sendOpenScreen( screenName : String );
    func sendAction( actionName : String, categoryName : String, label: String, value: NSNumber );
}

public class CGAnalyticsTracker: NSObject, CGAnalyticsTrackerProtocol {
    func sendOpenScreen( screenName : String ) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.allowIDFACollection = true
            tracker.set(kGAIScreenName, value: screenName)
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
        FIRAnalytics.logEventWithName("openScreen", parameters: ["screeName" : screenName])
    }
    
    func sendAction(actionName : String, categoryName : String, label: String, value: NSNumber ) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.allowIDFACollection = true
            let builder = GAIDictionaryBuilder.createEventWithCategory(categoryName, action: actionName, label: label, value: value);
            
            tracker.send( builder.build() as [NSObject : AnyObject])
        }
        
        FIRAnalytics.logEventWithName(actionName,
                                      parameters:
            ["category" : categoryName,
                "label" : label, "value":value])
    }
}