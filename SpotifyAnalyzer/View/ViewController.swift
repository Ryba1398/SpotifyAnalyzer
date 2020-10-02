//
//  ViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 17.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Then
import TinyConstraints
import Alamofire
import WebKit

class ViewController: UIViewController {

    let authButton = UIButton().then{
        $0.backgroundColor = UIColor(red: 36/255, green: 212/255, blue: 78/212, alpha: 1.0)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Войти через приложение Spotify", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(passToNextViewController), name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
        
        self.view.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        
        self.view.addSubview(authButton)
        
        authButton.center(in: self.view, offset: CGPoint(x: 0, y: 100))
        authButton.width(300)
        authButton.height(50)
        authButton.layer.cornerRadius = 20
        
        authButton.addTarget(self, action: #selector(Authorize), for: .touchUpInside)

    }
    
    @objc func Authorize(_ sender: UIButton) {
        //AuthorizationClass.auth.didTapConnect()
        
//        print("weewfwef")
//        
//        request("https://accounts.spotify.com/authorize?client_id=5fe01282e44241328a84e7c5cc169165&response_type=code&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback&scope=user-read-private%20user-read-email&state=34fFs29kd09").responseString { response in
        
//        request("https://accounts.spotify.com/authorize?response_type=code&client_id=b225811b88cf4fee81a761a91aa0ad6e&redirect_uri=http%3A%2F%2Flocalhost&scope=user-follow-modify&state=e21392da45dbf4&code_challenge=KADwyz1X~HIdcAG20lnXitK6k51xBP4pEMEZHmCneHD1JhrcHjE1P3yU_NjhBz4TdhV6acGo16PCd10xLwMJJ4uCutQZHw&code_challenge_method=S256").responseString { response in
        

                                let pvc = WebAuthViewController()

                                let vc = UINavigationController(rootViewController: pvc)

                                pvc.presentHtmlPage(html: "")
        //
                                self.present(vc, animated: true, completion: nil)
        
        
        
//        request("https://accounts.spotify.com/authorize",
//                method: .get,
//                parameters: ["client_id": "b225811b88cf4fee81a761a91aa0ad6e", "response_type": "code", "redirect_uri": "spotify-analyzer://spotify-login-callback"]).responseString { response in
//
//
//            do {
//
//
//                print(response)
//
//                let html = response.result.value!
//
//                DispatchQueue.main.async {
//
//                        let pvc = WebAuthViewController()
//
//                        let vc = UINavigationController(rootViewController: pvc)
//
//                            pvc.presentHtmlPage(html: html)
////
//                        self.present(vc, animated: true, completion: nil)
//                }
//
//
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }

    }
    
    
    @objc func passToNextViewController(){
            
            DispatchQueue.main.async {
                
                let pvc = PlaylistsTableViewController()
                
                let vc = UINavigationController(rootViewController: pvc)

                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
        }
    }
}
