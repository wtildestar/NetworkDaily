//
//  LoginViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 26/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
       let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        if AccessToken.isCurrentAccessTokenActive {
            print("The user is logged in")
        }
        
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
    }

}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        print("Successfully logged in with facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    
}
