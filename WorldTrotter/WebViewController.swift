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
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homePage = URL(string: "https://www.bignerdranch.com")
        let urlReq = URLRequest(url: homePage!)
        webView.load(urlReq)
    }
}
