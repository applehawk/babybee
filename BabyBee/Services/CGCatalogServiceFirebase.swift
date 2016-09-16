//
//  CGDataModelFirebaseDatabase.swift
//  BabyBee
//
//  Created by Hawk on 14/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation
import Firebase

class CGCatalogServiceFirebase: NSObject, CGCatalogServiceProtocol {
    var localStorage : CGStorageProtocol!
    var fabricRequest : CGFabricRequestProtocol!
    var imageService : CGImageService!
    
    enum Errors : ErrorType {
        case SerializationProblem
    }
    // MARK: Helper Method
    func serializationJSONDataToCatalog(data: NSData) -> CGCatalogModel? {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options:[NSJSONReadingOptions.MutableContainers]) as? [String: AnyObject]
            if let jsonResult = jsonResult, let catalog = CGCatalogModel(JSON: jsonResult) {
                return catalog
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func updateCatalog( completionHandler:((error:NSError?) -> Void)? ) {
        if let request = fabricRequest.requestWithCatalog() {
            
            print(request.URL?.absoluteURL)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                switch (httpResponse.statusCode) {
                case 200:
                    if let catalog = self.serializationJSONDataToCatalog(receivedData) {
                        self.imageService.downloadImage(catalog.pictureUrl, completionHandler: { (image) in
                            catalog.pictureImage = image
                        })
                        self.localStorage.saveObject(catalog, name: CGLocalStorageCatalogModelKey)
                        completionHandler?(error: nil)
                    }
                default:
                    print("GET request got response \(httpResponse.statusCode)")
                }
            })
            
            dataTask.resume()
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