//
//  Protocols.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 22/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: ProfileHeader)
    func handleUserStatus(for header: ProfileHeader)
    func handleFollowers(for header: ProfileHeader)
    func handleFollowing(for header: ProfileHeader)
}

protocol FollowCellDelegate {
    func handleFollowTapped(for cell: FollowLikeCell)
}

protocol FeedCellDelegate {
    func handleUsernameTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool)
    func handleOptionsTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleConfigureLikesButton(for cell: FeedCell)
    func handleShowLikes(for cell: FeedCell)
}
