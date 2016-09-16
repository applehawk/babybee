//
//  ViewController./Users/v.vasilenko/Documents/XcodeProjects/ChildGames/ChildGamesswift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

class CGMainScreenViewController: UIViewController, CGAgeAskingDelegate, CGMainScreenDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var activityIndicator: UIActivityIndicatorView!
    
    //Dependencies injected property
    var tracker : CGAnalyticsTracker!
    var mainScreenDDM : CGMainScreenDDMProtocol!
    var catalogService : CGCatalogServiceProtocol!
    var userDefaults : NSUserDefaults!
    var assembly : ApplicationAssembly!
    
    var selectedGroupId = 0
    var resultBirthDayStr = ""
    var catalog : CGCatalogModel?
    
    // MARK: - CGAgeAskingDelegate
    func ageConfirm( birthDate: NSDate ) {
        let now = NSDate()
        let components = birthDate.numberOfMonthsAndDaysToTime(now)
        let pluralBirthDay = String().convertDateComponentsToPluralDate(components)
        
        resultBirthDayStr = CGBirthDayPrefix + " " + pluralBirthDay
        
        userDefaults.setObject(birthDate, forKey: CGBabyBirthDateUserDefaults)
        
        let dateString = birthDate.convertDateToGOSTDateString()
        // Send to Analytics confirm Action
        tracker.sendAction(CGAnalyticsFirebaseEventBirthdayOk,
                        actionTitle: CGAnalyticsEventBirthdayOk + " " + dateString,
                        categoryName: CGAnalyticsCategoryClick,
                        label: dateString,
                        value: 0)
        
        tableView.reloadData()
    }
    func ageCancelled() {
        self.resultBirthDayStr = CGBirthdayAltText
        tracker.sendAction(CGAnalyticsFirebaseEventBirthdayCancel,
                        actionTitle: CGAnalyticsEventBirthdayCancel,
                        categoryName: CGAnalyticsCategoryClick,
                        label: "",
                        value: 0)
        
        self.userDefaults.setObject(NSNumber(bool: true),
                                    forKey: CGBabyBirthCancelUserDefaults)
        tableView.reloadData()
    }
    
    // MARK: - CGMainScreenProtocol used in UITableViewDelegate
    func birthdayString() -> String {
        return resultBirthDayStr
    }
    
    func didSelectedGroup(groupName : String, selectedRow: Int) {
        selectedGroupId = selectedRow
        let actionName = String(format: CGAnalyticsEventGroupSelectFmt,
                                NSNumber(integer: selectedRow))
        
        tracker.sendAction(CGAnalyticsFirebaseEventGroupSelected,
                    actionTitle: actionName,
                   categoryName: CGAnalyticsCategoryClick,
                   label: "\(groupName)",
                   value: selectedRow)
        
        performSegueWithIdentifier(CGGamesScreenSegueName, sender: self)
    }
    
    // MARK: - UIViewController
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        tracker.sendOpenScreen(CGMainScreenTitle)
    }
    
    func refreshHandler() {
        refreshControl.beginRefreshing()
        catalogService.updateCatalog { (error) in
            if let catalog = self.catalogService.obtainCatalog() {
                self.catalog = catalog
                dispatch_async(dispatch_get_main_queue(), {
                    if let title = catalog.title {
                        self.navigationItem.title = catalog.title
                    }
                })
                self.mainScreenDDM = self.assembly.mainScreenDDM(catalog) as? CGMainScreenDDM
                self.tableView.delegate = self.mainScreenDDM;
                self.tableView.dataSource = self.mainScreenDDM;
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CGMainScreenTitle;
        
        let nibHeaderView = UINib(nibName: String(CGHeaderView), bundle: nil)
        tableView.registerNib(nibHeaderView, forHeaderFooterViewReuseIdentifier: String(CGHeaderView))
        
        let nibMainScreenCell = UINib(nibName: String(CGMainScreenCell), bundle: nil)
        tableView.registerNib(nibMainScreenCell, forCellReuseIdentifier: String(CGMainScreenCell));
        
        let nibAboutUsCell = UINib(nibName: String(CGAboutUsCell), bundle: nil)
        tableView.registerNib(nibAboutUsCell, forCellReuseIdentifier: String(CGAboutUsCell));
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollEnabled = true
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.hidesWhenStopped = true
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshHandler", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refreshControl)
        self.refreshHandler()
        // Show birthday Popup
        self.askAgeIfNeeded()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CGGamesScreenSegueName {
            guard let destinationVC = segue.destinationViewController as? CGGamesScreenViewController else {
                print("Where is destinationVC? of CGGamesScreenViewController")
                return
            }
            destinationVC.catalog = catalog
            destinationVC.currentGroup = catalog?.groups?[ selectedGroupId ]
        }
    }
    
    // MARK: Helper Methods
    func askAgeIfNeeded() {
        // Show birthday Popup
        if let isCanceledBirthDay = userDefaults.objectForKey(CGBabyBirthCancelUserDefaults) as? NSNumber where isCanceledBirthDay == true {
            resultBirthDayStr = CGBirthdayAltText
        } else {
            if let birthDate = userDefaults.objectForKey(CGBabyBirthDateUserDefaults) as? NSDate {
                self.ageConfirm(birthDate)
            } else {
                let ageAskVC = CGAgeAskingController(title: CGBirthAlertTitle,
                                                     message: CGBirthAlertMessage,
                                                     preferredStyle: .Alert)
                ageAskVC.ageAskingDelegate = self
                self.presentViewController(ageAskVC, animated: true, completion: nil)
            }
        }
    }
}

