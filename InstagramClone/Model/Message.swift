//
//  Message.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 05/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import Firebase

class Message {
    var messageText: String!
    var fromId: String!
    var toId: String!
    var creationDate: Date!
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        if let messageText = dictionary["message_text"] as? String {
            self.messageText = messageText
        }
        
        if let fromId = dictionary["from_id"] as? String {
            self.fromId = fromId
        }
        
        if let toId = dictionary["to_id"] as? String {
            self.toId = toId
        }
        
        if let creationDate = dictionary["creation_date"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func getChatPartnerId() -> String {
        guard let currentId = Auth.auth().currentUser?.uid else { return "" }
        
        return fromId == currentId ? toId : fromId
    }
}
