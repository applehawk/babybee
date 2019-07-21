//
//  GoogleAnalyticsService.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import Firebase

let CGGoogleAnalyticsID = "UA-83542519-1"

class GoogleAnalyticsService : NSObject, UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let absoluteUrlString = url.absoluteURL
        
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            assertionFailure("Tracker not available")
            return false
        }
        
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(absoluteUrlString.absoluteString)
        
        if let urlHost = url.host,
            hitParams.get(kGAICampaignSource) == nil,
            urlHost.count != 0
        {
            hitParams.set("referrer", forKey:kGAICampaignMedium);
            hitParams.set(url.host, forKey:kGAICampaignSource);
        }
        
        let hitParamsDict = hitParams.build()
        tracker.set(kGAIScreenName, value: "screen name")
        
        //[tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
        let screenViewDict = GAIDictionaryBuilder.createScreenView()?.setAll(hitParamsDict as? [AnyHashable : Any])?.build()
        /*
         let screenViewDict = GAIDictionaryBuilder.createScreenView().setAll(hitParamsDict as [NSObject : AnyObject]).build();*/
        tracker.allowIDFACollection = true
        tracker.send(screenViewDict as? [AnyHashable : Any])
        return true
    }
    /*
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let absoluteUrlString = url.absoluteURL
        
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            assertionFailure("Tracker not available")
            return false
        }
        
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(absoluteUrlString?.absoluteString)
        
        if let urlHost = url.host,
            hitParams.get(kGAICampaignSource) == nil,
            urlHost.count != 0
        {
            hitParams.set("referrer", forKey:kGAICampaignMedium);
            hitParams.set(url.host, forKey:kGAICampaignSource);
        }
        
        let hitParamsDict = hitParams.build()
        tracker.set(kGAIScreenName, value: "screen name")
        
        //[tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
        let screenViewDict = GAIDictionaryBuilder.createScreenView()?.setAll(hitParamsDict as! [AnyHashable : Any])?.build()
        /*
        let screenViewDict = GAIDictionaryBuilder.createScreenView().setAll(hitParamsDict as [NSObject : AnyObject]).build();*/
        tracker.allowIDFACollection = true
        tracker.send(screenViewDict as? [AnyHashable : Any])
        return true
    }*/
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Configure tracker from GoogleService-Info.plist.
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        guard let gai = GAI.sharedInstance() else {
            assertionFailure("GAI Not available")
            return false
        }
        guard let tracker = gai.defaultTracker else {
            assertionFailure("Tracker not available")
            return false
        }
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        tracker.allowIDFACollection = true
        #if DEBUG
        gai.dryRun = true
        gai.logger.logLevel = .error // remove before app release
        #else
        gai.logger.logLevel = .verbose  // remove before app release
        #endif
        return true
    }
    /*
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Configure tracker from GoogleService-Info.plist.
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        guard let gai = GAI.sharedInstance() else {
            assertionFailure("GAI Not available")
            return false
        }
        guard let tracker = gai.defaultTracker else {
            assertionFailure("Tracker not available")
            return false
        }
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        tracker.allowIDFACollection = true
        #if DEBUG
            gai.dryRun = true
            gai.logger.logLevel = .error // remove before app release
        #else
            gai.logger.logLevel = .verbose  // remove before app release
        #endif
        return true
    }*/
}
