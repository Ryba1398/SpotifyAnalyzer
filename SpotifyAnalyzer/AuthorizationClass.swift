//
//  AuthorizationClass.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 19.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

class AuthorizationClass: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

    static var auth = AuthorizationClass()

    lazy var configuration = SPTConfiguration(
        clientID: ConstantInfo.SpotifyClientID,
        redirectURL: URL(string: ConstantInfo.redirectURI)!
    )

    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    private var lastPlayerState: SPTAppRemotePlayerState?

    // MARK: - Actions



//    @objc func didTapDisconnect(_ button: UIButton) {
//        if (appRemote.isConnected) {
//            appRemote.disconnect()
//        }
//    }

    func didTapConnect() {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]

        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .clientOnly)
            
            
            
        }
//        else {
//            // Use this on iOS versions < 11 to use SFSafariViewController
//            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: ViewController())
//        }
    }


    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        //presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
        print("{{{{{{{{{{{{{{{{{{{{{{")
        
        print(error)
        
        print("{{{{{{{{{{{{{{{{{{{{{{")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
       // presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }

    // MARK: - SPTAppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        
        
        
        //updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
    
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        
        if let token = sessionManager.session?.accessToken {
            print(token)
            
            AuthInfo.token = token

            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
        }
        
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
       
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
       
        lastPlayerState = nil
    }

    // MARK: - SPTAppRemotePlayerAPIDelegate

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
       
    }

    // MARK: - Private Helpers

//    private func presentAlertController(title: String, message: String, buttonTitle: String) {
//        DispatchQueue.main.async {
//            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
//            controller.addAction(action)
//            self.present(controller, animated: true)
//        }
//    }
}

