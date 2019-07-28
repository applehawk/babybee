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
    
    enum CatalogServiceError: Error, CustomStringConvertible {
        case SerializationProblem(error: String)
        
        var description: String {
            switch self {
            case .SerializationProblem(let error):
                return "SerializationProblem \(error)"
            }
        }
    }
    // MARK: Helper Method
    func serializationJSONDataToCatalog(_ data: Data) -> CGCatalogModel? {
        do {
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] else {
                throw CatalogServiceError.SerializationProblem(error: "")
                return nil
            }
            let catalog = CGCatalogModel(JSON: jsonResult)
            return catalog
        } catch {
            print(error)
        }
        return nil
    }
    
    func updateCatalog( completionHandler:((_ error: NSError?) -> Void)? ) {
        if let request = fabricRequest.requestWithCatalog() {
            
            print(request.url?.absoluteString)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse,
                    let receivedData = data
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
                        completionHandler?(nil)
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
    
    func updateContentData(_ contentUrl: String, completionHandler: (() -> Void)? ) {
        if let content = self.obtainContentData(contentUrl) {
            completionHandler?()
        } else if let request = fabricRequest.request(with: contentUrl) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse,
                    let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                
                
                switch (httpResponse.statusCode) {
                case 200:
                    
                    if let stringContent = String(data: receivedData, encoding: .utf8) {
                        let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
                        self.localStorage.saveObject(stringContent, name: key)
                    }
                    completionHandler?()
                default:
                    print("GET request got response \(httpResponse.statusCode)")
                }
                
            })
            
            dataTask.resume()
        }
        /*
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
        }*/
    }
    
    func obtainContentData(_ contentUrl: String ) -> String? {
        let key = String("\(CGLocalStorageContentKey)_\(contentUrl)")
        return self.localStorage.loadObject(key) as? String
    }
}
