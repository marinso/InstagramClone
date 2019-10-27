//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 26/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            
            guard let user = comment?.user else { return }
            guard let profileImageUrl = user.profileImgUrl else { return }
            guard let username = user.username else { return }
            guard let commentText = comment?.commentText else { return }
            
            let attributtedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
               
            attributtedText.append(NSAttributedString(string: " \(commentText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            
            attributtedText.append(NSAttributedString(string: " 2 days ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))            
            commentTextView.attributedText = attributtedText
            
            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let commentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let separatorView:UIView = {
       let separator = UIView()
        separator.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return separator
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, bottom: nil , left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, bottom: bottomAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 4, paddingLeft: 4, paddingRight: 4, width: 0, height: 0)
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 60, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
