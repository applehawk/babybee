//
//  FirebaseService.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: NSObject, UIApplicationDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        FIRApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL,
                     options: [String : AnyObject]) -> Bool {
        FIRAnalytics.handleOpenURL(url)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        FIRAnalytics.handleOpenURL(url)
        return true
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        FIRAnalytics.handleEventsForBackgroundURLSession(identifier, completionHandler: completionHandler)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        FIRAnalytics.handleUserActivity(userActivity)
        return true
    }
}