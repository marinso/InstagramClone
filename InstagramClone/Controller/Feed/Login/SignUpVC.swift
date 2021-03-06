//
//  SignUpVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 13/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    
    let addPhotoButton:UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.addTarget(self, action: #selector(handleAddAvatar), for: .touchUpInside)
        return btn
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor =  UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(clickedSignUp), for: .touchUpInside)
        return btn
    }()
    
    let alreadyHaveAccountButton: UIButton = {
       let btn = UIButton(type: .system)
        let titleAttributes = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        titleAttributes.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        btn.setAttributedTitle(titleAttributes, for: .normal)
        btn.addTarget(self, action: #selector(navigationToSignIn), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        view.backgroundColor = .white
        view.addSubview(addPhotoButton)
        
        addPhotoButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 60, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 140, height: 140)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewComponents()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 20, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func configureViewComponents() {
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, usernameTextField, passwordTextField, signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: addPhotoButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 240)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picture = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return }
        
        imageSelected = true
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.size.width / 2
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.setImage(picture.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func navigationToSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clickedSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let fullName = fullNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                return
            }
            
            guard let image = self.addPhotoButton.imageView?.image else { return }
            guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    guard let profileImageUrl = downloadURL?.absoluteString else {
                        print("DEBUG: Profile image url is nil")
                        return
                    }
                    
                    guard let uid = authResult?.user.uid else { return }
                    
                    let dictionaryValues = ["name": fullName,
                                            "username": username,
                                            "profileImageUrl": profileImageUrl]
                    
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("DEBUG: Failed saving data to firebase", error.localizedDescription)
                            return
                        }
                        
                        print("Success")
                    })
                    
                    guard (UIApplication.shared.keyWindow?.rootViewController as? MainTabVC) != nil else { return }
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    
    @objc func handleAddAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true)
    }
    
    @objc func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText,
            usernameTextField.hasText,
            fullNameTextField.hasText,
            imageSelected == true
        else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
}
