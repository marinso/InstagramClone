//
//  UserProfileVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "UserPostCell"
private let headerIdentifier = "ProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
   
    // MARK: - Properties

    var user: User?
    var posts = [Post]()
    var currentKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = .white
        
        if user == nil {
            fetchUserData()
        }
        
        fetchPosts()
    }

    // MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 9 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.user = self.user
        navigationItem.title = user?.username
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        cell.photoImageView.loadImage(with: posts[indexPath.row].imageUrl)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.post = posts[indexPath.row]
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    // MARK: - UICollecitonFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
    
    func fetchPosts() {
        let uid: String!
        
        if self.user == nil {
            uid = Auth.auth().currentUser?.uid
        } else {
            uid = self.user!.uid
        }
        
        if currentKey == nil {
            
            USER_POSTS_REF.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { (snapshot) in
                    let postId = snapshot.key
                    
                    self.fetchPost(withPostId: postId)
                }
                self.currentKey = first.key
            }
        } else {
            USER_POSTS_REF.child(uid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 7).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { (snapshot) in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                }
                self.currentKey = first.key
            }
        }
    }
    
    func fetchPost(withPostId postId: String) {
        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            
            self.posts.sort { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            }
            self.collectionView.reloadData()
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
      
    
       // MARK: - UserProfileHeader
    
    func handleFollowers(for header: ProfileHeader) {
        let followVC = FollowLikeVC()
        followVC.navigationItem.title = "Followers"
        followVC.viewingMode = .Followers
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowing(for header: ProfileHeader) {
        let followVC = FollowLikeVC()
        followVC.navigationItem.title = "Following"
        followVC.viewingMode = .Following
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
}
