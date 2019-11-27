//
//  UserViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 26/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class UserViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
    }
    
}

extension UserViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
        
        openLoginViewController()
    }
    
    private func openLoginViewController() {
        
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                // обращаемся к Main storyboard
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                // Находим LoginViewController по идентификатору
                let loginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                // отображаем созданный loginVC
                self.present(loginVC, animated: true)
                return
            }
        } catch let error {
            print("Failer to sign out with error", error.localizedDescription)
        }
        
//        if !(AccessToken.isCurrentAccessTokenActive) {
//            // открываем LoginViewCOntroller в основном потоке если пользователь не авторизован через facebooksdk
//            DispatchQueue.main.async {
//                // обращаемся к Main storyboard
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                // Находим LoginViewController по идентификатору
//                let loginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
//                // отображаем созданный loginVC
//                self.present(loginVC, animated: true)
//                return
//            }
//        }
    }
    
    
}
