//
//  CGFabricRequest.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol CGFabricRequestProtocol {
    func requestWithContentName( contentUrl: String ) -> NSURLRequest?
    func requestWithCatalog() -> NSURLRequest?
}