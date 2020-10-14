//
//  LoginView.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 13.10.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Then
import TinyConstraints

class LoginView: UIView {
    
    let authButton = UIButton().then{
        $0.backgroundColor = UIColor(red: 36/255, green: 212/255, blue: 78/212, alpha: 1.0)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Войти через приложение Spotify", for: .normal)
    }
    
    init(superView: UIView) {
        super.init(frame: UIScreen.main.bounds)
        superView.addSubview(self)
        
        self.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        self.addSubview(authButton)
    }
    
    fileprivate func addConstraints(){
        authButton.center(in: self, offset: CGPoint(x: 0, y: 100))
        authButton.width(300)
        authButton.height(50)
        authButton.layer.cornerRadius = 20
    }
    
}
