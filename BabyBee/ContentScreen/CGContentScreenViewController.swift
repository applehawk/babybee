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
    var webView : WKWebView?
    
    var dataModel : CGDataModelProtocol?
    var gameId : Int = -1
    var groupId : Int = -1
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let title = self.navigationItem.title {
            sendOpenScreen("Игра: " + title)
        }
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let games = dataModel?.gamesListWithGroupId(groupId) {
            if let gameModel : CGGameModel = games[gameId] {
                
                self.navigationItem.title = gameModel.nameGame
                
                sendOpenScreen(gameModel.nameGame)
                
                let modelHtmlContent = gameModel.htmlContent
                
                let stylesheet =
                "<style type=\"text/css\">                  " +
                "   body {                                  " +
                "       font-family: 'Verdana'; margin: 10px" +
                "   }                                       " +
                "   img {                                   " +
                "       max-height:200px; width: 100%;  display:block; margin:auto; padding:auto;" +
                "       height: auto;" +
                "   }                                       " +
                "</style>"
                
                let headHtml = "<meta name=\"viewport\" content=\"initial-scale=1.2\" />\(stylesheet)"
                
                let htmlContent = "<html><head>\(headHtml)</head><body><p>\(modelHtmlContent)</p></body></html>"
                webView?.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
}
