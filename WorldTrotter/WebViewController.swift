//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Tyler Percy on 2/11/19.
//  Copyright © 2019 Tyler Percy. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView! //Programmatically create web viewer
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView //sets web view to display in the ViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is the first page that will show up when the web tab is displayed
        let homePage = URL(string: "https://www.bignerdranch.com")
        let urlReq = URLRequest(url: homePage!)
        webView.load(urlReq)
    }
}
