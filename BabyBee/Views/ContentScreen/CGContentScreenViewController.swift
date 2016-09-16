//
//  ContentScreenViewController.swift
//  ChildGames
//
//  Created by v.vasilenko on 28.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit
import WebKit

class CGContentScreenViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var containerView: UIView!
    
    // Injected by Typhoon
    var tracker : CGAnalyticsTrackerProtocol!
    var fabricRequest : CGFabricRequestProtocol!
    var service : CGCatalogServiceProtocol!
    
    // Setted by previous ViewController
    var game : CGContentModel!
    
    var webView : WKWebView!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let title = self.navigationItem.title {
            let screenName = String(format: CGAnalyticsOpenScreenContentScreenFmt, title)
            tracker.sendOpenScreen(screenName)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        view = webView
    }
    
    func loadHTMLContentIntoWebView( htmlContent: String ) {
        let stylesheet =
            "<style type=\"text/css\">                  " +
                "   body {                                  " +
                "       font-family: 'Verdana'; margin: 10px" +
                "   }                                       " +
                "   img {                                   " +
                "       width: 100%;  display:block; margin:auto; padding:auto;" +
                "       height: auto;" +
                "   }                                       " +
                "   #containter {" +
                "       " +
                "   }" +
        "</style>"
        
        let headHtml = "<meta name=\"viewport\" content=\"initial-scale=1.2\" />\(stylesheet)"
        
        let htmlContent =
        "<html><head>\(headHtml)</head>" +
        "<body>" +
        "   <div id=\"container\"><p>\(htmlContent)</p></div>" +
        "</body>" +
        "</html>"
        
        webView?.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    var alertController : UIAlertController?
    
    func closeAlert() {
        if let alertController = alertController {
            alertController.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = game.name
        service.updateContentData(game.contentUrl) {
            if let htmlContent = self.service.obtainContentData(self.game.contentUrl) {
                self.loadHTMLContentIntoWebView(htmlContent)
            } else {
                let alert = UIAlertController(title: "Ошибка запроса данных",
                                              message: "Проверьте ваше интернет соединение",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                self.alertController = alert
                let tapGesture = UITapGestureRecognizer(target: self, action: "closeAlert")
                alert.view.addGestureRecognizer(tapGesture)
                alert.addAction( UIAlertAction(title: "Хорошо", style: .Default, handler: { (action) in
                    self.alertController?.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                self.presentViewController(alert, animated: true, completion: {
                })
            }
        }
        /*
        do {
            if let url = fabricRequest.requestWithContentName(game.contentUrl)?.URL {
                let htmlContent = try String(contentsOfURL: url)
                loadHTMLContentIntoWebView(htmlContent)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } catch {
            print(error)
        }*/
    }
}
