//
//  CGMainScreenCell.swift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

class CGMainScreenCell: UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    func configureForGroup(_ groupModel : CGGroupModel ) {
        self.cellTitleLabel.text = groupModel.groupName
    }
}

extension CGMainScreenCell {
    static func registerNib(in tableView: UITableView) -> UINib {
        let nibMainScreenCell = UINib(nibName: "CGMainScreenCell", bundle: nil)
        tableView.register(nibMainScreenCell, forCellReuseIdentifier: "mainScreenCell")
        return nibMainScreenCell
    }
    static func dequeueReusableCell(in tableView: UITableView, forIndexPath indexPath: IndexPath) -> CGMainScreenCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainScreenCell", for: indexPath) as! CGMainScreenCell
        return cell
    }
}
