//
//  CGMainScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 02.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGHeaderImageFileName = "bg_mainScreen"

enum CGMainScreenTableSections : Int {
    case MainSection = 0
}

@objc protocol CGMainScreenDDMProtocol : UITableViewDataSource, UITableViewDelegate {
    init?(delegate: CGMainScreenDelegate, catalog:CGCatalogModel)
}

class CGMainScreenDDM : NSObject, CGMainScreenDDMProtocol {
    var catalog : CGCatalogModel?
    var mainScreenDelegate: CGMainScreenDelegate
    
    let specialCellsOnFooter = 0
    
    required init?(delegate: CGMainScreenDelegate, catalog:CGCatalogModel) {
        self.mainScreenDelegate = delegate;
        self.catalog = catalog
        
        super.init()
    }
    
    func configureHeaderView( headerView : CGHeaderView, title: String, pictureImage: UIImage?) {
        headerView.headerImage.image = pictureImage
        headerView.headerSubtitle.text = title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView,
                                         title:mainScreenDelegate.birthdayString(),
                                         pictureImage: catalog?.pictureImage)
                
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
                                         pictureImage: catalog?.pictureImage)
                
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
        var groupName = "Ошибка загрузки группы"
        
        if let groupModel = catalog?.groups?[indexPath.row] {
            groupName = groupModel.groupName
        }
        mainScreenDelegate.didSelectedGroup(groupName, selectedRow: indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = catalog?.groups?.count {
            return count + specialCellsOnFooter
        } else {
            return specialCellsOnFooter
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let group = catalog?.groups?[indexPath.row] where indexPath.row < catalog?.groups?.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(CGMainScreenCell), forIndexPath: indexPath) as! CGMainScreenCell
            cell.configureForGroup(group)
            return cell
        }
        return UITableViewCell()
    }
}
