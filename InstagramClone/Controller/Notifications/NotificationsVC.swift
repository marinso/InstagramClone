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
    private var timer:Timer?
    private var currentKey: String?
    private var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        navigationItem.title = "Notifications"
        
        tableView.separatorColor = .clear
        
        fetchNotifications()
    }

    // MARK: - Table view data source

    internal override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notifications.count > 19 {
            if indexPath.item == notifications.count-1 {
                fetchNotifications()
            }
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = notification.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - NotificaitonCellDelegate
    
    internal func handlePostTapped(for cell: NotificationCell) {
        guard let post = cell.notification?.post else { return }
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        feedVC.post = post
        navigationController?.pushViewController(feedVC, animated: true)
     }
     
    internal func handleFollowTapped(for cell: NotificationCell) {
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
    
    private func handleReloadTable() {
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
    
    private func fetchNotification(withNotificationId notificationId: String, dataSnapshot snapshot: DataSnapshot) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
        guard let userId = dictionary["userId"] as? String else { return }
        
        Database.fetchUser(with: userId) { (user) in
            
            if let postId = dictionary["postId"] as? String {
                                    
                Database.fetchPost(with: postId) { (post) in
            
                    let notification = Notification(user: user, post: post, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                }
            } else {
                let notification = Notification(user: user, dictionary: dictionary)
                self.notifications.append(notification)
                self.handleReloadTable()
            }
        }
        NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").setValue(1)
    }
    
    private func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if currentKey == nil {
          
            NOTIFICATIONS_REF.child(currentUid).queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { (snapshot) in
                    let notificationId = snapshot.key
                    self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                }
                self.currentKey = first.key
            })
        } else {
            NOTIFICATIONS_REF.child(currentUid).queryOrderedByKey().queryEnding(atValue: currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach { (snapshot) in
                    let notificationId = snapshot.key
                    
                    if notificationId != self.currentKey {
                        self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                    }
                }
                self.currentKey = first.key
            }
        }
    }
}
