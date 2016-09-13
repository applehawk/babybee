//
//  CGGamesScreenViewController.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

class CGGamesScreenViewController: UIViewController, CGGamesScreenProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    // Injected by Typhoon
    var gamesScreenDDM : CGGamesScreenDDM!
    var dataModel : CGDataModelProtocol!
    var tracker : CGAnalyticsTracker!
    var assembly : ApplicationAssembly!
    
    // My custom Properties
    var groupModel : CGGroupModel?
    
    //it's setted by previous controlled which appears it
    var selectedGroupId : Int = 0
    var selectedGameId : Int = 0
    
    // MARK: - CGGamesScreenProtocol methods
    func didSelectedGame(gameName : String, gameId: Int) {
        let selectedAction = String(format: CGAnalyticsEventGameSelectedFmt, gameName)
        tracker.sendAction(selectedAction,
                   categoryName: CGAnalyticsCategoryClick,
                   label: gameName,
                   value: gameId)
        
        selectedGameId = gameId
        
        self.performSegueWithIdentifier(CGContentScreenSegueName, sender: self)
    }
    
    
    // MARK: - UIViewController methods
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let groupModel = dataModel.groupModelWithId(selectedGroupId) {
            tracker.sendOpenScreen( groupModel.groupName )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gamesScreenDDM = assembly?.gamesScreenDDM(self.selectedGroupId) as? CGGamesScreenDDM
        
        if let groupModel = dataModel?.groupModelWithId(selectedGroupId) {
            self.navigationItem.title = groupModel.groupName
        }

        let nib = UINib(nibName: String(CGGamesScreenCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(CGGamesScreenCell));
        
        let headerNib = UINib(nibName: String(CGHeaderView), bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: String(CGHeaderView))
        
        tableView.delegate = gamesScreenDDM;
        tableView.dataSource = gamesScreenDDM;
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CGContentScreenSegueName {
            if let destinationVC = segue.destinationViewController as? CGContentScreenViewController {
                destinationVC.gameId = self.selectedGameId
                destinationVC.groupId = self.selectedGroupId
            }
        }
    }
}
