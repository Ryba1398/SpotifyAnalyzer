////
////  WebAuthentication.swift
////  SpotifyAnalyzer
////
////  Created by Николай Рыбин on 05.10.2020.
////  Copyright © 2020 Николай Рыбин. All rights reserved.
////
//
//import Foundation
//import WebKit
//import CommonCrypto
//
//class WebAuthentication: NSObject, WKNavigationDelegate {
//    
//    static var codeVerifier = ""
//    
//    
//    
//    func presentHtmlPage(html: String) {
//        
//        
//        var buffer = [UInt8](repeating: 0, count: 64)
//        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
//        WebAuthentication.self.codeVerifier = Data(bytes: buffer).base64EncodedString()
//                                              .replacingOccurrences(of: "+", with: "-")
//                                              .replacingOccurrences(of: "/", with: "-")
//                                              .replacingOccurrences(of: "=", with: "-")
//                                              .trimmingCharacters(in: .whitespaces)
//        
//        
//        
//        let codeVerifierBytes = WebAuthViewController.codeVerifier.data(using: .ascii)!
//        var onebuffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        codeVerifierBytes.withUnsafeBytes {
//          _ = CC_SHA256($0, CC_LONG(codeVerifierBytes.count), &onebuffer)
//        }
//        let codeChallengeBytes = Data(bytes: onebuffer)
//        let codeChallenge = codeChallengeBytes.base64EncodedString()
//                                              .replacingOccurrences(of: "+", with: "-")
//                                              .replacingOccurrences(of: "/", with: "_")
//                                              .replacingOccurrences(of: "=", with: "")
//                                              .trimmingCharacters(in: .whitespaces)
//        
//        let url = "https://accounts.spotify.com/authorize?client_id=\(ConstantInfo.SpotifyClientID)&code_challenge_method=S256&code_challenge=\(codeChallenge)&redirect_uri=\(ConstantInfo.redirectURI)&nosignup=true&nolinks=true&show_dialog=true&response_type=code"
//        
//        let request = NSURLRequest(url: NSURL(string: url)! as URL)
//        
//        webView2.load(request as URLRequest)
//        
//        
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        let urlString = navigationAction.request.url?.absoluteString
//                
//        processAuthResponse(urlString: urlString!)
//    
//        decisionHandler(.allow)
//    }
//    
//    private func processAuthResponse(urlString: String){
//        if((urlString.hasPrefix(ConstantInfo.redirectURI))){
//            
//            let code = getAuthCode(name: "code", fragment: urlString)
//            
//            if code != nil{
//                print("Granted")
//                print(code!)
//                
//                CurrentSessionManager.authWithCode(code: code!) {
//                    self.dismiss(animated: true, completion: nil)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
//                }
//                
//            }else{
//                print("Denied")
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//    
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//           //print("didReceiveServerRedirectForProvisionalNavigation")
//    }
//
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//           //print("didCommitNavigation - content arriving?")
//    }
//
//    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
//           //print("didFailNavigation")
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        //print("didStartProvisionalNavigation \(String(describing: navigation))")
//        //print(webView.url)
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//           print("didFinishNavigation")
//           webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
//                                      completionHandler: { html, error in
//                                       //print(html)
//           })
//    }
//    
//    private func getAuthCode(name: String, fragment: String) -> String? {
//        let responseString = String(fragment.dropFirst(ConstantInfo.redirectURI.count+2))
//        let pairs = responseString.components(separatedBy: "=")
//
//        if(pairs.first == name){
//            return pairs.last
//        }
//        
//        return nil
//    }
//
//    
//    
//}
