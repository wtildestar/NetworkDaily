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
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
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
    
    lazy var googleLoginButton: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 80, width: view.frame.width - 64, height: 50)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
        view.addSubview(googleLoginButton)
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
        
        print("Successfully logged in with facebook...")
        signIntoFirebase()
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
            print("Successfully logged in with our FB user:")
            self.fetchFacebookFields()
        }
    }
    
    private func fetchFacebookFields() {
        // парсим данные полученные из публичного профиля пользователя
        GraphRequest(graphPath: "me", parameters: ["Fields": "id, name, email"]).start { (_, result, error) in
            if let error = error {
                print(error)
                return
            }
            // раскладываем данные по структуре
            if let userData = result as? [String: Any] {
                self.userProfile = UserProfile(data: userData)
                print(userData)
                print(self.userProfile?.email ?? "nil")
                self.saveIntoFirebase()
            }
        }
    }
    
    private func saveIntoFirebase() {
        
        // .currentUser?.uid - идентификатор текущего пользователя
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved user info firebase database")
            self.openMainViewController()
        }
        
    }
    
}

// MARK: - Google SDK
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Failed to log into Google: ", error)
            return
        }
        print("Successfully loged into Gooogle")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Something went wrong with our Google user: ", error)
                return
            }
            print("Successfully logged into Firebase with Google")
            self.openMainViewController()
        }
    }
    
}
