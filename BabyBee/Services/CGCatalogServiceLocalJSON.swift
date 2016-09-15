//
//  DataModelJSONAdapter.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

let dataJSONFilename = "content.json"

class CGCatalogServiceLocalJSON: NSObject, CGCatalogServiceProtocol {
    var catalogModel : CGCatalogModel?
    
    func readJSONDictWithPath(path : String) -> [String: AnyObject]? {
        do {
            if let resourcePath = NSBundle.mainBundle().pathForResource(path, ofType: "json"),
                let data = NSData(contentsOfFile: resourcePath)
            {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers]) as? [String: AnyObject]
                return jsonResult
            }
        } catch {
            print(error);
        }
        return nil
    }
    
    func updateData( completionHandler:() -> Void ) {
        if let jsonDict = readJSONDictWithPath("mums") {
            self.catalogModel = CGCatalogModel(JSON: jsonDict)
        }
        completionHandler()
    }
    
    func obtainCatalogModel() -> CGCatalogModel? {
        return self.catalogModel
    }
}