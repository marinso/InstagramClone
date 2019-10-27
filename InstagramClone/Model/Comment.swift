//
//  Comment.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 26/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    var userId: String?
    var commentText: String?
    var creationDate: Date?
    var user: User?
    
    init(user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let commentText = dictionary["commentText"] as? String {
            self.commentText = commentText
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
}
