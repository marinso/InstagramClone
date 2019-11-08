//
//  MessagesController.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 04/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessagesCell"

class MessagesController: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessagesCell.self, forCellReuseIdentifier: reuseIdentifier)
        configureNavigationBar()
        fetchMessages()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessagesCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerId = message.getChatPartnerId()
        Database.fetchUser(with: chatPartnerId) { (user) in
            self.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleNewMessage() {
        let newMessage = NewMessageController()
        newMessage.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessage)
        self.present(navigationController, animated: true)
    }
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Messages"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    // MARK: - API
    
    func fetchMessages() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        USER_MESSAGES_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            USER_MESSAGES_REF.child(currentUid).child(uid).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessage(with: messageId)
            }
        }
    }
    
    private func fetchMessage(with messageId: String) {
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            let chatParterId = message.getChatPartnerId()
            self.messagesDictionary[chatParterId] = message
            self.messages = Array(self.messagesDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    
    
}
