//
//  AuthorizationClass.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 19.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

class AuthorizationClass: NSObject, SPTSessionManagerDelegate {
    
    static var auth = AuthorizationClass()
    
    lazy var configuration = SPTConfiguration(
        clientID: ConstantInfo.SpotifyClientID,
        redirectURL: URL(string: ConstantInfo.redirectURI)!
    )
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    func didTapConnect() {
        
        let scope: SPTScope = []
        
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        }
    }
    
    // MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        CurrentSessionManager.Save(info: session)
        let data : [String: Bool] = ["isGranted": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil, userInfo: data)
    }
}
