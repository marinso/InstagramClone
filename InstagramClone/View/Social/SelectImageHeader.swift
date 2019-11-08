//
//  SelectImageHeader.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 05/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class SelectImageHeader: UICollectionViewCell {
    
    
    let photoImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
   }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
