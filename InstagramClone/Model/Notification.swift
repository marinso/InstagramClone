//
//  Notification.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 29/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation

class Notification {
    
    enum NotificationType: Int, Printable {
        case Like
        case Comment
        case Follow
        
        var description: String {
            switch self {
            case .Like: return " liked your post."
            case .Comment: return " commented your post."
            case .Follow: return " started following you."
            }
        }
        
        init(index :Int) {
            switch index {
            case 0: self = .Like
            case 1: self = .Comment
            case 2: self = .Follow
            default: self = .Like
            }
        }
        
    }
    
    var creationDate:Date!
    var userId: String?
    var postId: String?
    var post: Post?
    var user: User?
    var notificationType: NotificationType?
    var didCheck = false
    
    init(user: User, post: Post? = nil, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let post = post {
            self.post = post
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let type = dictionary["type"] as? Int {
            self.notificationType = NotificationType.init(index: type)
        }
        
        if let userId = dictionary["userId"] as? String {
            self.userId = userId
        }
        
        if let checked = dictionary["checked"] as? Bool {
            
            if checked {
                self.didCheck = true
            } else {
                self.didCheck = false
            }
        }
        
    }
    

    
    
}
