//
//  Post.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 09/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation

class Post {
    
    var uid: String!
    var capation: String!
    var likes: Int!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    
    init(uid: String, dictionary: Dictionary<String,AnyObject>) {
        
        self.uid = uid
        
        if let capation = dictionary["capation"] as? String{
            self.capation = capation
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = dictionary["image_url"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["owner_UID"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let creationDate = dictionary["creation_date"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
}
