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

class WebAuthViewController: UIViewController, WKUIDelegate {

    let webView2 = WKWebView()
    
    
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(webView2)
        self.view.addSubview(tabBar)
        
        
        webView2.edgesToSuperview()
    }
    
    func presentHtmlPage(html: String) {
        
        print(html)
    
        
        webView2.loadHTMLString(html, baseURL: URL(string: "http://accounts.spotify.com"))
        
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // A nil targetFrame means a new window (from Apple's doc)
        if (navigationAction.targetFrame == nil) {
            // Let's create a new webview on the fly with the provided configuration,
            // set us as the UI delegate and return the handle to the parent webview
            
            print("4s5dr6ft7yguionpm")
            
            let popup = WKWebView(frame: self.view.frame, configuration: configuration)
            popup.uiDelegate = self
            self.view.addSubview(popup)
            return popup
        }
        return nil;
    }
    
    func webViewDidClose(webView: WKWebView) {
        // Popup window is closed, we remove it
        webView.removeFromSuperview()
    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        guard let u = self.webuser, let p = self.webp else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//            return
//        }
//
//        let creds = URLCredential.init(user: u, password: p, persistence: .forSession)
//        completionHandler(.useCredential, creds)
//    }
    
    
//    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        guard let hostname = webView.url?.host else {
//            return
//        }
//
//        let authenticationMethod = challenge.protectionSpace.authenticationMethod
//        if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
//            let av = UIAlertController(title: webView.title, message: String(format: "AUTH_CHALLENGE_REQUIRE_PASSWORD".localizedUppercase, hostname), preferredStyle: .alert)
//            av.addTextField(configurationHandler: { (textField) in
//                textField.placeholder = "USER_ID".localizedUppercase
//            })
//            av.addTextField(configurationHandler: { (textField) in
//                textField.placeholder = "PASSWORD".localizedUppercase
//                textField.isSecureTextEntry = true
//            })
//
//            av.addAction(UIAlertAction(title: "BUTTON_OK".localizedUppercase, style: .default, handler: { (action) in
//                guard let userId = av.textFields?.first?.text else{
//                    return
//                }
//                guard let password = av.textFields?.last?.text else {
//                    return
//                }
//                let credential = URLCredential(user: userId, password: password, persistence: .none)
//                completionHandler(.useCredential,credential)
//            }))
//            av.addAction(UIAlertAction(title: "BUTTON_CANCEL".localizedUppercase, style: .cancel, handler: { _ in
//                completionHandler(.cancelAuthenticationChallenge, nil);
//            }))
//            self.parent?.present(av, animated: true, completion: nil)
//        }else if authenticationMethod == NSURLAuthenticationMethodServerTrust{
//            // needs this handling on iOS 9
//            completionHandler(.performDefaultHandling, nil);
//        }else{
//            completionHandler(.cancelAuthenticationChallenge, nil);
//        }
//    }
    
}
