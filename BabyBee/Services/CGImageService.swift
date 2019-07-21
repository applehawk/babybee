//
//  CGImageService.swift
//  BabyBee
//
//  Created by Hawk on 16/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

typealias CompletionImageDownloaded = (_ image: UIImage?) -> Void

class CGImageService : NSObject {
    var fabricRequest : CGFabricRequestProtocol!
    
    func downloadImage(_ pictureUrl: String?, completionHandler: @escaping CompletionImageDownloaded) {
        if let pictureUrl = pictureUrl, let imageRequest = fabricRequest.request(with: pictureUrl) {
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: imageRequest, completionHandler: { (data, response, error) in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse,
                    let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                switch (httpResponse.statusCode) {
                case 200:
                
                    completionHandler(UIImage(data: receivedData))
                default:
                    print("GET request got response \(httpResponse.statusCode)")
                }
            })
            dataTask.resume()
        }
    }
}
