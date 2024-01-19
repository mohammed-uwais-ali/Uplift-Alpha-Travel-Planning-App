//
//  WebsiteViewController.swift
//  Uplift
//
//  Created by Sam Pan on 11/22/23.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController {

    let webView = WKWebView()
    var websiteURL: String = "" //replace this later to pass into segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWW()
        loadWebsite()
    }
    
    func setupWW() {
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }
    
    func loadWebsite() {
        if let url = URL(string: websiteURL) {
            let request = URLRequest(url: url)
                webView.load(request)
        }
    }
    func getURL(_ url: String) {
        websiteURL = url
    }

}
