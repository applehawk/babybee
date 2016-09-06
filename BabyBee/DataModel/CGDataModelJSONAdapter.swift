//
//  DataModelJSONAdapter.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGDataModelJSONAdapter: NSObject, CGDataModelProtocol {
    var rootDict : NSDictionary?
    var catalogModel : CGGroupsCatalogModel?
    
    func readJSONDictWithPath( path : String) -> NSDictionary? {
        do {
            if let resourcePath = NSBundle.mainBundle().pathForResource(path, ofType: "json"),
                let data = NSData(contentsOfFile: resourcePath)
            {
                let jsonResult : NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers]) as? NSDictionary
                return jsonResult
            }
        } catch {
            print(error);
        }
        return nil
    }
    
    func readJSONArrayWithPath( path: String) -> NSArray? {
        do {
            if let resourcePath = NSBundle.mainBundle().pathForResource(path, ofType: "json"),
                let data = NSData(contentsOfFile: resourcePath)
            {
                let jsonResult : NSArray? = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers]) as? NSArray
                return jsonResult
            }
        } catch {
            print(error);
        }
        return nil
    }
    
    init(mainFileName : String) {
        super.init()
        self.rootDict = readJSONDictWithPath(mainFileName)
    }
    
    func groupsCatalogModel() -> CGGroupsCatalogModel?
    {
        if catalogModel == nil {
            if let rootDict = rootDict {
                self.catalogModel = CGGroupsCatalogModel(dict: rootDict)
                return self.catalogModel
            }
        }
        return self.catalogModel
    }
    
    func gameModelWithGroupIdAndGameId(idGroup: Int, idGame: Int) -> CGGameModel?
    {
        if let gamesList = gamesListWithGroupId(idGroup) {
            return gamesList[idGame]
        } else {
            return nil
        }
    }
    
    func groupModelWithId(idGroup: Int) -> CGGroupModel?
    {
        if let catalogModel = self.catalogModel {
            if catalogModel.groupsCatalog.count > idGroup {
                return catalogModel.groupsCatalog[idGroup]
            }
        }
        return nil
    }
    func gamesListWithGroupId(idGroup: Int) -> [CGGameModel]?
    {
        let groupModel = groupModelWithId(idGroup)
        var gamesArrayModel : [CGGameModel]? = [CGGameModel]()
        if let fileNameOfGroup = groupModel?.filenameOfGroup, gamesArrayRaw = readJSONArrayWithPath(fileNameOfGroup)
        {
            for gameJSONDict in gamesArrayRaw {
                if let gameJSONDict = gameJSONDict as? NSDictionary {
                    if let gameModel = CGGameModel(dict: gameJSONDict) {
                        gamesArrayModel?.append(gameModel)
                    }
                }
            }
        }
        return gamesArrayModel
    }
}