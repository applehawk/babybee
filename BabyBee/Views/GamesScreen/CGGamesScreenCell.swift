//
//  CGGamesScreen.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

class CGGamesScreenCell: UITableViewCell {

    @IBOutlet weak var titleGameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
}

extension CGGamesScreenCell {
    func configureCell(with content: CGContentModel) {
        self.titleGameLabel.text = content.name
    }
    static func registerNib(in tableView: UITableView) -> UINib {
        let nibGamesScreenCell = UINib(nibName: "CGGamesScreenCell", bundle: nil)
        tableView.register(nibGamesScreenCell, forCellReuseIdentifier: "gamesScreenCell")
        return nibGamesScreenCell
    }
    static func dequeueReusableCell(in tableView: UITableView, forIndexPath indexPath: IndexPath) -> CGGamesScreenCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamesScreenCell", for: indexPath) as! CGGamesScreenCell
        return cell
    }
}
