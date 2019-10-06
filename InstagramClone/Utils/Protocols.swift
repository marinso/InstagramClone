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
    func handleFollowTapped(for cell: FollowCell)
}