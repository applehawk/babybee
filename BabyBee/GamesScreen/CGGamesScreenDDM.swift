//
//  CGGamesScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 06.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

protocol CGGamesScreenProtocol {
    func trackSelectGame(gameName: String, gameId : Int);
}

class CGGamesScreenDDM : NSObject, UITableViewDelegate, UITableViewDataSource {
    var dataModel : CGDataModelProtocol
    
    var selectedGroupId : Int = 0
    var groupModel : CGGroupModel?
    var gamesModelList : [CGGameModel]?
    
    var delegate : CGGamesScreenProtocol!
    
    init(delegate : CGGamesScreenProtocol, dataModel : CGDataModelProtocol, groupId: Int) {
        self.delegate = delegate
        self.selectedGroupId = groupId
        self.dataModel = dataModel
        self.groupModel = dataModel.groupModelWithId(groupId)
        self.gamesModelList = dataModel.gamesListWithGroupId(groupId)
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gamesModelList = gamesModelList {
            return gamesModelList.count;
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CGGamesScreenCell", forIndexPath: indexPath) as! CGGamesScreenCell
        
        if let gameModel = gamesModelList?[indexPath.row] {
            cell.configureForGroup( gameModel )
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let gameModel = dataModel.gameModelWithGroupIdAndGameId(self.selectedGroupId, idGame: indexPath.row)
        
        if let gameModel : CGGameModel = gameModel {
            delegate.trackSelectGame(gameModel.nameGame, gameId: indexPath.row)
        } else {
            delegate.trackSelectGame("Ошибка получения данных игры \(indexPath.row)", gameId: indexPath.row)
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
                
                var headerImageName = "headerScreen2"
                if (selectedGroupId == 0) {
                    headerImageName = "headerScreen0"
                }
                if (selectedGroupId == 1) {
                    headerImageName = "headerScreen3"
                }
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle, headerImageName: headerImageName)
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == CGMainScreenTableSections.MainSection.rawValue ) {
            
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle, headerImageName: "headerScreen0")
                
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