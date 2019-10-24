//
//  FollowVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 01/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "FollowLikeCell"

class FollowLikeVC: UITableViewController {
    
    enum ViewingMode: Int {
        case Following
        case Followers
        case Likes
        
        init(index: Int) {
            switch index {
            case 0: self = .Following
            case 1: self = .Followers
            case 2: self = .Likes
            default: self = .Following
            }
        }
    }
    
    var viewingMode: ViewingMode!
    var uid: String?
    var users = [User]()
    var postId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowLikeCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        
        configureNavigationTitle()
        fetchUsers()
        
        tableView.separatorColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowLikeCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    open func handleFollowTapped(for cell: FollowLikeCell) {
        guard let user = cell.user else { return }
        
        if user.isFollowed {
            
            user.unfollow()
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
        } else {
            
            user.follow()
            cell.followButton.setTitle("Unfollow", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
    }
    
    // MARK: - Handlers
    
    private func configureNavigationTitle() {
        guard let viewingMode = self.viewingMode else { return }

        switch viewingMode {
        case .Following: navigationItem.title = "Following"
        case .Followers: navigationItem.title = "Followers"
        case .Likes: navigationItem.title = "Likes"
        }

    }
    
    // MARK: - API
    
    private func getDadabaseReference() -> DatabaseReference? {
        guard let viewingMode = self.viewingMode else { return nil }
        
        switch  viewingMode {
        case .Followers: return USER_FOLLOWER_REF
        case .Following: return USER_FOLLOWING_REF
        case .Likes: return POST_LIKES_REF
        }
    }
    
    private func fetchUser(with uid:String) {
        Database.fetchUser(with: uid) { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    private func fetchUsers() {
        guard let viewingMode = self.viewingMode else { return }
        guard let ref = getDadabaseReference() else { return }

        switch viewingMode {
        case .Followers, .Following: fetchFollowUsers(with: ref)
        case .Likes: fetchLikesUsers(with: ref)
        }
        
        
    }
    
    private func fetchFollowUsers(with ref: DatabaseReference) {
        guard let uid = self.uid  else { return }

        ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach { (snapshot) in
            
                let userId = snapshot.key
                self.fetchUser(with: userId)
            }
        }
    }
    
    private func fetchLikesUsers(with ref: DatabaseReference) {
        guard let postId = self.postId else { return }
        ref.child(postId).observe(.childAdded) { (snapshot) in
            
            let uid = snapshot.key
            
            self.fetchUser(with: uid)
        }
    }
    
}
