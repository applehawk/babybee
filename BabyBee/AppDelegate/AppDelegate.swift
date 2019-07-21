//
//  AppDelegate.swift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //var appAssembly: ApplicationAssembly!
    var serviceDispatcher : UIApplicationDelegate! = DIResolver.resolve(AppDelegateServiceDispatcher.self)
    
    // MARK: Main function of AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = DIResolver.createMainStoryboard()
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        return serviceDispatcher.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
    }
    
    // MARK: Helper function for Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        serviceDispatcher.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        serviceDispatcher.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    /* Should be implemented in
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        serviceDispatcher.application?(application, didReceiveLocalNotification: notification)
    }
    */
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    func applicationWillResignActive(_ application: UIApplication) {
        serviceDispatcher.applicationWillResignActive?(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        serviceDispatcher.applicationDidEnterBackground?(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        serviceDispatcher.applicationWillEnterForeground?(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        serviceDispatcher.applicationDidBecomeActive?(application)
    }
    
    // MARK: Works with remote URLs
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let resultBool = serviceDispatcher.application?(app, open: url, options: options) {
            return resultBool
        }
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        serviceDispatcher.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let resultBool = serviceDispatcher.application?(application, continue: userActivity, restorationHandler: restorationHandler) {
            return resultBool
        }
        return false
    }
    
}

/*
 We should implement it in next feature
extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
*/
