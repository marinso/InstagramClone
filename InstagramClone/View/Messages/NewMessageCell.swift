//
//  NewMessageCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 04/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

   // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImgUrl else { return }
            guard let username = user?.username else { return }
            guard let fullname = user?.fullname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            textLabel?.text = username
            detailTextLabel?.text = fullname
        }
    }
       
   let profileImageView: CustomImageView = {
       let iv = CustomImageView()
       iv.backgroundColor = .lightGray
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       return iv
   }()
       
   // MARK: - Init

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil , left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
   }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       
       textLabel!.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
       
       detailTextLabel!.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y - 2, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
       
       textLabel!.font = UIFont.systemFont(ofSize: 12)
       detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
       
       detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
