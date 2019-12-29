//
//  EditProfileController.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 22/12/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import Firebase

class EditProfileController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    var imageChange = false
    var usernameChange = false
    var userProfileController: UserProfileVC?
    var updatedUsername: String?
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .lightGray
        return image
    }()
    
    let changePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Change", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(changeProfileImage), for: .touchUpInside)
        return btn
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameTextFiled: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        return tf
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let usernameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let fullnameTextFiled: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let fullnameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
   
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureViewControllers()
        usernameTextFiled.delegate = self
        loadUserData()
    }
    
    // MARK: UI
    
    func configureNavigationBar() {
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureViewControllers() {
        let frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 150)
        let containerView = UIView(frame: frame)
        
        containerView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 22, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        containerView.addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        changePhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(seperatorView)
        seperatorView.anchor(top: nil, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(fullnameLabel)
        fullnameLabel.anchor(top: containerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 20, paddingBottom: 12, paddingLeft: 12, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(fullnameTextFiled)
        fullnameTextFiled.anchor(top: containerView.bottomAnchor, bottom: nil, left: fullnameLabel.rightAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: (view.frame.width / 1.68), height: 0)
        
        view.addSubview(usernameTextFiled)
        usernameTextFiled.anchor(top: fullnameTextFiled.bottomAnchor, bottom: nil, left: usernameLabel.rightAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: (view.frame.width / 1.68), height: 0)
        
        view.addSubview(usernameSeperatorView)
        usernameSeperatorView.anchor(top: nil, bottom: usernameTextFiled.bottomAnchor, left: usernameTextFiled.leftAnchor, right: usernameTextFiled.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(fullnameSeperatorView)
        fullnameSeperatorView.anchor(top: nil, bottom: fullnameTextFiled.bottomAnchor, left: fullnameTextFiled.leftAnchor, right: fullnameTextFiled.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    // MARK: - Load Data
    
    func loadUserData() {
        guard let user = self.user else { return }
        
        profileImageView.loadImage(with: user.profileImgUrl)
        usernameTextFiled.text = user.username
        fullnameTextFiled.text = user.fullname
    }
    
    // MARK: - Handlers
    
    @objc func changeProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        updateUsername()
        updateProfileImage()
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func updateProfileImage() {
        
        guard imageChange == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        Storage.storage().reference(forURL: user.profileImgUrl).delete(completion: nil)
        
        let filename = NSUUID().uuidString
        guard let updateProfileImage = profileImageView.image else { return }
        guard let imageData = updateProfileImage.jpegData(compressionQuality: 0.3) else { return }
        
        STORAGE_PROFILE_IMAGES_REF.child(filename).putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            if let error = error {
                print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                return
            }
            
            STORAGE_PROFILE_IMAGES_REF.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                
                USER_REF.child(currentUid).child("profileImageUrl").setValue(profileImageUrl) { (error, ref) in
                    guard let userProfileController = self.userProfileController else { return }
                    userProfileController.fetchUserData()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
    func updateUsername() {
        guard let updatedUsername = self.updatedUsername else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_REF.child(currentUid).child("username").setValue(updatedUsername) { (err, ref) in
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchUserData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            self.imageChange = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let user = self.user else { return }
        
        let trimmedString = usernameTextFiled.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        guard user.username != trimmedString else {
            print("ERROR: You did not change you username")
            usernameChange = false
            return
        }
        
        guard trimmedString != "" else {
            print("ERROR: Please enter a vaild username")
            usernameChange = false
            return
        }
        
        self.updatedUsername = trimmedString?.lowercased()
        self.usernameChange = true
    }
}
