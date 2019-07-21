//
//  CGGamesScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 06.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

@objc protocol CGGamesScreenProtocol {
    func didSelectedGame(_ gameName: String, gameId : String);
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if let contentList = group.contentList {
            return contentList.count
        }*/
        if let games_ids = group.games_ids {
            return games_ids.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CGGamesScreenCell.dequeueReusableCell(in: tableView, forIndexPath: indexPath)
        
        guard let game_id = group.games_ids?[ indexPath.row ] else {
            return UITableViewCell()
        }
        if let content = catalog.games?[game_id] {
            cell.configureCell(with: content)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game_id = group.games_ids?[ indexPath.row ] else {
            return
        }
        if let content = catalog.games?[game_id] {
            delegate.didSelectedGame(content.name, gameId: game_id)
        } else {
            delegate.didSelectedGame("Ошибка получения данных игры \(indexPath.row)", gameId: game_id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch CGMainScreenTableSections(rawValue: section) {
        case .MainSection?:
            
            let headerView = CGHeaderView.dequeueReusableHeaderFooterView(in: tableView)
            headerView.configureHeaderView(self.catalog)
            
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch CGMainScreenTableSections(rawValue: section) {
        case .MainSection?:
            
            let headerView = CGHeaderView.dequeueReusableHeaderFooterView(in: tableView)
            headerView.configureHeaderView(self.catalog)
            
            headerView.layoutIfNeeded()
            headerView.layoutSubviews()
            
            let height = headerView.headerImageHeightConstraint.constant + headerView.headerSubtitle.frame.height
            
            return height
        default:
            return 250.0
        }
    }
}
