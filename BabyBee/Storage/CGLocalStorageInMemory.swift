//
//  LocalStorage.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGLocalStorageInMemory : NSObject, CGStorageProtocol {
    
    var memory : [String: AnyObject] = [:]
    
    func saveObject( object: AnyObject, name : String) {
        memory[name] = object
    }
    func loadObject( name: String) -> AnyObject? {
        return memory[name]
    }
}