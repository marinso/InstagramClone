//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            if let fullname = user?.fullname {
                nameLabel.text = fullname
            }
            print(user?.fullname)
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 16, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 16, paddingBottom: 0, paddingLeft: 14, paddingRight: 0, width: 0, height: 0)
        
        configureUserStats()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, bottom: nil, left: postsLabel.leftAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 8, paddingRight: 12, width: 0, height: 30)
        
        configureTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUserStats() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 50)
    }
    
    func configureTabBar() {
        let topDivider = UIView()
        let bottomDivider = UIView()
        topDivider.backgroundColor = .lightGray
        bottomDivider.backgroundColor = .lightGray
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(stackView)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        stackView.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        topDivider.anchor(top: stackView.topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: stackView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
}
