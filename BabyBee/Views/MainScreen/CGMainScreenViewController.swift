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
    var userDefaults : UserDefaults!
    //var assembly : ApplicationAssembly!
    
    fileprivate var selectedGroupId = 0
    fileprivate var resultBirthDayStr = ""
    fileprivate var catalog : CGCatalogModel?
    
    // MARK: - CGAgeAskingDelegate
    func ageConfirm(_ birthDate: Date ) {
        let now = Date(timeIntervalSinceNow: 0)
        let components = birthDate.numberOfMonthsAndDaysToTime(toDateTile: now)
        let pluralBirthDay = String().convertDateComponentsToPluralDate(components: components)
        
        resultBirthDayStr = CGBirthDayPrefix + " " + pluralBirthDay
        
        userDefaults.set(birthDate, forKey: CGBabyBirthDateUserDefaults)
        
        let dateString = birthDate.convertDateToGOSTDateString()
        // Send to Analytics confirm Action
        tracker.sendAction(withName: CGAnalyticsFirebaseEventBirthdayOk,
                        actionTitle: CGAnalyticsEventBirthdayOk + " " + dateString,
                        categoryName: CGAnalyticsCategoryClick,
                        label: dateString,
                        value: 0)
        
        tableView.reloadData()
    }
    func ageCancelled() {
        self.resultBirthDayStr = CGBirthdayAltText
        tracker.sendAction(withName: CGAnalyticsFirebaseEventBirthdayCancel,
                        actionTitle: CGAnalyticsEventBirthdayCancel,
                        categoryName: CGAnalyticsCategoryClick,
                        label: "",
                        value: 0)
        
        self.userDefaults.set(NSNumber(value: true),
                                    forKey: CGBabyBirthCancelUserDefaults)
        tableView.reloadData()
    }
    
    // MARK: - CGMainScreenProtocol used in UITableViewDelegate
    func birthdayString() -> String {
        return resultBirthDayStr
    }
    
    func didSelectedGroup(_ groupName : String, selectedRow: Int) {
        selectedGroupId = selectedRow
        let actionName = String(format: CGAnalyticsEventGroupSelectFmt,
                                NSNumber(value: selectedRow))
        
        tracker.sendAction(withName: CGAnalyticsFirebaseEventGroupSelected,
                    actionTitle: actionName,
                   categoryName: CGAnalyticsCategoryClick,
                   label: "\(groupName)",
                    value: NSNumber(value: selectedRow))
        
        performSegue(withIdentifier: CGGamesScreenSegueName, sender: self)
    }
    
    // MARK: - UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain,
                            target: nil, action: nil)
        
        tracker.sendOpenScreen(CGMainScreenTitle)
    }
    
    @objc func refreshHandler() {
        refreshControl.beginRefreshing()
        catalogService.updateCatalog { (error) in
            if let catalog = self.catalogService.obtainCatalog() {
                self.catalog = catalog
                DispatchQueue.main.async {
                    if let title = catalog.title {
                        self.navigationItem.title = catalog.title
                    }
                }
                self.mainScreenDDM = DIResolver.resolve(CGMainScreenDDM.self, argument: catalog)
                self.tableView.delegate = self.mainScreenDDM;
                self.tableView.dataSource = self.mainScreenDDM;
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CGMainScreenTitle;
        
        CGHeaderView.registerNib(in: tableView)
        CGMainScreenCell.registerNib(in: tableView)
        CGAboutUsCell.registerNib(in: tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = true
        
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshHandler"), for: .valueChanged)
        
        self.tableView.addSubview(refreshControl)
        self.refreshHandler()
        // Show birthday Popup
        self.askAgeIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CGGamesScreenSegueName {
            guard let destinationVC = segue.destination as? CGGamesScreenViewController else {
                print("Where is destinationVC? of CGGamesScreenViewController")
                return
            }
            destinationVC.catalog = catalog
            destinationVC.currentGroup = catalog?.groups?[ selectedGroupId ]
        }
    }
    
    
    // MARK: Helper Methods
    fileprivate func askAgeIfNeeded() {
        // Show birthday Popup
        if let isCanceledBirthDay = userDefaults.object(forKey: CGBabyBirthCancelUserDefaults) as? NSNumber, isCanceledBirthDay == true {
            resultBirthDayStr = CGBirthdayAltText
        } else {
            if let birthDate = userDefaults.object(forKey: CGBabyBirthDateUserDefaults) as? Date {
                self.ageConfirm(birthDate)
            } else {
                let ageAskVC = CGAgeAskingController(title: CGBirthAlertTitle,
                                                     message: CGBirthAlertMessage,
                                                     preferredStyle: .alert)
                ageAskVC.ageAskingDelegate = self
                self.present(ageAskVC, animated: true, completion: nil)
            }
        }
    }
}

