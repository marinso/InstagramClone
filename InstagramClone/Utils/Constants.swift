//
//  Constants.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 05/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()

let USER_REF = DB_REF.child("users")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POST_REF = DB_REF.child("posts")
let USER_POSTS_REF = DB_REF.child("user-posts")

let USER_FEED_REF = DB_REF.child("user-feed")
