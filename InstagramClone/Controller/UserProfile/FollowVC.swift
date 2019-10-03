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
        return cell
    }
    
    func fetchUsers() {
        
        guard let uid = self.uid  else { return }
        
        var ref: DatabaseReference!
        
        if viewFollowers {
            ref = Database.database().reference().child("user-followers")
        } else {
            ref = Database.database().reference().child("user-following")
        }
        
        ref.child(uid).observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            
            Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictorionary = snapshot.value as? Dictionary<String,AnyObject> else { return }
                
                let user = User(uid: userId, dictionary: dictorionary)
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
}
