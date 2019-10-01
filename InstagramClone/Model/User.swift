//
//  User.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 20/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//
import Firebase

class User {
    
    var username:String!
    var fullname: String!
    var profileImgUrl: String!
    var uid: String!
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let fullname = dictionary["name"] as? String {
            self.fullname = fullname
        }
        if let profileImgUrl = dictionary["profileImageUrl"] as? String {
            self.profileImgUrl = profileImgUrl
        }
    }
    
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = uid else { return }
        
        self.isFollowed = true
        
        Database.database().reference().child("user-followers").child(currentUid).updateChildValues([uid: 1])
        Database.database().reference().child("user-following").child(uid).updateChildValues([currentUid: 1])
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = uid else { return }
               
        self.isFollowed = false
        
        Database.database().reference().child("user-followers").child(currentUid).removeValue()
        Database.database().reference().child("user-following").child(uid).removeValue()
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) -> ()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("user-followers").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(self.uid) {
                self.isFollowed = true
                completion(true)
            } else {
                self.isFollowed = false
                completion(false)
            }
        }
    }
}
