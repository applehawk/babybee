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
    
    let tracker = CGAnalyticsTracker()
    
    var webView : WKWebView!
    var dataModel : CGDataModelProtocol!
    var gameId : Int = 0
    var groupId : Int = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let title = self.navigationItem.title {
            tracker.sendOpenScreen("Игра: " + title)
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let games = dataModel.gamesListWithGroupId(groupId)
        
        if let games = games, let gameModel : CGGameModel = games[gameId] {
            self.navigationItem.title = gameModel.nameGame
            
            tracker.sendOpenScreen(gameModel.nameGame)
            loadHTMLContentIntoWebView(gameModel.htmlContent)
        }
    }
}
