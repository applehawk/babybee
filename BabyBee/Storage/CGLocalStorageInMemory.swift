//
//  LocalStorage.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGLocalStorageInMemory : NSObject, CGStorageProtocol {
    
    var memory : [String: Any] = [:]
    
    func saveObject(_ object: Any, name : String) {
        memory[name] = object
    }
    func loadObject(_ name: String) -> Any? {
        return memory[name]
    }
}
