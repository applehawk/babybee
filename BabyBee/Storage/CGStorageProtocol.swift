//
//  StorageProtocol.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol CGStorageProtocol {
    func saveObject(_ object: Any, name : String)
    func loadObject(_ name: String) -> Any?
}
