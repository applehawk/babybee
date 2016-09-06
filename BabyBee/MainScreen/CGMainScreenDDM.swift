//
//  CGMainScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 02.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGMainScreenDDM : NSObject, UITableViewDataSource, UITableViewDelegate {
    var dataModel : CGDataModelProtocol?
    var groupsCatalog : CGGroupsCatalogModel?
    
    let specialCellsOnFooter = 0;
    
    init(dataModel : CGDataModelProtocol?) {
        super.init()
        
        self.dataModel = dataModel
        self.groupsCatalog = dataModel?.groupsCatalogModel()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView,
                                         title:resultBirthDayStr,
                                         headerImageName: "bg_mainScreen")
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == CGMainScreenTableSections.MainSection.rawValue ) {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView
            {
                
                self.configureHeaderView(headerView,
                                         title:resultBirthDayStr,
                                         headerImageName: "bg_mainScreen")
                
                headerView.setNeedsUpdateConstraints()
                headerView.updateConstraints()
                
                headerView.setNeedsLayout()
                headerView.layoutIfNeeded()
                
                let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                return height.height
            }
        }
        return 0.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groupsCatalog = groupsCatalog {
            return groupsCatalog.groupsCount + specialCellsOnFooter;
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        if let groupsCatalog = groupsCatalog {
            if indexPath.row < groupsCatalog.groupsCatalog.count {
                let mainCell = tableView.dequeueReusableCellWithIdentifier(String(CGMainScreenCell), forIndexPath: indexPath) as! CGMainScreenCell
                
                let catalog = groupsCatalog.groupsCatalog[indexPath.row]
                mainCell.cellTitleLabel.text = catalog.groupName
                cell = mainCell
            } else {
                //let specialRow = indexPath.row - groupsCatalog.groupsCatalog.count
                
                let specialCell = tableView.dequeueReusableCellWithIdentifier(String(CGAboutUsCell), forIndexPath: indexPath) as! CGAboutUsCell
                
                cell = specialCell
            }
        }
        return cell
    }
}
