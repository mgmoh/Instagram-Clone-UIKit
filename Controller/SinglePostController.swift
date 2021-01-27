//
//  SinglePostController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/2/20.
//

import UIKit

private let cellIdentifier = "PostCell"
private let headerIdentifier = "PostHeader"
private let reuseIdentifier = "CommentCell"

class SinglePostController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let post: Post
    
    private var comments = [Comment]()
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HIIII")
        commentInputView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Comments"
        collectionView.backgroundColor = UIColor(named: "Background 1")
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    // MARK: - Actions
    
    func fetchComments() {
        CommentService.fetchComments(forPost: post.postId) { (comments) in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SinglePostController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCell
        header.delegate = self
        header.viewModel = PostViewModel(post: post)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 500)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SinglePostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width - 20, height: height)
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension SinglePostController: CommentInputAccessoryViewDelegate {
    func inputeView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        inputView.clearCommentTextView()
        
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        showLoader(true)
        
        CommentService.uploadComment(comment: comment, postId: post.postId, user: currentUser) { (error) in
            self.showLoader(false)
            inputView.clearCommentTextView()
            
            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: currentUser, type: .comment, post: self.post)
        }
    }
}

// MARK: - FeedCellDelegate

extension SinglePostController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = SinglePostController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { (_) in
                print("UNLIKE")
                cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { (_) in
                cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
}
