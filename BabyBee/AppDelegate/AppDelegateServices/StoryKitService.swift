//
//  StoryKitService.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class StoryKitService: NSObject, UIApplicationDelegate {
    
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        SwiftyStoreKit.completeTransactions() { completedTransactions in
            /*
            for completedTransaction in completedTransactions {
                if completedTransaction.transactionState == .purchased || completedTransaction.transactionState == .restored {
                    print("purchased: \(completedTransaction.productId)")
                }
            }*/
        }
        return true;
    }
}
