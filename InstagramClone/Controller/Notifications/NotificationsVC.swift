//
//  NotificationsVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifer = "NotificationCell"

class NotificationsVC: UITableViewController, NotificationCellDelegate {
 
    //MARK: - Properties
    var timer:Timer?
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        navigationItem.title = "Notifications"
        
        tableView.separatorColor = .clear
        
        fetchNotifications()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = notification.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - NotificaitonCellDelegate
    
    func handlePostTapped(for cell: NotificationCell) {
        guard let post = cell.notification?.post else { return }
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.post = post
        navigationController?.pushViewController(feedVC, animated: true)
     }
     
     func handleFollowTapped(for cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            user.unfollow()
            cell.followButton.confiure(didFollow: false)
            
        } else {
            user.follow()
            cell.followButton.confiure(didFollow: true)
        }
     }
     
    // MARK: - Handlers
    
    func handleReloadTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sortNotification), userInfo: nil, repeats: false)
    }
    
    @objc func sortNotification() {
        notifications.sort { (notification1, notification2) -> Bool in
            notification1.creationDate > notification2.creationDate
        }
        tableView.reloadData()
    }
    
    
    // MARK: - API
    
    func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        NOTIFICATIONS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let notificationId = snapshot.key 
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let userId = dictionary["userId"] as? String else { return }
            
            Database.fetchUser(with: userId) { (user) in
                
                if let postId = dictionary["postId"] as? String {
                    
                    Database.fetchPost(with: postId) { (post) in
                        
                        Database.fetchPost(with: postId) { (post) in
                            
                            let notification = Notification(user: user, post: post, dictionary: dictionary)
                            self.notifications.append(notification)
                            self.handleReloadTable()
                        }
                    }
                } else {
                    let notification = Notification(user: user, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                }
            }
            NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").setValue(1)
        }
        
    }

}
