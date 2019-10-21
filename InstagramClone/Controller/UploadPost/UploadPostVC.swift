//
//  UploadPostVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UploadPostVC: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    var selectedImage: UIImage?
    
    let photoImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let capationTextView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = UIColor.lightGray
        tv.font = UIFont.systemFont(ofSize: 12)
       return tv
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        capationTextView.delegate = self
        configureUI()
        loadPhoto()
    }
    
    // MARK: - UI
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 92, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(capationTextView)
        capationTextView.anchor(top: view.topAnchor, bottom: nil, left: photoImageView.rightAnchor, right: view.rightAnchor, paddingTop: 92, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: photoImageView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 40)
    }
    
    func loadPhoto() {
        guard let selectedImage = self.selectedImage else { return }
        self.photoImageView.image = selectedImage
    }
    
    // MARK: - Handlers
    
    func upadateUserFeeds(with postId:String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let values = [postId:1]
        
        USER_FOLLOWER_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let followerUid = snapshot.key
            USER_FEED_REF.child(followerUid).updateChildValues(values)
        }
        
        USER_FEED_REF.child(currentUid).updateChildValues(values)
    }
    
    @objc func handleSharePost() {

        guard
            let capation = capationTextView.text,
            let photo = photoImageView.image,
            let currentUid = Auth.auth().currentUser?.uid else { return }
        
        guard let uploatData = photo.jpegData(compressionQuality: 0.5) else { return }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post_images").child(filename)
        
        storageRef.putData(uploatData, metadata: nil) { (metadata, error ) in
            if let error = error {
                print("Failed to upload image: ", error.localizedDescription)
            }
            
            storageRef.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                
                let values = [
                    "capation": capation,
                    "image_url": profileImageUrl,
                    "likes": 0,
                    "owner_UID": currentUid,
                    "creation_date": creationDate
                    ] as [String: Any]
                
                let postId = NSUUID().uuidString
                
                POST_REF.child(postId).updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let error = error {
                        print("Failet to update child values", error.localizedDescription)
                    }
                    
                    USER_POSTS_REF.child(currentUid).updateChildValues([postId: 1])
                    
                    self.upadateUserFeeds(with: postId)
                    
                    self.dismiss(animated: true, completion:  {
                        self.tabBarController?.selectedIndex = 0
                    })
                })
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        shareButton.backgroundColor = UIColor(red: 17/255, green: 153/255, blue: 237/255, alpha: 1)
        shareButton.isEnabled = true
    }

}
