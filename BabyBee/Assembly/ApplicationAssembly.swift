//
//  ApplicationAssembly.swift
//  BabyBee
//
//  Created by Hawk on 13/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Typhoon

public class ApplicationAssembly: TyphoonAssembly {
    /*
     * This is the definition for our AppDelegate. Typhoon will inject the specified properties
     * at application startup.
     */
    public dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            
            let services : [UIApplicationDelegate] =
            [
                RootService(),
                GoogleAnalyticsService(),
                FirebaseService(),
                FirebaseNotificationService(),
                StoryKitService()
            ]
            definition.injectProperty("serviceDispatcher", with: AppDelegateServiceDispatcher(services: services))
            definition.injectProperty("appAssembly", with: self)
        }
    }
    
    /*
     * A config definition, referencing properties that will be loaded from a plist.
     */
    public dynamic func config() -> AnyObject {
        
        return TyphoonDefinition.withConfigName("Configuration.plist")
    }
    
    public dynamic func storyboard() -> AnyObject {
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
    
    public dynamic func dataModel() -> AnyObject {
        return TyphoonDefinition.withClass(CGDataModelJSON.self) {
            (definition) in
            definition.useInitializer("initWithMainFileName:") {
                (initializer) in
                initializer.injectParameterWith( String("mums") )
            }
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    public dynamic func analyticsTracker() -> AnyObject {
        return TyphoonDefinition.withClass(CGAnalyticsTracker.self)
    }
    
    public dynamic func mainScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGMainScreenViewController.self) {
            (definition) in
            
            definition.injectProperty("dataModel", with: self.dataModel())
            definition.injectProperty("tracker", with: self.analyticsTracker())
            definition.injectProperty("mainScreenDDM", with: self.mainScreenDDM())
            definition.injectProperty("userDefaults", with: NSUserDefaults.standardUserDefaults() )
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    public dynamic func mainScreenDDM() -> AnyObject {
        return TyphoonDefinition.withClass(CGMainScreenDDM.self) {
            (definition) in
            
            definition.useInitializer("initWithMainScreenDelegate:dataModel:") {
                (initializer) in
                
                initializer.injectParameterWith( self.mainScreenViewController() )
                initializer.injectParameterWith( self.dataModel() )
            }
        }
    }
    
    public dynamic func gamesScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGGamesScreenViewController.self) {
            (definition) in
            
            definition.injectProperty("dataModel", with: self.dataModel())
            definition.injectProperty("tracker", with: self.analyticsTracker())
            definition.injectProperty("assembly", with: self)
            
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    public dynamic func gamesScreenDDM(groupIdNumber: NSNumber) -> AnyObject {
        return TyphoonDefinition.withClass(CGGamesScreenDDM.self) {
            (definition) in
            
            definition.useInitializer("initWithDelegate:dataModel:groupIdNumber:") {
                (initializer) in
                
                initializer.injectParameterWith( self.gamesScreenViewController() )
                initializer.injectParameterWith( self.dataModel() )
                initializer.injectParameterWith( groupIdNumber )
            }
        }
    }
    
    public dynamic func contentScreenViewController() -> AnyObject {
        return TyphoonDefinition.withClass(CGContentScreenViewController.self) {
            (definition) in

            definition.injectProperty("tracker", with: self.analyticsTracker())
            definition.injectProperty("dataModel", with: self.dataModel())
        
            definition.scope = TyphoonScope.Singleton
        }
    }
}