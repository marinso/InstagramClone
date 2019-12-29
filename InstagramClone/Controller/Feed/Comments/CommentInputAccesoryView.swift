//
//  CommentInputAccesoryView.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 27/12/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class CommentInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    var delegate: CommentInputAcessoryViewDelegate?
    
    private let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUploadComment), for: .touchUpInside)
        return button
    }()
    
    private let separatorView:UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return separator
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 50, height: 50)

        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(separatorView)
        separatorView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func clearCommentTextView() {
        commentTextView.placeholderLabel.isHidden = true
        commentTextView.text = nil
    }
    
    // MARK: - Handlers
    
    @objc private func handleUploadComment() {
        guard let comment = commentTextView.text else { return }
        delegate?.didSubmit(forComment: comment)
    }
}
