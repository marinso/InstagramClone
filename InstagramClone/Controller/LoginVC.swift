//
//  LoginVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 13/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    let header: UIView = {
        let view = UIView()
        let logo = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logo.contentMode = .scaleToFill
        view.addSubview(logo)
        logo.anchor(top: nil, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.addTarget(self, action:#selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.addTarget(self, action:#selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Login", for: .normal)
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        lb.layer.cornerRadius = 5
        lb.isEnabled = false
        lb.addTarget(self, action: #selector(loginButtonCliced), for: .touchUpInside)
        return lb
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(navigationToSignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // hide navigation
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(header)
        header.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        
        configureViewComponents()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 20, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func configureViewComponents() {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: header.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 140, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 140)
        
    }
    
    @objc func navigationToSignUp() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    @objc func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText
        else {
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            loginButton.isEnabled = false
            return
        }
        
        loginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        loginButton.isEnabled = true
    }
    
    @objc func loginButtonCliced() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, link: password) { (authDataResult, error) in
            if let error = error {
                print("Unable to sign user in with error", error.localizedDescription)
                return
            }
            
            print("success")
        }
    }
}
