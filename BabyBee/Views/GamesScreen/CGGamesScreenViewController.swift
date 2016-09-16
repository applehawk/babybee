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
    var gamesScreenDDM : CGGamesScreenDDMProtocol!
    var tracker : CGAnalyticsTrackerProtocol!
    var assembly : ApplicationAssembly!
    
    // My custom Properties
    var catalog : CGCatalogModel!
    var currentGroup : CGGroupModel!
    
    //it's setted by previous controlled which appears it
    var selectedGameId : String?
    
    // MARK: - CGGamesScreenProtocol methods
    func didSelectedGame(gameName : String, gameId: String) {
        selectedGameId = gameId
        let selectedAction = String(format: CGAnalyticsEventGameSelectedFmt, gameName)
        tracker.sendAction( CGAnalyticsFirebaseEventGameSelected,
                  actionTitle: selectedAction,
                   categoryName: CGAnalyticsCategoryClick,
                   label: gameId,
                   value: 0)
        
        self.performSegueWithIdentifier(CGContentScreenSegueName, sender: self)
    }
    
    
    // MARK: - UIViewController methods
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        tracker.sendOpenScreen( currentGroup.groupName )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gamesScreenDDM = assembly?.gamesScreenDDM(catalog, group: currentGroup) as? CGGamesScreenDDM
        self.navigationItem.title = currentGroup.groupName

        let nib = UINib(nibName: String(CGGamesScreenCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(CGGamesScreenCell));
        
        let headerNib = UINib(nibName: String(CGHeaderView), bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: String(CGHeaderView))
        
        tableView.delegate = gamesScreenDDM;
        tableView.dataSource = gamesScreenDDM;
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CGContentScreenSegueName {
            if let destinationVC = segue.destinationViewController as? CGContentScreenViewController {
                if let selectedGameId = selectedGameId {
                    destinationVC.game = catalog.games?[selectedGameId]
                }
            }
        }
    }
}
