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

class ViewController: UIViewController {

    let authButton = UIButton().then{
        $0.backgroundColor = UIColor(red: 36/255, green: 212/255, blue: 78/212, alpha: 1.0)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Login", for: .normal)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(passToNextViewController), name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
        
        self.view.addSubview(self.authButton)
        
        authButton.center(in: self.view)
        authButton.width(200)
        authButton.height(50)
        authButton.layer.cornerRadius = 20
        
        authButton.addTarget(self, action: #selector(Authorize), for: .touchUpInside)

    }

    var checkTokenGetting : Bool?
    
    @objc func Authorize(_ sender: UIButton) {
        checkTokenGetting = true
        AuthorizationClass.auth.didTapConnect()
        
    }
    
    @objc func passToNextViewController(){
        if(checkTokenGetting!){
            
            let pvc = PlaylistsTableViewController()
        
            let vc = UINavigationController(rootViewController: pvc)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            
            checkTokenGetting = false
        }

    }
    
}
