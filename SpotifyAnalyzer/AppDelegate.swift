//
//  AppDelegate.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 17.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //lazy var rootViewController = AuthorizationClass()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("AppDelegate")
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = ViewController()
//        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AuthorizationClass.auth.sessionManager.application(app, open: url, options: options)
        
        print("YVKOBEOBEE")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if (AuthorizationClass.auth.appRemote.isConnected) {
            AuthorizationClass.auth.appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = AuthorizationClass.auth.appRemote.connectionParameters.accessToken {
            AuthorizationClass.auth.appRemote.connect()
        }
    }
}


