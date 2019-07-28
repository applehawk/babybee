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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "",
                            style: UIBarButtonItem.Style.plain,
                            target: nil, action: nil)
        
        if let title = self.navigationItem.title {
            let screenName = String(format: CGAnalyticsOpenScreenContentScreenFmt, title)
            tracker.sendOpenScreen(screenName)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    @objc func closeAlert() {
        if let alertController = alertController {
            alertController.dismiss(animated: true, completion: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = game.name
        service.updateContentData(game.contentUrl) {
            if let htmlContent = self.service.obtainContentData(self.game.contentUrl) {
                self.loadHTMLContentIntoWebView(htmlContent: htmlContent)
            } else {
                let alert = UIAlertController(
                    title: "Ошибка запроса данных",
                    message: "Проверьте ваше интернет соединение",
                    preferredStyle: .alert)
                
                self.alertController = alert
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeAlert))
                alert.view.addGestureRecognizer(tapGesture)
                alert.addAction( UIAlertAction(title: "Хорошо", style: .default, handler: { (action) in
                    self.alertController?.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: {
                })
            }
        }
    }
}
