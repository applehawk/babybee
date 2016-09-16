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

class GoogleAnalyticsService : NSObject, AppDelegateServiceProtocol {
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let absoluteUrlString = url.absoluteURL
        let tracker = GAI.sharedInstance().defaultTracker
        
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(absoluteUrlString.absoluteString)
        
        if let urlHost = url.host where (hitParams.get(kGAICampaignSource) == nil && urlHost.characters.count != 0) {
            hitParams.set("referrer", forKey:kGAICampaignMedium);
            hitParams.set(url.host, forKey:kGAICampaignSource);
        }
        
        let hitParamsDict = hitParams.build()
        tracker.set(kGAIScreenName, value: "screen name")
        
        //[tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
        let screenViewDict = GAIDictionaryBuilder.createScreenView().setAll(hitParamsDict as [NSObject : AnyObject]).build();
        tracker.allowIDFACollection = true
        tracker.send(screenViewDict as [NSObject : AnyObject])
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.allowIDFACollection = true
        #if DEBUG
            gai.dryRun = true
            gai.logger.logLevel = GAILogLevel.Error // remove before app release
        #else
            gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        #endif
        return true
    }
}
