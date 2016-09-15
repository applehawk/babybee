//
//  CGCatalogModel.swift
//  BabyBee
//
//  Created by Hawk on 14/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import ObjectMapper

class CGCatalogModel : NSObject, Mappable {
    var title : String!
    var count : Int!
    var groups : [CGGroupModel]?
    
    required init?(_ map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        title       <- map["title"]
        count       <- map["count"]
        groups      <- map["groups"]
    }
}