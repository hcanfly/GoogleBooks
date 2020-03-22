//
//  WebViewController.swift
//  GoogleBooks
//
//  Created by Gary on 3/22/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import WebKit


final class WebViewController: UIViewController, WKNavigationDelegate, Storyboarded {
    private var webView: WKWebView!
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = self.webView

        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }

}
