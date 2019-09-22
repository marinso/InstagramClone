//
//  UserProfileVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {

    var currentUser: User?
    var userFromSearchVC: User?
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = .white
        
        if userFromSearchVC == nil {
            fetchUserData()
        }
    }

    // MARK: - UICollectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        
        if let user = currentUser {
            header.user = user
        } else if let userFromSearchVC = userFromSearchVC {
            header.user = userFromSearchVC
        }
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUID).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            self.currentUser = User(uid: currentUID, dictionary: dictionary)
            
            if let username = self.currentUser?.username {
                self.navigationItem.title = username
            }
            self.collectionView.reloadData()
        }
    }
    
       // MARK: - UserProfileHeader
        
    func handleEditFollowTapped(for header: ProfileHeader) {
        
        guard let user = header.user else { return }
        
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
           // show edit profile vc
            
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
               header.editProfileFollowButton.setTitle("Unfollow", for: .normal)
               user.follow()
           } else {
               header.editProfileFollowButton.setTitle("Follow", for: .normal)
               user.unfollow()
           }
        }
    }
}

 
