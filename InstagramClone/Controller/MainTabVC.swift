//
//  MainTabVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 18/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    let dot = UIView()
    var notificationsIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureViewControllers()
        checkIfUserIsSignIn()
        configureNotificationDot()
        observeNotifications()
    }
    
    func configureNotificationDot() {
        if UIDevice().userInterfaceIdiom == .phone {
            let tabBarHeight = tabBar.frame.height
            
            if UIScreen.main.nativeBounds.height >= 2436 {
                // configure dot for iphone x >=
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6 , height: 6)
            } else {
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - 16, width: 6 , height: 6)
            }
            
            dot.center.x = (view.frame.width / 5 * 3 + (view.frame.width / 5) / 2)
            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha:1 )
            dot.layer.cornerRadius = dot.frame.width / 2
            dot.isHidden = true
            self.view.addSubview(dot)
        }
    }
    
    // MARK: - UITabBar

    func configureViewControllers() {
        
        let feedVC = configureNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let notificationsVC = configureNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), rootViewController: NotificationsVC())
        let searchVC = configureNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: SearchVC())
        let selectImageVC = configureNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let userProfileVC = configureNavController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [feedVC, searchVC, selectImageVC, notificationsVC, userProfileVC]
        tabBar.tintColor = .black
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)

        if index == 2 {
            let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let nav = UINavigationController(rootViewController: selectImageVC)
            present(nav, animated: true)
            return false
        } else if index == 3 {
//            setNotificationToChecked()
            dot.isHidden = true
            return true
        }
        return true
    }

    func configureNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    // MARK: - API
    
    func checkIfUserIsSignIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginVC())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
    
    func observeNotifications() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.notificationsIDs.removeAll()
        
        NOTIFICATIONS_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            let notificationId = snapshot.key
            
            guard let allObject = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObject.forEach { (snapshot) in
                let notificationId = snapshot.key
                
                NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").observeSingleEvent(of: .value) { (snapshot) in
                   guard let checked = snapshot.value as? Int else { return }
                   
                   if checked == 0 {
                       self.dot.isHidden = false
                   } else {
                       self.dot.isHidden = true
                   }
               }
            }
                        
        }
    }
}
