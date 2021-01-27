//
//  ProfileHeader.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/26/20.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        iv.setDimensions(height: 100, width: 100)
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Loading", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor.systemBlue
        button.setHeight(40)
        button.setWidth(frame.width / 2)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.3x3.fill.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.fill.text.grid.1x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let allButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet.below.rectangle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "Background 1")
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 30)
        profileImageView.centerX(inView: self)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 10)
        nameLabel.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 40, paddingRight: 40)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: stack.bottomAnchor, paddingTop: 30)
        editProfileFollowButton.centerX(inView: self)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: editProfileFollowButton.bottomAnchor, paddingTop: 30)
        captionLabel.centerX(inView: self)
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, allButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.fullName
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postsLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
}
