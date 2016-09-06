//
//  CGGamesScreenViewController.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGGamesScreenSubtitle = "Выберите игру для вашего малыша"

class CGGamesScreenViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var gamesScreenDataSource : CGGamesScreenDDM!
    var dataModel : CGDataModelProtocol!
    
    var groupModel : CGGroupModel?
    
    var selectedGroupId : Int = 0
    var selectedGameId : Int = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let title = dataModel?.groupModelWithId(selectedGroupId)?.groupName {
            sendOpenScreen(title)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataModel = dataModel {
            gamesScreenDataSource = CGGamesScreenDDM(dataModel: dataModel, groupId: selectedGroupId)
            groupModel = dataModel.groupModelWithId(selectedGroupId)
            
            if let groupModel = groupModel {
                self.navigationItem.title = groupModel.groupName
            }
        }

        let nib = UINib(nibName: String(CGGamesScreenCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(CGGamesScreenCell));
        
        let headerNib = UINib(nibName: String(CGHeaderView), bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: String(CGHeaderView))
        
        tableView.delegate = self;
        tableView.dataSource = gamesScreenDataSource;
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contentScreenSegue" {
            if let destinationVC = segue.destinationViewController as? CGContentScreenViewController {
                
                destinationVC.dataModel = self.dataModel
                destinationVC.gameId = self.selectedGameId
                destinationVC.groupId = self.selectedGroupId
            }
        }
    }
}
