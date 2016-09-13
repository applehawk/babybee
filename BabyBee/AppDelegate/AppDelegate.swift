//
//  AppDelegate.swift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appAssembly: ApplicationAssembly!
    var serviceDispatcher : AppDelegateServiceProtocol!
    
    // MARK: Main function of AppDelegate
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return serviceDispatcher.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: Helper function for Notifications
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        serviceDispatcher.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        serviceDispatcher.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        serviceDispatcher.application?(application, didReceiveLocalNotification: notification)
    }
    
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    func applicationWillResignActive(application: UIApplication) {
        serviceDispatcher.applicationWillResignActive?(application)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        serviceDispatcher.applicationDidEnterBackground?(application)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        serviceDispatcher.applicationWillEnterForeground?(application)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        serviceDispatcher.applicationDidBecomeActive?(application)
    }
    
    // MARK: Works with remote URLs
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if let resultBool = serviceDispatcher.application?(application,
                                      openURL: url,
                                      sourceApplication: sourceApplication,
                                      annotation: annotation) {
            return resultBool
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if let resultBool = serviceDispatcher.application?(application, openURL: url, options: options) {
                return resultBool
        }
        return true
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        
        serviceDispatcher.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if let resultBool = serviceDispatcher.application?(application, continueUserActivity: userActivity, restorationHandler: restorationHandler) {
            return resultBool
        }
        return false
    }
}

