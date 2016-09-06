//
//  CGMainScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 02.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGHeaderImageFileName = "bg_mainScreen"

protocol CGMainScreenProtocol {
    func birthdayString() -> String;
    func trackActionSelectGroup(groupName : String, selectedRow: Int);
}

class CGMainScreenDDM : NSObject, UITableViewDataSource, UITableViewDelegate {
    var dataModel : CGDataModelProtocol
    var mainScreenDelegate: CGMainScreenProtocol
    
    var groupsCatalog : CGGroupsCatalogModel?
    
    var selectedIndexRow : Int = 0
    let specialCellsOnFooter = 0
    
    init(mainScreenDelegate: CGMainScreenProtocol, dataModel : CGDataModelProtocol) {
        self.selectedIndexRow = 0
        
        self.mainScreenDelegate = mainScreenDelegate;
        self.dataModel = dataModel
        self.groupsCatalog = dataModel.groupsCatalogModel()
        
        super.init()
    }
    
    func configureHeaderView( headerView : CGHeaderView, title: String, headerImageName: String) {
        headerView.headerImage.image = UIImage(named: headerImageName)
        headerView.headerSubtitle.text = title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView,
                                         title:mainScreenDelegate.birthdayString(),
                                         headerImageName: CGHeaderImageFileName)
                
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
                                         title:mainScreenDelegate.birthdayString(),
                                         headerImageName: CGHeaderImageFileName)
                
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexRow = indexPath.row
        
        var groupName = ""
        if let groupModel = dataModel.groupModelWithId(self.selectedIndexRow) {
            groupName = groupModel.groupName
        } else {
            groupName = "Ошибка загрузки группы"
        }
        mainScreenDelegate.trackActionSelectGroup(groupName, selectedRow: indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groupsCatalog = groupsCatalog {
            return groupsCatalog.groupsCount + specialCellsOnFooter;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let groupModel = groupsCatalog?.groupsCatalog[indexPath.row] where indexPath.row < groupsCatalog?.groupsCatalog.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(CGMainScreenCell), forIndexPath: indexPath) as! CGMainScreenCell
            cell.configureForGroup(groupModel)
            return cell
        }
        return UITableViewCell()
    }
}
