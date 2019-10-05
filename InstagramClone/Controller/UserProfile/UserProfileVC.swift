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
   
    var user: User?
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = .white
        
        if user == nil {
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
        
        header.user = self.user
        navigationItem.title = user?.username
        
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            self.user = User(uid: uid, dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }
    }
    
       // MARK: - UserProfileHeader
    
    func handleFollowers(for header: ProfileHeader) {
        let followVC = FollowVC()
        followVC.navigationItem.title = "Followers"
        followVC.viewFollowers = true
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowing(for header: ProfileHeader) {
        let followVC = FollowVC()
        followVC.navigationItem.title = "Following"
        followVC.viewFollowers = false
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
        
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
    
    func handleUserStatus(for header: ProfileHeader) {
        var numberOfFollowers:Int!
        var numberOfFollowing:Int!
        
        guard let uid = header.user?.uid else { return }
        
        Database.database().reference().child("user-followers").child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowers = snapshot.count
            } else {
                numberOfFollowers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers!)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followersLabel.attributedText = attributedText
        }
        
        Database.database().reference().child("user-following").child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            header.followingLabel.attributedText = attributedText
       }
     }
       
}

 
