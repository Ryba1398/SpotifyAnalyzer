//
//  ViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 17.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

import Alamofire
import WebKit
import CommonCrypto
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var loginView : LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(passToNextViewController), name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
        
        loginView = LoginView(superView: self.view)
        loginView?.authButton.addTarget(self, action: #selector(Authorize), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
     var vc : SFSafariViewController?
    
    @objc func Authorize(_ sender: UIButton) {
        
        
//        let pvc = WebAuthViewController()
//        let vc = UINavigationController(rootViewController: pvc)
//        self.present(vc, animated: true, completion: nil)

       
        
//        
        let urlString = WebAuthentication.instance.getURLString()


        if let url = URL(string: urlString) {

            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = false

            vc = SFSafariViewController(url: url, configuration: config)
           // vc.delegate = self

            vc!.delegate = self

            vc!.modalPresentationStyle = .popover

            //vc.delegate = self

            self.present(vc!, animated: true, completion: nil)
        }
        
        
//

//        if(UIApplication.shared.canOpenURL(NSURL(string:"spotify:")! as URL)){
//            AuthorizationClass.auth.didTapConnect()
//        }else{
//            let pvc = WebAuthViewController()
//            let vc = UINavigationController(rootViewController: pvc)
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    
    @objc func passToNextViewController(_ notification: NSNotification){
        
        print("Change")
        
        if(notification.userInfo != nil){
            let isGranted = notification.userInfo!["isGranted"] as! Bool
        
            
            if(self.presentedViewController == vc){
                vc!.dismiss(animated: true)
            }
            
            
            if(isGranted){
                DispatchQueue.main.async {
                    
                    let pvc = PlaylistsTableViewController()
                    pvc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.pushViewController(pvc, animated: true)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                 
                 let pvc = PlaylistsTableViewController()
                 pvc.modalPresentationStyle = .overFullScreen
                 self.navigationController?.pushViewController(pvc, animated: true)
             }
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        print("finish")
        
        controller.dismiss(animated: true)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL){
        print("Change url")
    }

}
