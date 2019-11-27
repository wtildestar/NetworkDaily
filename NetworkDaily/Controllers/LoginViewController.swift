//
//  LoginViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 26/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 360, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    lazy var customFBLoginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 360 + 80, width: view.frame.width - 64, height: 50)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
    }
    
}

// MARK: - FacebookSDK

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        
        guard AccessToken.isCurrentAccessTokenActive else { return }
        
        fetchFacebookFields()
        
        openMainViewController()
        
        print("Successfully logged in with facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    @objc private func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let result = result else { return }
            
            // если пользователь не вошел
            if result.isCancelled { return }
            else {
                self.signIntoFirebase()
                self.fetchFacebookFields()
                self.openMainViewController()
            }
        }
    }
    
    private func signIntoFirebase() {
        // нужно взять текущий токен пользователя и конвертировать в строку
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }
        // передаем полномочия при авторизации ползователя чрезе фейсбук firebase'y
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        // авторизация
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                print("Something went wrong with our facebook user:", error)
                return
            }
            print("Successfully logged in with our FB user:", user!)
        }
    }
    
    private func fetchFacebookFields() {
        GraphRequest(graphPath: "me", parameters: ["Fields": "id, name, email"]).start { (_, result, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let userData = result as? [String: Any] {
                print(userData)
            }
        }
    }
    
}
