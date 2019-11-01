//
//  FollowCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 01/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth

class FollowLikeCell: UITableViewCell {
    
    var delegate: FollowLikeVC?
    
    var user: User? {
        didSet {
            guard let profileImage = user?.profileImgUrl else { return }
            guard let username = user?.username else { return }
            guard let name = user?.fullname else { return }
            
            profileImageView.loadImage(with: profileImage)
            usernameLabel.text = username
            fullNameLabel.text = name
            
            if user!.uid == Auth.auth().currentUser?.uid {
                followButton.isHidden = true
            }
            
            user?.checkIfUserIsFollowed(completion: { (followed) in
                
                if followed {
                    self.followButton.confiure(didFollow: true)
                } else {
                    self.followButton.confiure(didFollow: false)
                }
            })
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
    
    lazy var followButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
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
               
        addSubview(followButton)
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 90, height: 30)
         
    }
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
