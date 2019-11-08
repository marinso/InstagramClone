//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 28/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: NotificationsVC?
    
    var notification: Notification? {
        didSet {
            guard let user = notification?.user else { return }
            guard let profileImageUrl = user.profileImgUrl else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
                        
            if let post = notification?.post {
                postImageView.loadImage(with: post.imageUrl)
            }
            
            configureNotificationType()
            configureNotificationLabel()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/25, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        tapGesture.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc func handlePostTapped() {
        delegate?.handlePostTapped(for: self)
    }
    
    private func configureNotificationLabel() {
        guard let user = notification?.user else { return }
        guard let username = user.username else { return }
        guard let notificationMessage = notification?.notificationType?.description else { return }
        guard let notificationDate = getNotificationDate() else { return }

        let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(notificationDate).", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        notificationLabel.attributedText = attributedText
    }
    
    private func configureNotificationType() {
                
        guard let user = notification?.user else { return }
        addSubview(notificationLabel)

        if notification?.notificationType != .Follow {
            addSubview(postImageView)
            postImageView.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 40, height: 40)
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            notificationLabel.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: postImageView.leftAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        } else {
            
            addSubview(followButton)
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            followButton.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 90, height: 30)
                        
            
            user.checkIfUserIsFollowed(completion: { (followed) in
                
                if followed {
                    self.followButton.setTitle("Unfollow", for: .normal)
                    self.followButton.setTitleColor(.black, for: .normal)
                    self.followButton.layer.borderWidth = 0.5
                    self.followButton.layer.borderColor = UIColor.lightGray.cgColor
                    self.followButton.backgroundColor = .white
                } else {
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.layer.borderWidth = 0
                    self.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                }
            })
            
            notificationLabel.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: followButton.leftAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        }
        
       
        notificationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func getNotificationDate() -> String? {
        guard let notificationDate = notification?.creationDate else { return nil }
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth ]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: notificationDate, to: now)
    }
}
