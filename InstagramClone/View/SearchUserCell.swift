//
//  SearchUserCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 20/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    var user: User? {
        didSet {
            guard let profileImage = user?.profileImgUrl else { return }
            guard let username = user?.username else { return }
            guard let name = user?.fullname else { return }
            
            profileImageView.loadImage(with: profileImage)
            usernameLabel.text = username
            fullNameLabel.text = name
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Username"
        label.textAlignment = .left
        return label
    }()
    
    let fullNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Full name"
        label.textAlignment = .left
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.clipsToBounds = true
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 48).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        addSubview(fullNameLabel)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.centerXAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 46 ).isActive = true
        fullNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
