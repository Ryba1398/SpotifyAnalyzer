//
//  LoggingClass.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 13.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import Alamofire

class LoggingClass {
    
//    let login = LoginTextField.text!
//    let password = PasswordTextField.text!
    let parameters = ["email": "rubs1998@gmail.com", "password": "buxviz-zegwIq-7jywni"] as [String : Any]
    
//    request("https://event-admin.tapir.ws/api/login", method: .post, parameters: parameters, headers: nil).responseJSON { response in
//        
//        do {
//            let jsonData = response.data!
//            
//            let otvet = try JSONDecoder().decode(AuthResponse.self, from: jsonData)
//            let token = otvet.accessToken
//            let deathTime  = NSDate().timeIntervalSince1970 + Double(otvet.expiresIn)
//            
//            RequestInfo.header["AccessToken"]  = token
//            
//            DataManager().isAppAuthorized = true
//            let authInfo = AuthInfo(status: true, login: login, password: password, token: token, deathTime: deathTime)
//            DataManager().SaveData(input: authInfo)
//            
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        } catch {
//            print(error.localizedDescription)
//            
//             PopUpViewController.ShowErrorView(message: "Неправильный логин или пароль" , parent: self, hideMessage: true)
//            
//            //self.ShowErrorView(message: "Неправильный логин или пароль")
//        }
//    }
    
}
