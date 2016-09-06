//
//  AppDelegate.swift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit
import Firebase
import SwiftyStoreKit

let CGGoogleAnalyticsID = "UA-83542519-1"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func configureGoogleAnalytics() {
        // Configure tracker from GoogleService-Info.plist.
        //var configureError:NSError?
        //GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        FIRApp.configure()
        
        // Optional: configure GAI options.
        //let gai = GAI.sharedInstance()
        //gai.trackUncaughtExceptions = true  // report uncaught exceptions
        //gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
    }
    
    func configureStoreKit() -> Bool {
        SwiftyStoreKit.completeTransactions() { completedTransactions in
            
            for completedTransaction in completedTransactions {
                
                if completedTransaction.transactionState == .Purchased || completedTransaction.transactionState == .Restored {
                    
                    print("purchased: \(completedTransaction.productId)")
                }
            }
        }
        return true;
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        configureGoogleAnalytics()
        configureStoreKit();
        
        return true
    }
}

