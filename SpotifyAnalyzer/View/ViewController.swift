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
        
        let pvc = WebAuthViewController()
        let vc = UINavigationController(rootViewController: pvc)
        pvc.presentHtmlPage(html: "")
        self.present(vc, animated: true, completion: nil)
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
