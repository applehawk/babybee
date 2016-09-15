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
    
    var contentList : [CGContentModel]?
    var headerPicture : String!
    var groupName : String!
    var minAgeOfMonth : Int!
    var maxAgeOfMonth : Int!
    
    required init?(_ map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        contentList  <- map["contentList"]
        headerPicture   <- map["headerPicture"]
        groupName       <- map["groupName"]
        maxAgeOfMonth   <- map["maxAgeOfMonth"]
        minAgeOfMonth   <- map["minAgeOfMonth"]
    }
}