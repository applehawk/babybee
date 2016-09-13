//
//  DataModel.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

public class CGGroupsCatalogModel : NSObject {
    let mainTitle : String
    let groupsCount : Int
    var groupsCatalog = [CGGroupModel]()
    
    func parseGroupOfJSON( object : AnyObject? ) {
        if let groupDict = object as? NSDictionary {
            if let groupModel = CGGroupModel(dict: groupDict) {
                groupsCatalog.append(groupModel)
            }
        }
    }
    
    init?(dict: NSDictionary)
    {
        if let mainTitle = dict["mainTitle"] as? String {
            self.mainTitle = mainTitle;
        } else {
            return nil
        }
        if let count = dict["groupsCount"] as? Int {
            self.groupsCount = count
        } else {
            return nil
        }
        
        super.init()
        if let groupsArray = dict["groups"] as? NSArray {
            for group in groupsArray {
                self.parseGroupOfJSON(group)
            }
        } else {
            return nil
        }
    }
}

public class CGGameModel : NSObject {
    init?(dict : NSDictionary) {
        if let nameGame = dict["nameGame"] as? String {
            self.nameGame = nameGame;
        } else {
            return nil
        }
        if let content = dict["content"] as? String {
            self.htmlContent = content
        } else {
            return nil
        }
    }
    let nameGame : String
    let htmlContent : String
}

public class CGGroupModel : NSObject {
    init?(dict : NSDictionary) {
        if let headerPictureFileName = dict["headerPicture"] as? String {
            self.headerPictureFileName = headerPictureFileName
        } else {
            return nil
        }
        if let file = dict["file"] as? String {
            self.filenameOfGroup = file
        } else {
            return nil
        }
        if let groupName = dict["groupName"] as? String {
            self.groupName = groupName
        } else {
            return nil
        }
        if let minAgeOfMonth = dict["minAgeOfMonth"] as? Int {
            self.minAgeOfMonth = minAgeOfMonth
        } else {
            return nil
        }
        if let maxAgeOfMonth = dict["maxAgeOfMonth"] as? Int {
            self.maxAgeOfMonth = maxAgeOfMonth
        } else {
            return nil
        }
    }
    let headerPictureFileName : String
    let filenameOfGroup : String
    let groupName : String
    let minAgeOfMonth : Int
    let maxAgeOfMonth : Int
}