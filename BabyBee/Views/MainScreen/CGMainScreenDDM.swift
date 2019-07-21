//
//  CGMainScreenDDM.swift
//  BabyBee
//
//  Created by v.vasilenko on 02.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGHeaderImageFileName = "bg_mainScreen"

enum CGMainScreenTableSections: Int {
    case MainSection = 0
}

@objc protocol CGMainScreenDDMProtocol : UITableViewDataSource, UITableViewDelegate {
    init(delegate: CGMainScreenDelegate, catalog:CGCatalogModel)
}

class CGMainScreenDDM : NSObject, CGMainScreenDDMProtocol {
    var catalog : CGCatalogModel?
    var mainScreenDelegate: CGMainScreenDelegate
    
    let specialCellsOnFooter = 0
    
    required init(delegate: CGMainScreenDelegate, catalog: CGCatalogModel) {
        self.mainScreenDelegate = delegate;
        self.catalog = catalog
        
        super.init()
    }
    
    func configureHeaderView(_ headerView : CGHeaderView, title: String, pictureImage: UIImage?) {
        headerView.headerImage.image = pictureImage
        headerView.headerSubtitle.text = title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch CGMainScreenTableSections(rawValue: section)! {
        case .MainSection:
            let headerView = CGHeaderView.dequeueReusableHeaderFooterView(in: tableView)
            
            let title = mainScreenDelegate.birthdayString()
            let pictureImage = catalog?.pictureImage
            headerView.configureHeaderView(title, pictureImage: pictureImage)
            
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch CGMainScreenTableSections(rawValue: section)! {
        case .MainSection:
            let title = mainScreenDelegate.birthdayString()
            let pictureImage = catalog?.pictureImage
            
            let headerView = CGHeaderView.dequeueReusableHeaderFooterView(in: tableView)
            headerView.configureHeaderView(title, pictureImage: pictureImage)
            headerView.setNeedsUpdateConstraints()
            headerView.updateConstraints()
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return height.height
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var groupName = "Ошибка загрузки группы"
        if let groupModel = group(for: indexPath) {
            groupName = groupModel.groupName
        }
        mainScreenDelegate.didSelectedGroup(groupName, selectedRow: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = catalog?.groups?.count {
            return count + specialCellsOnFooter
        } else {
            return specialCellsOnFooter
        }
    }
    
    func group(for indexPath: IndexPath) -> CGGroupModel? {
        return catalog?.groups?[indexPath.row]
    }
    
    var countOfGroups: Int {
        guard let groups = catalog?.groups else {
            return 0
        }
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let group = group(for: indexPath),
            indexPath.row < countOfGroups {
            
            let cell = CGMainScreenCell.dequeueReusableCell(in: tableView, forIndexPath: indexPath)
            cell.configureForGroup(group)
            
            return cell
        }
        return UITableViewCell()
    }
}
