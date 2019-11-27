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
import FirebaseDatabase

class UserViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        userNameLabel.isHidden = true
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingUserData()
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
    }
    
    private func fetchingUserData() {
        
        if Auth.auth().currentUser != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference()
            .child("users")
            .child(uid)
                .observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snapshot, _) in // snapshot - данные полученные с директории users.uid:
                    // uid : String , id в модели для парса Int, пожтому создаем новую модель для fetch query
                    guard let userData = snapshot.value as? [String: Any] else { return }
                    let currentUser = CurrentUser(uid: uid, data: userData)
                    self.activityIndicator.stopAnimating()
                    self.userNameLabel.isHidden = false
                    print(userData)
                    self.userNameLabel.text = "\(currentUser?.name ?? "Noname") Logged in with Facebook"
                }) { (error) in
                    print(error)
            }
        }
    }
    
}
