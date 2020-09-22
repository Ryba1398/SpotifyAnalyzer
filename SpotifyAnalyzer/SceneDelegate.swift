//
//  SceneDelegate.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 17.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var playlistsViewController: PlaylistsTableViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
          guard let windowScene = (scene as? UIWindowScene) else { return }
        

         
        if((CurrentSessionManager.Load()?.status) != nil ){  //
            
            CurrentSessionManager.refreshToken(refreshToken: AuthInfo.refreshToken!) { refreshedTokens in
            
                self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                self.window?.windowScene = windowScene
                self.window?.rootViewController = PlaylistsTableViewController()
                self.window?.makeKeyAndVisible()
            }
        }else{
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = ViewController()
            window?.makeKeyAndVisible()
        }
        

        
    }

    
     func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {

         print("Opened url")
         guard let url = URLContexts.first?.url else {
             return
         }
        
        AuthorizationClass.auth.sessionManager.application(UIApplication.shared, open: url, options: [:])
     }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

