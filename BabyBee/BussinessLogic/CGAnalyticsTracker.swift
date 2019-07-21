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
    func sendOpenScreen(_ screenName : String );
    func sendAction(withName actionName: String, actionTitle : String, categoryName : String, label: String, value: NSNumber );
}

public class CGAnalyticsTracker: NSObject, CGAnalyticsTrackerProtocol {
    func sendOpenScreenGoogleAnalytics(_ screenName: String) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.allowIDFACollection = true
            tracker.set(kGAIScreenName, value: screenName)
            
            guard let builder = GAIDictionaryBuilder.createScreenView() else {
                assertionFailure("failed with createScreenView inside sendOpenScreenGoogleAnalytics")
                return
            }
            tracker.send(builder.build() as? [AnyHashable : Any])
        }
    }
    func sendOpenScreen(_ screenName : String) {
        self.sendOpenScreenGoogleAnalytics(screenName)
        FIRAnalytics.logEvent(withName: "openScreen", parameters: ["screeName" : screenName])
    }
    
    func sendAction(withName actionName: String,
                    actionTitle : String,
                    categoryName : String,
                    label: String,
                    value: NSNumber ) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.allowIDFACollection = true
            
            guard let builder = GAIDictionaryBuilder.createEvent(withCategory: categoryName, action: actionName, label: label, value: value) else {
                assertionFailure("failed with createScreenView inside sendAction")
                return
            }
            tracker.send( builder.build() as? [AnyHashable : Any])
        }
        
        FIRAnalytics.logEvent(withName: actionName,
                                      parameters:
            ["category" : categoryName,
                "label" : label, "value":value])
    }
}
