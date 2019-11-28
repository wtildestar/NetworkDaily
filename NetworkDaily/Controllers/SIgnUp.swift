//
//  SIgnUp.swift
//  NetworkDaily
//
//  Created by wtildestar on 28/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class SIgnUp: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(secondaryColor, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        userNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setContinueButton(enabled: Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func textFieldChanged() {
        guard
            let userName = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
            else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty) && !(userName.isEmpty) &&  confirmPassword == password
        
        setContinueButton(enabled: formFilled)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        let userInfo = notification.userInfo!
        // определяем расположение и габариты клавиатуры
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // новые значения расположения кнопки относительно экрана
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
    }
    
    @objc private func handleSignUp() {
        
    }
    
    
}
