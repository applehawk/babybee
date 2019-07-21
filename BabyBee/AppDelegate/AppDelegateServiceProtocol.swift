//
//  ServiceDispatcherProtocol.swift
//  BabyBee
//
//  Created by Hawk on 13/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

protocol AppDelegateServiceProtocol : UIApplicationDelegate {
    
    
    // MARK: Main function of AppDelegate
    /*
    @objc optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool

    
    // MARK: Helper function for Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    /*
    optional func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    optional func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    optional func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
 */
    
    // MARK: Open by URL / URLSchemes Handlers
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    /*
    optional func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool
    optional func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    optional func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void)*/
    
    @available(iOS 8.0, *)
    /*
    optional func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool*/
    
    
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    
    
    @objc optional func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
 */
 }
