//
//  WebAuthentication.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 05.10.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import WebKit
import CommonCrypto

class WebAuthentication: NSObject {
    
    static var instance = WebAuthentication()
    
    
    
    
    public func processAuthResponse(url: URL){
        
        let urlString = url.absoluteString
        
        if((urlString.hasPrefix(ConstantInfo.redirectURI))){
            
            let result = getAuthCode(fragment: urlString)
            
            if(result["state"] == state){
                
                let code = result["code"]
                
                var data : [String: Bool] = ["isGranted": false]
                
                if code != nil{
                    print("Granted")
                    print(code!)
                    
                    CurrentSessionManager.authWithCode(codeVerifier: codeVerifier, code: code!) {
                        //self.dismiss(animated: true, completion: nil)
                        data["isGranted"] = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil, userInfo: data)
                    
                    }
                }else{
                    print("Denied")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil, userInfo: data)
                    //self.dismiss(animated: true, completion: nil)
                }
            }else{
                print("this")
                AuthorizationClass.auth.sessionManager.application(UIApplication.shared, open: url, options: [:])
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    var codeVerifier = ""
    var codeChallenge = ""
    var state = ""
    
    func getURLString() -> String {
        
        
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
        
        let url = "https://accounts.spotify.com/authorize?client_id=\(ConstantInfo.SpotifyClientID)&redirect_uri=\(ConstantInfo.redirectURI)&code_challenge_method=S256&code_challenge=\(codeChallenge)&state=\(state)&show_dialog=true&response_type=code"

        return url
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
