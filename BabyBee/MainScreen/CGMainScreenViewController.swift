//
//  ViewController./Users/v.vasilenko/Documents/XcodeProjects/ChildGames/ChildGamesswift
//  ChildGames
//
//  Created by v.vasilenko on 26.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit

let CGStaticHeight = 44.0;

enum CGMainScreenTableSections : Int {
    case MainSection = 0
}

// MARK: - User Defaults
let CGBabyBirthUserDefaults = "babyBirthDate"
let CGBabyBirthCancelUserDefaults = "isBabyBirthCanceled"

// MARK: - Segue names of MainScreen
let CGGamesScreenSegueName = "gamesScreenSegue"

// MARK: - String constants of MainScreen
let CGBirthAlertTitle = "Дата рождения малыша"
let CGBirthDayPrefix = "Вашему ребенку уже\n"
let CGBirthAlertMessage = "Введите дату рождения вашего малыша"
let CGBirthDatePlaceholder = "Например 14.06.2016"
let CGMainScreenTitle = "Игры для развития малыша"
let CGCancelTitle =  "Отмена"
let CGConfirmTitle = "Подтвердить"
let CGBirthdayAltText = "Ваш малыш растет вместе с пчелкой BabyBee"

let CGAnalyticsEventCategorySelect = "Выбрана категория: %@"
let CGAnalyticsCategoryClick = "Нажатие"
let CGAnalyticsEventBirthdayCancel = "Cancel - дата рождения"
let CGAnalyticsEventBirthdayOk = "Ок - дата рождения"

class CGMainScreenViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mainScreenDDM : CGMainScreenDDM
    var dataModel : CGDataModelProtocol
    var selectedIndexRow : Int = -1
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CGGamesScreenSegueName {
            if let destinationVC = segue.destinationViewController as? CGGamesScreenViewController {
                destinationVC.selectedGroupId = selectedIndexRow
                destinationVC.dataModel = self.dataModel
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = CGMainScreenTitle;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        sendOpenScreen(CGMainScreenTitle)
    }
    
    func configureHeaderView( headerView : CGHeaderView, title: String, headerImageName: String) {
        headerView.headerImage.image = UIImage(named: headerImageName)
        headerView.headerSubtitle.text = title
    }
    
    func prepareDataModel() {
        self.dataModel = CGDataModelJSONAdapter(mainFileName: "mums")
        mainScreenDataSource = MainScreenDataSource(dataModel: self.dataModel)
    }
    
    func prepareTableView() {
        let nibHeaderView = UINib(nibName: String(CGHeaderView), bundle: nil)
        tableView.registerNib(nibHeaderView, forHeaderFooterViewReuseIdentifier: String(CGHeaderView))
        
        let nibMainScreenCell = UINib(nibName: String(CGMainScreenCell), bundle: nil)
        tableView.registerNib(nibMainScreenCell, forCellReuseIdentifier: String(CGMainScreenCell));
        
        let nibAboutUsCell = UINib(nibName: String(CGAboutUsCell), bundle: nil)
        tableView.registerNib(nibAboutUsCell, forCellReuseIdentifier: String(CGAboutUsCell));
        
        tableView.delegate = self.mainScreenDDM;
        tableView.dataSource = self.mainScreenDDM;
    }
    
    var resultBirthDayStr : String = ""
    var confirmAction : UIAlertAction!
    var textFieldBirthDate : UITextField!
    
    func confirsYearsOld( birthDate: NSDate) {
        let now = NSDate()
        let components = birthDate.numberOfMonthsAndDaysToTime(now)
        let pluralBirthDay = String().convertDateComponentsToPluralDate(components)
        self.resultBirthDayStr = CGBirthDayPrefix + " " + pluralBirthDay
        
        tableView.reloadData()
    }
    
    func dataChanged(picker: UIDatePicker) {
        if let textField = textFieldBirthDate {
            textField.text = picker.date.convertDateToGOSTDateString()
            confirmAction.enabled = textField.text != ""
        }
    }
    func showAgeModalView() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .Date
        datepicker.maximumDate = NSDate()
        datepicker.addTarget(self, action: #selector(CGMainScreenViewController.dataChanged(_:)),
                             forControlEvents: UIControlEvents.ValueChanged );
        
        let alertController = UIAlertController(title: CGBirthAlertTitle,
                                                message: CGBirthAlertMessage,
                                                preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: CGCancelTitle, style: .Cancel) { (action) in
            self.sendAction(CGAnalyticsEventBirthdayCancel,
                            categoryName: CGAnalyticsCategoryClick,
                            label: "",
                            value: 0)
            
            userDefaults.setObject("canceled", forKey: CGBabyBirthCancelUserDefaults)
            
            self.resultBirthDayStr = CGBirthdayAltText
        }
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: CGConfirmTitle, style: .Default) { (action) in
            userDefaults.setObject(datepicker.date, forKey: CGBabyBirthUserDefaults)
            
            let dateString = datepicker.date.convertDateToGOSTDateString()
            self.sendAction(CGAnalyticsEventBirthdayOk + " " + dateString,
                       categoryName: CGAnalyticsCategoryClick,
                       label: dateString,
                       value: 0)
            
            self.confirsYearsOld(datepicker.date);
        }
        self.confirmAction = confirmAction
        confirmAction.enabled = false
        alertController.addAction(confirmAction)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            self.textFieldBirthDate = textField
            textField.inputView = datepicker
            textField.placeholder = CGBirthDatePlaceholder
            textField.delegate = self
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        prepareDataModel()
        prepareTableView()
        
        let isCanceledBirthDay = defaults.objectForKey(CGBabyBirthCancelUserDefaults) as? NSNumber
        let babyDate = defaults.objectForKey(CGBabyBirthUserDefaults) as? NSDate
        
        if let babyDate = babyDate {
            confirsYearsOld(babyDate)
        } else if isCanceledBirthDay != nil {
            resultBirthDayStr = CGBirthdayAltText
        } else {
            showAgeModalView();
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexRow = indexPath.row
        let actionName = String(format: CGAnalyticsEventCategorySelect, NSNumber(integer: indexPath.row))
        
        if let groupModel = dataModel?.groupModelWithId(self.selectedIndexRow) {
            sendAction(actionName,
                       categoryName: CGAnalyticsCategoryClick,
                       label: "\(groupModel.groupName)",
                       value: self.selectedIndexRow)
        } else {
            sendAction(actionName, categoryName: CGAnalyticsCategoryClick, label: "Ошибка модели", value: 0)
        }
        
        self.performSegueWithIdentifier(CGGamesScreenSegueName, sender: self);
    }
}

