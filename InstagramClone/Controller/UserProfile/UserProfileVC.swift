//
//  UserProfileVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var user: User?
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.backgroundColor = .white
    }

    // MARK: - UICollectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        fetchUserData(header: header)
        return header
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    // MARK: - API
    
    func fetchUserData(header: ProfileHeader) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUID).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            self.user = User(uid: currentUID, dictionary: dictionary)
            
            if let username = self.user?.username {
                self.navigationItem.title = username
            }
            
            header.user = self.user
        }
    }
}
