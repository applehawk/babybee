//
//  CGGamesScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 06.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

@objc protocol CGGamesScreenProtocol {
    func didSelectedGame(gameName: String, gameId : Int);
}

class CGGamesScreenDDM : NSObject, UITableViewDelegate, UITableViewDataSource {
    var delegate : CGGamesScreenProtocol
    var group : CGGroupModel
    
    init(delegate : CGGamesScreenProtocol, group : CGGroupModel) {
        self.delegate = delegate
        self.group = group
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contentList = group.contentList {
            return contentList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CGGamesScreenCell", forIndexPath: indexPath) as! CGGamesScreenCell
        
        if let content = group.contentList?[indexPath.row] {
            cell.configureForContent( content )
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let contentModel = group.contentList?[indexPath.row] {
            delegate.didSelectedGame(contentModel.name, gameId: indexPath.row)
        } else {
            delegate.didSelectedGame("Ошибка получения данных игры \(indexPath.row)", gameId: indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0;
    }
    
    func configureHeaderView( headerView : CGHeaderView, title: String, headerImageName: String) {
        headerView.headerImage.image = UIImage(named: headerImageName)
        headerView.headerSubtitle.text = title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
    
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle,
                                         headerImageName: group.headerPicture)
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == CGMainScreenTableSections.MainSection.rawValue ) {
            
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle,
                                         headerImageName: group.headerPicture)
                
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