//
//  Post.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 09/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Firebase
import Foundation

class Post {
    
    var uid: String!
    var user: User!
    var capation: String!
    var likes: Int!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var didLike = false
    
    init(uid: String, user: User, dictionary: Dictionary<String,AnyObject>) {
        
        self.uid = uid
        
        self.user = user
        
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
    
    func adjustLikes(addLike: Bool, completion: @escaping(Int)->() ) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.uid else { return }

        if addLike {
            
            USER_LIKES_REF.child(currentUid).updateChildValues([postId: 1]) { (err, ref) in
                POST_LIKES_REF.child(self.uid).updateChildValues([currentUid: 1]) { (err, ref) in
                  self.likes += 1
                  self.didLike = true
                  completion(self.likes)
                  self.updateLikesInDatabase()
                  self.sendNotificationToServer()
                }
                
            }
            
        } else {
            guard likes > 0 else { return }
            
            USER_LIKES_REF.child(currentUid).child(postId).observeSingleEvent(of: .value) { (snapshot) in

               guard let notificationId = snapshot.value as? String else { return }

                NOTIFICATIONS_REF.child(self.ownerUid).child(notificationId).removeValue { (error, ref) in
                    
                    USER_LIKES_REF.child(currentUid).child(postId).removeValue { (err, ref) in

                        POST_LIKES_REF.child(self.uid).child(currentUid).removeValue { (err, ref) in
                            self.likes -= 1
                            self.didLike = false
                            completion(self.likes)
                            self.updateLikesInDatabase()
                        }
                    }
                }
           }
        }
        
    }
    
    private func sendNotificationToServer() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        if currentUid != self.ownerUid {
            let values = ["checked": 0,
                          "creationDate": creationDate,
                          "userId": currentUid,
                          "type": LIKE_INT_VALUE,
                          "postId": uid ] as [String : Any]
            
            let notificationRef = NOTIFICATIONS_REF.child(self.ownerUid).childByAutoId()
            notificationRef.updateChildValues(values) { (error, ref) in
                USER_LIKES_REF.child(currentUid).child(self.uid).setValue(notificationRef.key)
            }
        }
    }
    
    private func updateLikesInDatabase() {
        POST_REF.child(uid).child("likes").setValue(likes)
    }
}
