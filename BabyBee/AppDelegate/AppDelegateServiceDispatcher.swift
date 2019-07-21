//
//  ServiceDispatcher.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit.UIApplication

class AppDelegateServiceDispatcher : UIResponder, UIApplicationDelegate {
    let services: [UIApplicationDelegate]
    
    init(services: [UIApplicationDelegate]) {
        self.services = services
    }
    // MARK: Helper function for Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        services.forEach { service in
            service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        services.forEach { service in
            service.application?(application, didReceiveRemoteNotification: userInfo)
        }
    }
    /*
     /*Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]*/
     
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        services.forEach { service in
            service.application?(application, didReceiveLocalNotification: notification)
        }
    }
    */
    
    // MARK: Open by URL / URLSchemes Handlers
    /*
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        services.forEach { service in
            service.application?(application, openURL: url, options: options)
        }
        return true
    }*/
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var boolResult = true
        services.forEach { service in
            boolResult = boolResult && service.application?(app, open: url, options: options) ?? true
        }
        return boolResult
    }
    
    /*
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        services.forEach { service in
            service.application?(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }*/
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        services.forEach { service in
            service.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
        }
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        services.forEach { service in
            service.application?(application, willContinueUserActivityWithType: userActivityType)
        }
        return true
    }
    /*
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        services.forEach { service in
            service.application?(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
        }
        return true
    }*/
    
    // MARK: Main function of AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        services.forEach { service in
            service.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    func applicationDidBecomeActive(_ application: UIApplication) {
        services.forEach { service in
            service.applicationDidBecomeActive?(application)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        services.forEach { service in
            service.applicationWillResignActive?(application)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        services.forEach { service in
            service.applicationWillEnterForeground?(application)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        services.forEach { service in
            service.applicationDidEnterBackground?(application)
        }
    }
}
