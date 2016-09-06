//
//  AppGoogleSignInDelegate.swift
//  BabyBee
//
//  Created by Hawk on 07/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class AppGoogleSignInDelegate : NSObject, GIDSignInDelegate {
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}