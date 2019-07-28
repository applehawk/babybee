//
//  CGCatalogServiceProtocol.swift
//  ChildGames
//
//  Created by v.vasilenko on 28.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

@objc protocol CGCatalogServiceProtocol {
    func updateCatalog( completionHandler: ((_ error: NSError?) -> Void )? )
    func obtainCatalog() -> CGCatalogModel?
    
    func updateContentData(_ contentUrl: String, completionHandler:(() -> Void)? )
    func obtainContentData(_ contentUrl: String ) -> String?
}
