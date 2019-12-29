//
//  CommentInputTextView.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 27/12/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
//        label.text = "Enter comment..."
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleInputTextChange), name: .UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleInputTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
