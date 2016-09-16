//
//  DataModelJSONAdapter.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

let CGLocalJSONFileName = "content"
let CGLocalStorageCatalogModelKey = "catalogKey"
let CGLocalStorageContentKey = "contentKey"

class CGCatalogServiceLocal: NSObject, CGCatalogServiceProtocol {
    var localStorage: CGStorageProtocol!
    var fabricRequest: CGFabricRequestProtocol!
    var imageService: CGImageService!
    
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
    
    func updateCatalog( completionHandler:((error:NSError?) -> Void)? ) {
        if let jsonDict = readJSONDictWithPath(CGLocalJSONFileName) {
            guard
                let catalogDict = jsonDict as? [String:AnyObject],
                let catalogModel = CGCatalogModel(JSON: catalogDict) else {
                return
            }
            imageService.downloadImage(catalogModel.pictureUrl,
                                       completionHandler: { (image) in
                catalogModel.pictureImage = image
            })
            self.localStorage.saveObject(catalogModel, name: CGLocalStorageCatalogModelKey)
            completionHandler?(error: nil)
        } else {
            print("File isn't readable! Check file: \(CGLocalJSONFileName)")
        }
    }
    
    func obtainCatalog() -> CGCatalogModel? {
        let catalogModel = localStorage.loadObject(CGLocalStorageCatalogModelKey)
        return catalogModel as? CGCatalogModel
    }
    
    func updateContentData( contentUrl: String, completionHandler:() -> Void ) {
        if let content = self.obtainContentData(contentUrl) {
            completionHandler()
        } else {
            do {
                let path = NSBundle.mainBundle().pathForResource(contentUrl, ofType: nil)
                let stringContent = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
                let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
                self.localStorage.saveObject(stringContent, name: key)
                completionHandler()
            } catch {
                print(error)
            }
        }
    }
    
    func obtainContentData( contentUrl: String ) -> String? {
        let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
        return self.localStorage.loadObject(key) as? String
    }
}