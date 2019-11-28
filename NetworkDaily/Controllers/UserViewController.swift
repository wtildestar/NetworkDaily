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
import GoogleSignIn

class UserViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var provider: String?
    private var currentUser: CurrentUser?
    
    lazy var logoutButton: UIButton = {
        let button  = UIButton()
        button.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        button.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
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
        view.addSubview(logoutButton)
    }
    
}

extension UserViewController {
    
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
                    self.currentUser = CurrentUser(uid: uid, data: userData)
                    self.activityIndicator.stopAnimating()
                    self.userNameLabel.isHidden = false
                    print(userData)
                    self.userNameLabel.text = self.getProviderData()
                }) { (error) in
                    print(error)
            }
        }
    }
    
    @objc private func signOut() {
        // providerData: [UserInfo] содержит userID
        if let providerData = Auth.auth().currentUser?.providerData {
            // сделаем перебор массива в цикле
            for userInfo in providerData {
                
                switch userInfo.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("User did log out of facebook")
                    openLoginViewController()
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                    print("User did log out of google")
                    openLoginViewController()
                default:
                    print("User is signed in with \(userInfo.providerID)")
                }
            }
        }
    }
    
    private func getProviderData() -> String {
        var greetings = ""
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                default:
                    break
                }
            }
            greetings = "\(currentUser?.name ?? "Noname") Logged in with \(provider!)"
        }
        return greetings
    }
    
}
