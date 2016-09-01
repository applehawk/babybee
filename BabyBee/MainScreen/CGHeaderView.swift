//
//  CGHeaderView.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

class CGHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerSubtitle: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        if (UIScreen.mainScreen().bounds.height <= 480 ) {
            headerImageHeightConstraint.constant = 200
        }
        
        if (UIScreen.mainScreen().bounds.height >= 667 ) {
            headerImageHeightConstraint.constant = 320
        }
    }
}