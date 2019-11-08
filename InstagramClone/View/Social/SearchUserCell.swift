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
            textLabel!.text = username
            detailTextLabel!.text = name
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel!.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y - 2, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        
        textLabel!.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        
        detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
