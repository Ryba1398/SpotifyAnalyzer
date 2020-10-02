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

class WebAuthViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {

    let webView2 = WKWebView()
    
    
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(webView2)
        self.view.addSubview(tabBar)
        
        webView2.navigationDelegate = self
        webView2.edgesToSuperview()
    }
    
    func presentHtmlPage(html: String) {
            
        //scope=\(SPTAuthStreamingScope)%20\(SPTAuthPlaylistReadPrivateScope)%20\(SPTAuthPlaylistModifyPublicScope)%20\(SPTAuthPlaylistModifyPrivateScope)
        
        let url = "https://accounts.spotify.com/authorize?client_id=\(ConstantInfo.SpotifyClientID)&redirect_uri=\(ConstantInfo.redirectURI)&nosignup=true&nolinks=true&show_dialog=true&response_type=code"
        
        let request = NSURLRequest(url: NSURL(string: url)! as URL)
        
        webView2.load(request as URLRequest)
        
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlString = navigationAction.request.url?.absoluteString
                
        processAuthResponse(urlString: urlString!)
    
        decisionHandler(.allow)
    }
    
    private func processAuthResponse(urlString: String){
        if((urlString.hasPrefix(ConstantInfo.redirectURI))){
            
            let code = getAuthCode(name: "code", fragment: urlString)
            
            if code != nil{
                print("Granted")
                print(code!)
                
                CurrentSessionManager.authWithCode(code: code!) {
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
                }
                
            }else{
                print("Denied")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
           //print("didReceiveServerRedirectForProvisionalNavigation")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
           //print("didCommitNavigation - content arriving?")
    }

    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
           //print("didFailNavigation")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("didStartProvisionalNavigation \(String(describing: navigation))")
        //print(webView.url)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           print("didFinishNavigation")
           webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                      completionHandler: { html, error in
                                       //print(html)
           })
    }
    
    private func getAuthCode(name: String, fragment: String) -> String? {
        let responseString = String(fragment.dropFirst(ConstantInfo.redirectURI.count+2))
        let pairs = responseString.components(separatedBy: "=")

        if(pairs.first == name){
            return pairs.last
        }
        
        return nil
    }
}
