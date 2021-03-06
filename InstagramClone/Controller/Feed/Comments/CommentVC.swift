//
//  CommentVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 26/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let identifier = "commentCell"

class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var post: Post?
    var comments = [Comment]()
    
    lazy var containerView: CommentInputAccesoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = CommentInputAccesoryView(frame: frame)
        containerView.delegate = self
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        navigationItem.title = "Comments"

        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: identifier)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.row]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        
        handleHashtagTapped(forCell: cell)
        handleMentionTapped(forCell: cell)
        
        return cell
    }
    
    // MARK: - Handlers
    
    private func handleMentionTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleMentionTap { (username) in
            self.getMentionedUser(withUsername: username)
        }
    }
    
    private func handleHashtagTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleHashtagTap { (hashtag) in
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    // MARK: - API
    
    
    private func fetchComments() {
        
        guard let postId = self.post?.uid else { return }
        COMMENT_REF.child(postId).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary <String, AnyObject> else { return }
            guard let userId = dictionary["userId"] as? String else { return }
            
            Database.fetchUser(with: userId) { (user) in
              let comment = Comment.init(user: user, dictionary: dictionary)
              self.comments.append(comment)
              self.collectionView.reloadData()
            }
        }
    }
    
    func uploadCommentNotificationToServer() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.uid else { return }
        guard let userId = self.post?.ownerUid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
         let values = ["checked": 0,
                                 "creationDate": creationDate,
                                 "userId": currentUid,
                                 "type": COMMENT_INT_VALUE,
                                 "postId": postId ] as [String : Any]
        
        if userId != currentUid {
            NOTIFICATIONS_REF.child(userId).childByAutoId().updateChildValues(values)
        }
    }
}

extension CommentVC: CommentInputAcessoryViewDelegate {
    func didSubmit(forComment comment: String) {
        
        guard let postId = post?.uid else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)

        let values = ["commentText": comment,
                     "creationDate": creationDate,
                     "userId": userId] as [String : Any]

        COMMENT_REF.child(postId).childByAutoId().updateChildValues(values) { (ref, err) in
            self.uploadCommentNotificationToServer()
        
            if comment.contains("@") {
                self.uploadMentionNotification(for: postId, with: comment, isForComment: true)
            }
            
            self.containerView.clearCommentTextView()
        }
    }
}
