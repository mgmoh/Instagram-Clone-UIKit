//
//  FeedCell.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit

protocol FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: FeedCellDelegate?
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 25
        iv.image = #imageLiteral(resourceName: "test")
        return iv
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 30, width: 30)
        iv.layer.cornerRadius = 30 / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let circleLabel: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "circlebadge.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 4, weight: .regular))
        iv.tintColor = .lightGray
        return iv
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapExpand), for: .touchUpInside)
        return button
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "background3")
        
        layer.cornerRadius = 25
        
        // Post Image
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, width: UIScreen.main.bounds.width - 20, height: 400)
        postImageView.centerX(inView: self)
        
        // Profile Image
        addSubview(profileImageView)
        profileImageView.anchor(top: postImageView.bottomAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 12)
        profileImageView.setDimensions(height: 30, width: 30)
        profileImageView.layer.cornerRadius = 30 / 2
        
        // Username
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        //Like Button
        addSubview(likeButton)
        likeButton.anchor(top: postImageView.bottomAnchor, right: rightAnchor, paddingTop: 9, paddingRight: 12)
        
        // Comment Button
        addSubview(commentButton)
        commentButton.anchor(top: postImageView.bottomAnchor, right: likeButton.leftAnchor, paddingTop: 9, paddingRight: 12)
        
        // Caption Label
        addSubview(captionLabel)
        captionLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 5, paddingRight: 12)
        
        // Post Time Label
        addSubview(postTimeLabel)
        postTimeLabel.anchor(left: profileImageView.leftAnchor, bottom: bottomAnchor, paddingLeft: 5, paddingBottom: 12)
        
        // Circle Label
        addSubview(circleLabel)
        circleLabel.centerY(inView: postTimeLabel, leftAnchor: postTimeLabel.rightAnchor, paddingLeft: 6)
        
        // Likes Label
        addSubview(likesLabel)
        likesLabel.centerY(inView: circleLabel, leftAnchor: circleLabel.rightAnchor, paddingLeft: 6)
        
        // Expand Label
        addSubview(expandButton)
        expandButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func showUserProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    
    @objc func didTapComments() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapExpand() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageUrl)
        captionLabel.text = viewModel.caption
        
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        likesLabel.text = viewModel.likesLabelText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        postTimeLabel.text = viewModel.timestampString
    }
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameButton, commentButton, likeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: frame.width, height: 50)
    }
}
