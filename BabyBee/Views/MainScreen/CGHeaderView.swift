//
//  CGHeaderView.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit



class CGHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerSubtitle: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        if (UIScreen.main.bounds.height <= 480 ) {
            headerImageHeightConstraint.constant = 200
        }
        
        if (UIScreen.main.bounds.height >= 667 ) {
            headerImageHeightConstraint.constant = 320
        }
    }
}

extension CGHeaderView {
    func configureHeaderView(_ title: String, pictureImage: UIImage?) {
        headerImage.image = pictureImage
        headerSubtitle.text = title
    }
    func configureHeaderView(_ catalog: CGCatalogModel) {
        headerImage.image = catalog.pictureImage
        headerSubtitle.text = catalog.title
    }
    
    static func registerNib(in tableView: UITableView) -> UINib {
        let nibHeaderView = UINib(nibName: "CGHeaderView", bundle: nil)
        tableView.register(nibHeaderView, forHeaderFooterViewReuseIdentifier: "CGHeaderView")
        return nibHeaderView
    }
    
    static func dequeueReusableHeaderFooterView(in tableView: UITableView) -> CGHeaderView {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CGHeaderView") as! CGHeaderView
        return headerFooterView
    }
}


