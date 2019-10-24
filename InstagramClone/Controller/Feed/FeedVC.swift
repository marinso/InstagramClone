//
//  FeedVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "FeedCell"

class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        configureNavigation()
        
        if !viewSinglePost {
            updateUserFeeds()
            fetchPosts()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
    
    // MARK: - FeedCellDelegate
    
    func handleConfigureLikesButton(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let postId = post.uid else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in

            if snapshot.hasChild(postId) {
                post.didLike = true
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
            }
        }
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
        guard let post = cell.post else { return }
        
        if post.didLike {
            
            if !isDoubleTap {
                post.adjustLikes(addLike: false) { (likes) in
                    cell.likesLabel.text = "\(likes) likes"
                    cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                }
            }
        } else {
            post.adjustLikes(addLike: true) { (likes) in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likesLabel.text = "\(likes) likes"
            }
        }
    }
    
    func handleUsernameTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = post.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    internal func handleOptionsTapped(for cell: FeedCell) {
        print("options")
    }
    
    internal func handleCommentTapped(for cell: FeedCell) {
        print("comment")
    }
    
    // MARK: - UICollectionViewDataSource

    internal override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    internal override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }

    internal override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if viewSinglePost {
            cell.post = post
        } else {
            cell.post = posts[indexPath.row]
        }
        return cell
    }
    
    // MARK: - Handlers
    
    func handleShowLikes(for cell: FeedCell) {
        guard let postId = cell.post?.uid else { return }
        let followLikeVC = FollowLikeVC()
        followLikeVC.viewingMode = .Likes
        followLikeVC.postId = postId
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: true)
        fetchPosts()
        collectionView.reloadData()
    }
    
    @objc func handleShowMessages() {
        print("show messages")
    }
    
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let navigationController = UINavigationController(rootViewController: LoginVC())
                self.present(navigationController, animated: true, completion: nil)
            } catch {
                print("failed to signout")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        
        if !viewSinglePost {
             navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        self.navigationItem.title = "Instagram"
        
    }
    
    // MARK: - API
    
    private func updateUserFeeds() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let followingUserUid = snapshot.key
            
            USER_POSTS_REF.child(followingUserUid).observe(.childAdded) { (snapshot) in
                let postId = snapshot.key
                
                USER_FEED_REF.child(currentUid).updateChildValues([postId: 1])
            }
        }
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            USER_FEED_REF.child(currentUid).updateChildValues([postId: 1])
        }
    }
    
    private func fetchPosts() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FEED_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            
            Database.fetchPost(with: postId) { (post) in
                self.posts.append(post)
                
                self.posts.sort { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                }
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
}

