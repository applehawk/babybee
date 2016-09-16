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
    var title : String?
    var pictureUrl : String?
    var groups : [CGGroupModel]?
    var games : [String: CGContentModel]?
    //var groups_ids : [Int]?
    //Downloadable content
    var pictureImage: UIImage?
    
    required init?(_ map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        title       <- map["title"]
        groups      <- map["groups"]
        games       <- map["games"]
        pictureUrl <- map["pictureUrl"]
    }
}