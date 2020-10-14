//
//  WebAuthentication.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 05.10.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import CommonCrypto

class WebAuthentication: NSObject {
    
    static var instance = WebAuthentication()
    
    var codeVerifier = ""
    var codeChallenge = ""
    var state = ""
    
    public func processAuthResponse(url: URL){
        
        let urlString = url.absoluteString
        
        if((urlString.hasPrefix(ConstantInfo.redirectURI))){
            
            let result = getAuthCode(fragment: urlString)
            
            if(result["state"] == state){
                
                let code = result["code"]
                
                var data : [String: Bool] = ["isGranted": false]
                
                if code != nil{
                    print("Granted")
                    CurrentSessionManager.authWithCode(codeVerifier: codeVerifier, code: code!) {
                        data["isGranted"] = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil, userInfo: data)
                    }
                }else{
                    print("Denied")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil, userInfo: data)
                }
            }else{
                print("this")
                AuthorizationClass.auth.sessionManager.application(UIApplication.shared, open: url, options: [:])
            }
        }
    }
    
    func getURLString() -> String {
        
        codeVerifier = generateCodeVerifier()
        codeChallenge = generateCodeBuffer(codeVerifier)
        
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

extension WebAuthentication{
    
    fileprivate func generateCodeVerifier() -> String{
        
        var buffer = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let codeVerifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "=", with: "-")
            .trimmingCharacters(in: .whitespaces)
        
        return codeVerifier
    }
    
    fileprivate func generateCodeBuffer(_ codeVerifier: String) -> String{
        let codeVerifierBytes = codeVerifier.data(using: .ascii)!
        var onebuffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        codeVerifierBytes.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(codeVerifierBytes.count), &onebuffer)
        }
        
        let codeChallengeBytes = Data(onebuffer)
        let codeChallenge = codeChallengeBytes.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return codeChallenge
    }
}
