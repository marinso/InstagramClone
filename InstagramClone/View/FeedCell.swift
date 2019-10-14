//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 13/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
           let iv = CustomImageView()
           iv.backgroundColor = .lightGray
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           return iv
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    let postImageView: CustomImageView = {
       let iv = CustomImageView()
       iv.backgroundColor = .lightGray
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       return iv
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let savePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = " 3 likes"
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        attributtedText.append(NSAttributedString(string: " some test capation for now", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributtedText
        return label
    }()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = " 2 DAYS AGO"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        usernameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(optionsButton)
        optionsButton.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(savePostButton)
        savePostButton.anchor(top: postImageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 20, height: 24)
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: -4, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)

        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
    }
    
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 120, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
