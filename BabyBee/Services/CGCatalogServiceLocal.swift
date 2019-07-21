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
    
    func readJSONDictWithPath(_ path: String) -> Any? {
        do {
            if let resourcePath = Bundle.main.path(forResource: path, ofType: "json")
            {
                let fileUrl = URL(fileURLWithPath: resourcePath)
                let data = try Data(contentsOf: fileUrl)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                
                return jsonResult
            }
        } catch {
            print(error);
        }
        return nil
    }
    
    func updateCatalog( completionHandler:((_ error: NSError?) -> Void)? ) {
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
            completionHandler?(nil)
        } else {
            print("File isn't readable! Check file: \(CGLocalJSONFileName)")
        }
    }
    
    func obtainCatalog() -> CGCatalogModel? {
        let catalogModel = localStorage.loadObject(CGLocalStorageCatalogModelKey)
        return catalogModel as? CGCatalogModel
    }
    
    func updateContentData(_ contentUrl: String, completionHandler:() -> Void ) {
        if let content = self.obtainContentData(contentUrl) {
            completionHandler()
        } else {
            do {
                let path = Bundle.main.path(forResource: contentUrl, ofType: nil)
                let stringContent = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
                self.localStorage.saveObject(stringContent, name: key)
                completionHandler()
            } catch {
                print(error)
            }
        }
    }
    
    func obtainContentData(_ contentUrl: String ) -> String? {
        let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
        return self.localStorage.loadObject(key) as? String
    }
}
