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
    //var assembly : ApplicationAssembly!
    
    // My custom Properties
    var catalog : CGCatalogModel!
    var currentGroup : CGGroupModel!
    
    //it's setted by previous controlled which appears it
    var selectedGameId : String?
    
    // MARK: - CGGamesScreenProtocol methods
    func didSelectedGame(_ gameName: String, gameId: String) {
        selectedGameId = gameId
        let selectedAction = String(format: CGAnalyticsEventGameSelectedFmt, gameName)
        tracker.sendAction( withName: CGAnalyticsFirebaseEventGameSelected,
                  actionTitle: selectedAction,
                   categoryName: CGAnalyticsCategoryClick,
                   label: gameId,
                   value: 0)
        
        self.performSegue(withIdentifier: CGContentScreenSegueName, sender: self)
    }
    
    
    // MARK: - UIViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        tracker.sendOpenScreen( currentGroup.groupName )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gamesScreenDDM = DIResolver.resolve(CGGamesScreenDDM.self, arguments: catalog, currentGroup)
        self.navigationItem.title = currentGroup.groupName

        let nib = UINib(nibName: "CGGamesScreenCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CGGamesScreenCell");
        
        let headerNib = UINib(nibName: "CGHeaderView", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "CGHeaderView")
        
        tableView.delegate = gamesScreenDDM;
        tableView.dataSource = gamesScreenDDM;
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, segue.identifier) {
            
        case let (destVC, segueID) as (CGContentScreenViewController, String) where segueID == CGContentScreenSegueName:
            
            guard let selectedGameId = selectedGameId else {
                break
            }
            destVC.game = catalog.games?[selectedGameId]
            
        default:
            break
        }
        
        return super.prepare(for: segue, sender: sender)
    }
}
