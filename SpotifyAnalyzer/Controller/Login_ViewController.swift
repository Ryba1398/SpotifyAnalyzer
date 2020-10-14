//
//  ViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 17.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var loginView : LoginView?
    var safariViewController : SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(passToNextViewController), name: NSNotification.Name(rawValue: "GotTheToken"), object: nil)
        
        loginView = LoginView(superView: self.view)
        loginView?.authButton.addTarget(self, action: #selector(Authorize), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func Authorize(_ sender: UIButton) {
        if(UIApplication.shared.canOpenURL(NSURL(string:"spotfy:")! as URL)){
            AuthorizationClass.auth.didTapConnect()
        }else{
            let urlString = WebAuthentication.instance.getURLString()
            if let url = URL(string: urlString) {
                let config = SFSafariViewController.Configuration()
                config.barCollapsingEnabled = false
                safariViewController = SFSafariViewController(url: url, configuration: config)
                safariViewController!.delegate = self
                safariViewController!.modalPresentationStyle = .popover
                self.present(safariViewController!, animated: true, completion: nil)
            }
        }
    }
    
    @objc func passToNextViewController(_ notification: NSNotification){
        
        print("Change")
        
        if(notification.userInfo != nil){
            let isGranted = notification.userInfo!["isGranted"] as! Bool

            if(safariViewController != nil){
                safariViewController!.dismiss(animated: true)
            }

            if(isGranted){
                DispatchQueue.main.async {
                    let pvc = PlaylistsTableViewController()
                    pvc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.pushViewController(pvc, animated: true)
                }
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
