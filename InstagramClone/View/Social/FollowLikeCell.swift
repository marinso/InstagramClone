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
            textLabel!.text = username
            detailTextLabel!.text = name
            
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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
       profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 48, height: 48)
       profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       profileImageView.layer.cornerRadius = 48 / 2
       profileImageView.clipsToBounds = true
                      
        addSubview(followButton)
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 90, height: 30)
         
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel!.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y - 2, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        
        textLabel!.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        
        detailTextLabel?.textColor = .lightGray
    }

    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
