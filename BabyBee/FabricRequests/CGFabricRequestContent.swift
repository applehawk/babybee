//
//  CGFabricRequestContent.swift
//  BabyBee
//
//  Created by Hawk on 15/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGFabricRequestContent: NSObject, CGFabricRequestProtocol {
    
    func request(with contentUrl: String ) -> URLRequest? {
        if let defaultHostUrl = Bundle.main.infoDictionary?["RemoteHost"] as? String {
            print("\(defaultHostUrl)")
            
            let urlComponents = NSURLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = defaultHostUrl
            urlComponents.path = "/\(contentUrl)"
            
            if let url = urlComponents.url(relativeTo: nil) {
                return URLRequest(url: url)
            }
        }
        
        return nil
    }
    
    func requestWithCatalog() -> URLRequest? {
        if let defaultHostUrl = Bundle.main.infoDictionary?["RemoteRestHost"] as? String {
            print("\(defaultHostUrl)")
            
            
            let urlComponents = NSURLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = defaultHostUrl
            urlComponents.path = "/catalog.json?auth=16WSBrMaTx5CFgBskcgjCg1UntBbzrbvM5cRr8uV"
            
            if let url = urlComponents.url(relativeTo: nil) {
                return URLRequest(url: url)
            }
        }
        
        return nil
    }
}
