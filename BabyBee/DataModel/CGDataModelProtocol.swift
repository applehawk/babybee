//
//  CGDataModelProtocol.swift
//  ChildGames
//
//  Created by v.vasilenko on 28.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation


@objc public protocol CGDataModelProtocol {
    func readJSONDictWithPath( path: String ) -> NSDictionary?
    
    func groupsCatalogModel() -> CGGroupsCatalogModel?
    func groupModelWithId(idGroup: Int) -> CGGroupModel?
    func gamesListWithGroupId(idGroup: Int) -> [CGGameModel]?
    func gameModelWithGroupIdAndGameId(idGroup: Int, idGame: Int) -> CGGameModel?
}