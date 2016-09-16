//
//  CGFabricRequestContent.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGFabricRequestContent: NSObject, CGFabricRequestProtocol {
    
    func requestWithContentName( contentUrl: String ) -> NSURLRequest? {
        if let defaultHostUrl = NSBundle.mainBundle().infoDictionary?["RemoteHost"] as? String {
            print("\(defaultHostUrl)")
            
            if let url = NSURL(scheme: "https", host: defaultHostUrl, path: "/\(contentUrl)") {
                return NSURLRequest(URL: url)
            }
        }
        
        return nil
    }
    
    func requestWithCatalog() -> NSURLRequest? {
        if let defaultHostUrl = NSBundle.mainBundle().infoDictionary?["RemoteRestHost"] as? String {
            print("\(defaultHostUrl)")
            
            if let url = NSURL(scheme: "https", host: defaultHostUrl, path: "/catalog.json?auth=16WSBrMaTx5CFgBskcgjCg1UntBbzrbvM5cRr8uV") {
                
                
                return NSURLRequest(URL: url)
            }
        }
        
        return nil
    }
}