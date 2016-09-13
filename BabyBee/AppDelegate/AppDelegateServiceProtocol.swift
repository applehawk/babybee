//
//  ServiceDispatcherProtocol.swift
//  BabyBee
//
//  Created by Hawk on 13/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol AppDelegateServiceProtocol : UIApplicationDelegate {
    // MARK: Main function of AppDelegate
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    
    // MARK: Helper function for Notifications
    optional func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    optional func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    optional func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    
    // MARK: Open by URL / URLSchemes Handlers
    @available(iOS 9.0, *)
    optional func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool
    optional func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    optional func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void)
    
    @available(iOS 8.0, *)
    optional func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool
    
    
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    optional func applicationDidBecomeActive(application: UIApplication)
    optional func applicationWillResignActive(application: UIApplication)
    optional func applicationWillEnterForeground(application: UIApplication)
    optional func applicationDidEnterBackground(application: UIApplication)
}