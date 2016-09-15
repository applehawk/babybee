//
//  ApplicationAssembly.swift
//  BabyBee
//
//  Created by Hawk on 13/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Typhoon

class ApplicationAssembly: TyphoonAssembly {
    /*
     * This is the definition for our AppDelegate. Typhoon will inject the specified properties
     * at application startup.
     */
    dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            
            let services : [UIApplicationDelegate] =
            [
                RootService(),
                GoogleAnalyticsService(),
                FirebaseNotificationService(),
                FirebaseService(),
                StoryKitService()
            ]
            definition.injectProperty("serviceDispatcher", with: AppDelegateServiceDispatcher(services: services))
            definition.injectProperty("appAssembly", with: self)
        }
    }
    
    /*
     * A config definition, referencing properties that will be loaded from a plist.
     */
    dynamic func config() -> AnyObject {
        
        return TyphoonDefinition.withConfigName("Configuration.plist")
    }
    
    dynamic func storyboard() -> AnyObject {
        return TyphoonDefinition.withClass(TyphoonStoryboard.self){
            (definition) in
            
            definition.useInitializer("storyboardWithName:factory:bundle:"){
                (initializer) in
                
                initializer.injectParameterWith("Main")
                initializer.injectParameterWith(self)
                initializer.injectParameterWith( NSBundle.mainBundle() )
                
            }
            definition.scope = TyphoonScope.Singleton; //Let's make this a singleton
            
        }
    }
    
    dynamic func catalogService() -> AnyObject {
        return TyphoonDefinition.withClass(CGCatalogServiceLocalJSON.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func analyticsTracker() -> AnyObject {
        return TyphoonDefinition.withClass(CGAnalyticsTracker.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func mainScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGMainScreenViewController.self) {
            (definition) in
            
            definition.injectProperty("catalogService", with: self.catalogService())
            definition.injectProperty("tracker", with: self.analyticsTracker())
            definition.injectProperty("userDefaults", with: NSUserDefaults.standardUserDefaults() )
            definition.injectProperty("assembly", with: self)
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    dynamic func mainScreenDDM(catalog : CGCatalogModel) -> AnyObject {
        return TyphoonDefinition.withClass(CGMainScreenDDM.self) {
            (definition) in
            
            definition.useInitializer("initWithDelegate:catalog:") {
                (initializer) in
                
                initializer.injectParameterWith( self.mainScreenViewController() )
                initializer.injectParameterWith( catalog )
            }
        }
    }
    dynamic func gamesScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGGamesScreenViewController.self) {
            (definition) in
            
            definition.injectProperty("tracker", with: self.analyticsTracker())
            definition.injectProperty("assembly", with: self)
            
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    dynamic func gamesScreenDDM(group : CGGroupModel) -> AnyObject {
        return TyphoonDefinition.withClass(CGGamesScreenDDM.self) {
            (definition) in
            
            definition.useInitializer("initWithDelegate:group:") {
                (initializer) in
                
                initializer.injectParameterWith( self.gamesScreenViewController() )
                initializer.injectParameterWith( group ) 
            }
        }
    }
    
    dynamic func contentScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGContentScreenViewController.self) {
            (definition) in

            definition.injectProperty("tracker", with: self.analyticsTracker())
        
            definition.scope = TyphoonScope.Singleton
        }
    }
}