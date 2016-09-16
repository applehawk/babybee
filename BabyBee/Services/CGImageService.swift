//
//  CGImageService.swift
//  BabyBee
//
//  Created by Hawk on 16/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGImageService : NSObject {
    var fabricRequest : CGFabricRequestProtocol!
    
    func downloadImage( pictureUrl: String?, completionHandler:(image:UIImage?)->Void) {
        if let pictureUrl = pictureUrl, let imageRequest = fabricRequest.requestWithContentName(pictureUrl) {
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(imageRequest, completionHandler: { (data, response, error) in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                switch (httpResponse.statusCode) {
                case 200:
                
                    completionHandler(image: UIImage(data: receivedData) )
                default:
                    print("GET request got response \(httpResponse.statusCode)")
                }
            })
            dataTask.resume()
        }
    }
}