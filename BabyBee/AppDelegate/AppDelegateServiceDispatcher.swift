//
//  ServiceDispatcher.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit.UIApplication

class AppDelegateServiceDispatcher : UIResponder, AppDelegateServiceProtocol {
    let services: [AppDelegateServiceProtocol]
    
    init(services: [AppDelegateServiceProtocol]) {
        self.services = services
    }
    // MARK: Helper function for Notifications
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        services.forEach { service in
            service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        services.forEach { service in
            service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        services.forEach { service in
            service.application?(application, didReceiveLocalNotification: notification)
        }
    }
    
    // MARK: Open by URL / URLSchemes Handlers
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        services.forEach { service in
            service.application?(application, openURL: url, options: options)
        }
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        services.forEach { service in
            service.application?(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        services.forEach { service in
            service.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        services.forEach { service in
            service.application?(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
        }
        return true
    }
    
    // MARK: Main function of AppDelegate
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        services.forEach { service in
            service.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    
    
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    func applicationDidBecomeActive(application: UIApplication) {
        services.forEach { service in
            service.applicationDidBecomeActive?(application)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        services.forEach { service in
            service.applicationWillResignActive?(application)
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        services.forEach { service in
            service.applicationWillEnterForeground?(application)
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        services.forEach { service in
            service.applicationDidEnterBackground?(application)
        }
    }
}