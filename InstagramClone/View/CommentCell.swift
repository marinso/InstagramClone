//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 26/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "Joker", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributtedText.append(NSAttributedString(string: " Some text comment", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        attributtedText.append(NSAttributedString(string: " 2 days ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributtedText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, bottom: nil , left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        addSubview(commentLabel)
        commentLabel.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        commentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
