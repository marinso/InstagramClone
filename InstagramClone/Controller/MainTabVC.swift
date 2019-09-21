//
//  MainTabVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 18/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabVC: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        configureViewControllers()
        checkIfUserIsSignIn()
    }
    
    func configureViewControllers() {
        
        let feedVC = configureNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let notificationsVC = configureNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), rootViewController: NotificationsVC())
        let searchVC = configureNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: SearchVC())
        let uploadPostVC = configureNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: UploadPostVC())
        let userProfileVC = configureNavController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [feedVC, searchVC, uploadPostVC, notificationsVC, userProfileVC]
        tabBar.tintColor = .black
    }
    
    func configureNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    func checkIfUserIsSignIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                
                if #available(iOS 13.0, *) {
                    self.isModalInPresentation = false
                } else {
                    // Fallback on earlier versions
                }
                self.present(UINavigationController(rootViewController: LoginVC()), animated: true, completion: nil)
            }
        }
        
        print("user is sign in")
    }
}
