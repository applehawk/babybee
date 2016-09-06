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
    
    var googleSignInInstance = AppGoogleSignInDelegate()
    
    func configureGoogleAnalytics() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = googleSignInInstance
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
    
    // MARK: Google SignIn
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
}

