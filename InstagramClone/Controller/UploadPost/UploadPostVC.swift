//
//  UploadPostVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 19/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class UploadPostVC: UIViewController {
    
    // MARK: - Properties
    
    var selectedImage: UIImage?
    
    let photoImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let capationTextView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = UIColor.lightGray
        tv.font = UIFont.systemFont(ofSize: 12)
       return tv
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadPhoto()
    }
    
    // MARK: - UI
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 92, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(capationTextView)
        capationTextView.anchor(top: view.topAnchor, bottom: nil, left: photoImageView.rightAnchor, right: view.rightAnchor, paddingTop: 92, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: photoImageView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 40)
    }
    
    func loadPhoto() {
        guard let selectedImage = self.selectedImage else { return }
        self.photoImageView.image = selectedImage
    }

}
