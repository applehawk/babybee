//
//  CGGamesScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 06.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

@objc protocol CGGamesScreenProtocol {
    func didSelectedGame(gameName: String, gameId : String);
}

@objc protocol CGGamesScreenDDMProtocol : UITableViewDelegate, UITableViewDataSource {
}

class CGGamesScreenDDM : NSObject, CGGamesScreenDDMProtocol {
    var delegate : CGGamesScreenProtocol
    var catalog : CGCatalogModel
    var group : CGGroupModel
    
    init(delegate : CGGamesScreenProtocol, catalog: CGCatalogModel, group: CGGroupModel) {
        self.delegate = delegate
        self.group = group
        self.catalog = catalog
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if let contentList = group.contentList {
            return contentList.count
        }*/
        if let games_ids = group.games_ids {
            return games_ids.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CGGamesScreenCell", forIndexPath: indexPath) as! CGGamesScreenCell
        
        guard let game_id = group.games_ids?[ indexPath.row ] else {
            return UITableViewCell()
        }
        if let content = catalog.games?[game_id] {
            cell.configureForContent( content )
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let game_id = group.games_ids?[ indexPath.row ] else {
            return
        }
        if let content = catalog.games?[game_id] {
            delegate.didSelectedGame(content.name, gameId: game_id)
        } else {
            delegate.didSelectedGame("Ошибка получения данных игры \(indexPath.row)", gameId: game_id)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0;
    }
    
    func configureHeaderView( headerView : CGHeaderView ) {
        headerView.headerImage.image = catalog.pictureImage
        headerView.headerSubtitle.text = catalog.title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
    
                self.configureHeaderView(headerView)
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == CGMainScreenTableSections.MainSection.rawValue ) {
            
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView)
                
                headerView.layoutIfNeeded()
                headerView.layoutSubviews()
                
                let height = headerView.headerImageHeightConstraint.constant + headerView.headerSubtitle.frame.height
                
                return height
            } else {
                return 250.0
            }
        }
        return 0.0
    }
}