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
    var refDB : FIRDatabase!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: "doitlikeacat@gmail.com", password: "helloworld14")
        print(credential.provider)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        FIRAnalytics.handleOpen(url)
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        FIRAnalytics.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        FIRAnalytics.handleUserActivity(userActivity)
        return true
    }
}
