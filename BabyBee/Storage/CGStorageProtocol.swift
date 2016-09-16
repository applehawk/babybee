//
//  StorageProtocol.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol CGStorageProtocol {
    func saveObject( object: AnyObject, name : String)
    func loadObject( name: String) -> AnyObject?
}