//
//  CGGamesScreenViewController.swift
//  ChildGames
//
//  Created by v.vasilenko on 27.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGGamesScreenSubtitle = "Выберите игру для вашего малыша"

class GamesScreenDataSource : NSObject, UITableViewDataSource {
    var dataModel : CGDataModelProtocol?
    
    var selectedGroupId : Int = -1
    var groupModel : CGGroupModel?
    var gamesModelList : [CGGameModel]?
    
    init(dataModel : CGDataModelProtocol?, groupId: Int) {
        super.init()
        
        self.selectedGroupId = groupId
        self.dataModel = dataModel
        self.groupModel = dataModel?.groupModelWithId(groupId)
        self.gamesModelList = dataModel?.gamesListWithGroupId(groupId)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gamesModelList = gamesModelList {
            return gamesModelList.count;
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CGGamesScreenCell", forIndexPath: indexPath) as! CGGamesScreenCell
        
        if let gamesModelList = gamesModelList {
            let gameModel = gamesModelList[indexPath.row]
            cell.titleGameLabel.text = gameModel.nameGame;
        }
        
        return cell
    }
}

class CGGamesScreenViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerPictureImageView: UIImageView!
    
    var gamesScreenDataSource : GamesScreenDataSource?
    var dataModel : CGDataModelProtocol?
    var groupModel : CGGroupModel?
    var selectedGroupId : Int = -1
    var selectedGameId : Int = -1
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let title = dataModel?.groupModelWithId(selectedGroupId)?.groupName {
            sendOpenScreen(title)
        }
    }
    
    func configureHeaderView( headerView : CGHeaderView, title: String, headerImageName: String) {
        headerView.headerImage.image = UIImage(named: headerImageName)
        headerView.headerSubtitle.text = title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                var headerImageName = "headerScreen2"
                if (selectedGroupId == 0) {
                    headerImageName = "headerScreen0"
                }
                if (selectedGroupId == 1) {
                    headerImageName = "headerScreen3"
                }
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle, headerImageName: headerImageName)
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == CGMainScreenTableSections.MainSection.rawValue ) {
            
            if let headerView : CGHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(CGHeaderView)) as? CGHeaderView {
                
                self.configureHeaderView(headerView, title:CGGamesScreenSubtitle, headerImageName: "headerScreen0")
                
                headerView.layoutIfNeeded()
                headerView.layoutSubviews()
                
                let height = headerView.headerImageHeightConstraint.constant + headerView.headerSubtitle.frame.height
                
                return height
            } else {
                return 250.0
            }
        }
        return 0.0    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataModel = dataModel {
            gamesScreenDataSource = GamesScreenDataSource(dataModel: dataModel, groupId: selectedGroupId)
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedGameId = indexPath.row
        
        let gameModel = dataModel?.gameModelWithGroupIdAndGameId(self.selectedGroupId, idGame: self.selectedGameId)
        
        if let gameModel = gameModel {
            sendAction("Выбрана игра: \(gameModel.nameGame)",
                       categoryName: "Нажатие",
                       label: "\(gameModel.nameGame)",
                       value: self.selectedGameId)
        }
        
        self.performSegueWithIdentifier("contentScreenSegue", sender: self);
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
