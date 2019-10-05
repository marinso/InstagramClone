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

private let reuseIdentifier = "FollowCell"

class FollowVC: UITableViewController {
    
    var viewFollowers = false
    var uid: String?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        
        fetchUsers()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func handleFollowTapped(for cell: FollowCell) {
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
    
    func fetchUsers() {
        
        guard let uid = self.uid  else { return }
        
        var ref: DatabaseReference!
        
        if viewFollowers {
            ref = Database.database().reference().child("user-followers")
            print("viewfollowers")
        } else {
            ref = Database.database().reference().child("user-following")
            print("viewfollowing")
        }
        
        ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach { (snapshot) in
                
                let userId = snapshot.key
                
                 Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                    guard let dictorionary = snapshot.value as? Dictionary<String,AnyObject> else { return }
                    let user = User(uid: userId, dictionary: dictorionary)
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
        print(users.count)
    }
    
}
