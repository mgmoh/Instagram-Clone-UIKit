//
//  CommentInputAccessoryView.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/28/20.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    func inputeView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let commentTextView: InputTextView = {
       let tv = InputTextView()
        tv.placeholderText = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.setDimensions(height: 50, width: 50)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Actions
    
    @objc func handlePostTapped() {
        delegate?.inputeView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
