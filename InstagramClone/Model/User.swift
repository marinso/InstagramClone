//
//  User.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 20/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

class User {
    
    var username:String!
    var fullname: String!
    var profileImgUrl: String!
    var uid: String!
    
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
}
