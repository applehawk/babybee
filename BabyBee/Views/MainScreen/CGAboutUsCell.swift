//
//  CGAboutUsCell.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

class CGAboutUsCell: UITableViewCell {
}

extension CGAboutUsCell {
    static func registerNib(in tableView: UITableView) -> UINib {
        let nibAboutUsCell = UINib(nibName: "CGAboutUsCell", bundle: nil)
        tableView.register(nibAboutUsCell, forCellReuseIdentifier: "aboutUsCell")
        return nibAboutUsCell
    }
}

