//
//  CurrentSessionManager.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 21.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import Alamofire

class CurrentSessionManager  {

    static func Save(info: NewAccessToken){
        AuthInfo.accessToken = info.accessToken
        AuthInfo.refreshToken = info.refreshToken

        let sessionInfo = SessionInfo(status: true, accessToken: info.accessToken, refreshToken: info.refreshToken!)
         SaveData(session: sessionInfo)
    }
    

    static func Save(info: SPTSession){
        AuthInfo.accessToken = info.accessToken
        AuthInfo.refreshToken = info.refreshToken
        
        let sessionInfo = SessionInfo(status: true, accessToken: info.accessToken, refreshToken: info.refreshToken)
        SaveData(session: sessionInfo)
    }
    
    private static func SaveData(session: SessionInfo){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(session), forKey: "tokens")
    }

    static func Load() -> SessionInfo? {
        
        if let data = UserDefaults.standard.value(forKey: "tokens") as? Data {
            let auth = try? PropertyListDecoder().decode(SessionInfo.self, from: data)
            
            AuthInfo.accessToken = auth?.accessToken!
            AuthInfo.refreshToken = auth?.refreshToken!
            
            return auth ?? nil
        }
        return nil
    }
    
    static func refreshToken(refreshToken: String, _ completion: @escaping () -> ()){
        
        let user = ConstantInfo.SpotifyClientID
        let password = ConstantInfo.ClientSecret
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        
        print("reftresh tokens")
        
        request("https://accounts.spotify.com/api/token",
                method: .post,
                parameters: ["grant_type": "refresh_token", "refresh_token": refreshToken],
                headers: ["Authorization": "Basic \(base64Credentials)"]).responseJSON { response in
            do {
                let jsonData = response.data!
                let result = try JSONDecoder().decode(NewAccessToken.self, from: jsonData)
                Save(info: result)
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func authWithCode(codeVerifier: String, code: String, _ completion: @escaping () -> ()){
        
        let user = ConstantInfo.SpotifyClientID
        let password = ConstantInfo.ClientSecret
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        
        request("https://accounts.spotify.com/api/token",
                method: .post,
                parameters: ["grant_type": "authorization_code", "code": code, "redirect_uri": ConstantInfo.redirectURI, "code_verifier": codeVerifier],
                headers: ["Authorization": "Basic \(base64Credentials)"]).responseJSON { response in
            do {
                let jsonData = response.data!
                
                print(response.description)
                
                let result = try JSONDecoder().decode(NewAccessToken.self, from: jsonData)
                Save(info: result)
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }

    }
    
    
    
}
