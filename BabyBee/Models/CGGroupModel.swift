//
//  CGGroupModel.swift
//  BabyBee
//
//  Created by Hawk on 14/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import ObjectMapper

class CGGroupModel : NSObject, Mappable {
    
    var games_ids : [String]?
    //var content_ids : [Int]?
    var pictureUrl : String!
    var groupName : String!
    var minMonth : Int!
    var maxMonth : Int!
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        games_ids  <- map["games_ids"]
        pictureUrl   <- map["pictureUrl"]
        groupName       <- map["name"]
        maxMonth   <- map["maxMonth"]
        minMonth   <- map["minMonth"]
    }
}
