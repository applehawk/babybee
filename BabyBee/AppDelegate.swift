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
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.allowIDFACollection = true
        
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
    
    func registerRemoteNotifications(application: UIApplication) {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureGoogleAnalytics()
        configureStoreKit();
        
        registerRemoteNotifications(application)
        let token = FIRInstanceID.instanceID().token()!
        print("FCM Token: \(token)")
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let urlString = url.absoluteURL
        let tracker = GAI.sharedInstance().defaultTracker
        
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(urlString.absoluteString)

        if let urlHost = url.host where (hitParams.get(kGAICampaignSource) == nil && urlHost.characters.count != 0) {
            hitParams.set("referrer", forKey:kGAICampaignMedium);
            hitParams.set(url.host, forKey:kGAICampaignSource);
        }
        
        let hitParamsDict = hitParams.build()
        tracker.set(kGAIScreenName, value: "screen name")
        
        //[tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
        let screenViewDict = GAIDictionaryBuilder.createScreenView().setAll(hitParamsDict as [NSObject : AnyObject]).build();
        tracker.send(screenViewDict as [NSObject : AnyObject])
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

