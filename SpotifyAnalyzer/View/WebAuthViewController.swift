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
import CommonCrypto

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
    
    var codeVerifier = ""
    var codeChallenge = ""
    var state = ""
    
    func presentHtmlPage(html: String) {
        
        
        var buffer = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        codeVerifier = Data(bytes: buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "=", with: "-")
            .trimmingCharacters(in: .whitespaces)
        
        
        
        let codeVerifierBytes = codeVerifier.data(using: .ascii)!
        var onebuffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        codeVerifierBytes.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(codeVerifierBytes.count), &onebuffer)
        }
        let codeChallengeBytes = Data(bytes: onebuffer)
        codeChallenge = codeChallengeBytes.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        state = UUID().uuidString

        let url = "https://accounts.spotify.com/authorize?client_id=\(ConstantInfo.SpotifyClientID)&state=\(state)&code_challenge_method=S256&code_challenge=\(codeChallenge)&redirect_uri=\(ConstantInfo.redirectURI)&nosignup=true&nolinks=true&show_dialog=true&response_type=code"
        
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
            
            let result = getAuthCode(fragment: urlString)
                        
            if(result["state"] == state){
             
                let code = result["code"]
                
                if code != nil{
                    print("Granted")
                    print(code!)
                    
                    CurrentSessionManager.authWithCode(codeVerifier: codeVerifier, code: code!) {
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
                    }
                    
                }else{
                    print("Denied")
                    self.dismiss(animated: true, completion: nil)
                }
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
        })
    }
    
    private func getAuthCode(fragment: String) -> [String: String] {
        let responseString = String(fragment.dropFirst(ConstantInfo.redirectURI.count+2))
        let pairs = responseString.components(separatedBy: "&")
        
        var responseValues = [String: String]()
        
        for pair in pairs{
            let item = pair.components(separatedBy: "=")
            responseValues[item.first!] = item.last
        }
        return responseValues
    }
}
