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
import SafariServices

class WebAuthViewController: UIViewController, SFSafariViewControllerDelegate{ //, WKUIDelegate, WKNavigationDelegate  {
    
    let webView2 = WKWebView()
    
    //static let instance  = WebAuthViewController()
    
    let progressView = UIProgressView(progressViewStyle: .default)
    
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //webView2.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(webView2)
        self.view.addSubview(tabBar)
        
//        webView2.navigationDelegate = self
//        webView2.edgesToSuperview()
        
        let navigationBar = navigationController?.navigationBar
        
        navigationBar!.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar!.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar!.trailingAnchor),

            progressView.bottomAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
             progressView.heightAnchor.constraint(equalToConstant: 2.0)
         ])
        
        progressView.width((navigationBar?.bounds.width)!)
        
        let button1 =  UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissController))
        self.navigationItem.leftBarButtonItem  = button1
        
        let button2 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem  = button2
        
        NotificationCenter.default.addObserver(self, selector: #selector(openURL), name: NSNotification.Name(rawValue: "processUrl"), object: nil)
        
        presentHtmlPage()
    }
    
    @objc func dismissController(){
        //self.dismiss(animated: true, completion: nil)
        
        UIApplication.shared.open(urlWEB!)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView2.estimatedProgress)
        }
    }
    
    @objc func share(){

        let items = [urlWEB]
        
        let activity = UIActivityViewController(
          activityItems: items,
          applicationActivities: nil
        )
        
        
        self.navigationController?.present(activity, animated: true, completion: nil)
    }
    
    var urlWEB : URL?
    
    var codeVerifier = ""
    var codeChallenge = ""
    var state = ""
    
    func presentHtmlPage() {
        
        
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
        
        
        print(codeVerifier)
        
        let url = "https://accounts.spotify.com/authorize?client_id=\(ConstantInfo.SpotifyClientID)&redirect_uri=\(ConstantInfo.redirectURI)&code_challenge_method=S256&code_challenge=\(codeChallenge)&state=\(state)&show_dialog=true&response_type=code"
        
        print(state)
        
        print(url)
        
        urlWEB = URL(string: url)
        //
        //let request = NSURLRequest(url: NSURL(string: url)! as URL)
        
        
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            vc.modalPresentationStyle = .overCurrentContext
            
            present(vc, animated: true)
        }
        
        //webView2.load(request as URLRequest)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        let url = navigationAction.request.url
//
//        print("LOLKEKE")
//
//
//        progressView.progress = Float(webView2.estimatedProgress)
//
//
//        print(webView2.estimatedProgress)
//
//        processAuthResponse(url: url!)
//
//
//
//        decisionHandler(.allow)
//    }
    
    @objc public func openURL(_ notification: NSNotification){
        
        processAuthResponse(url: notification.userInfo!["url"] as! URL)
        
    }
    
    public func processAuthResponse(url: URL){
        
        let urlString = url.absoluteString
        
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
            }else{
                print("this")
               // AuthorizationClass.auth.sessionManager.application(UIApplication.shared, open: url, options: [:])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        //print("didReceiveServerRedirectForProvisionalNavigation")
//    }
//
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        //print("didCommitNavigation - content arriving?")
//    }
//
//    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
//        //print("didFailNavigation")
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        //print("didStartProvisionalNavigation \(String(describing: navigation))")
//        //print(webView.url)
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("didFinishNavigation")
//        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
//                                   completionHandler: { html, error in
//        })
//    }
    
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
