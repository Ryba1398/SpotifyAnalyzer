//
//  WebAuthViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 21.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Then
import TinyConstraints
import WebKit

class WebAuthViewController: UIViewController {

    let webView2 = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(webView2)
        webView2.edgesToSuperview()
    }
    
    func presentHtmlPage(html: String) {
        
        print(html)
    
        
        webView2.loadHTMLString(html, baseURL: URL(string: "http://accounts.spotify.com"))
        
    }
}
