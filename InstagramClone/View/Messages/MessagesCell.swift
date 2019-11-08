//
//  MessagesCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 04/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

class MessagesCell: UITableViewCell {
    
    // MARK: - Properties
    
    var message: Message? {
        didSet {
            guard let messageText = message?.messageText else { return }
            detailTextLabel?.text = messageText
            
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: seconds)
            }
            
            configureUserData()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil , left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(timeLabel)
        timeLabel.anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 0, height: 0)
        
        textLabel!.text = "Joker"
        detailTextLabel!.text = "Some test label to see if this works"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel!.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y - 2, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        
        textLabel!.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        
        detailTextLabel?.textColor = .lightGray
    }
    
    // MARK: - Handlers
    
    func configureUserData() {
        guard let chatPartnerId = message?.getChatPartnerId() else { return }
        
        Database.fetchUser(with: chatPartnerId) { (user) in
            self.profileImageView.loadImage(with: user.profileImgUrl)
            self.textLabel?.text = user.username
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
