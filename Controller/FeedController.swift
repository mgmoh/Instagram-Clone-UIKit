//
//  FeedController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit
import Firebase
import PopMenu

private let reuseIdentifier = "Cell"
private let headerIdentifier = "HeaderCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var currentGame: CurrentGameCell?
    
    private lazy var leaderboardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)), for: .normal)
        button.addTarget(self, action: #selector(handleLeaderboardButton), for: .touchUpInside)
        //button.sizeToFit()
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)), for: .normal)
        button.addTarget(self, action: #selector(handleMessagesButton), for: .touchUpInside)
        button.startAnimatingPressActions()
        //button.sizeToFit()
        return button
    }()
    
    // MARK: - Lifecycle
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchPosts()
        
        if post != nil {
            checkIfUserLikedPosts()
        }
    }
    
    // MARK: - Actions
    
    func presentMenu() {
        let menuViewController = PopMenuViewController(sourceView: currentGame, actions: [
            PopMenuDefaultAction(title: "Your turn", image: UIImage(systemName: "crown")),
            PopMenuDefaultAction(title: "Their turn", image: UIImage(systemName: "crown"))
        ])
        menuViewController.appearance.popMenuActionHeight = 55
        menuViewController.appearance.popMenuItemSeparator = .fill()
        //menuViewController.appearance.popMenuBackgroundStyle = .blurred(.systemUltraThinMaterialDark)
        
        
        present(menuViewController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        //posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleLeaderboardButton() {
        print("DEBUG: Leaderboard button pressed")
    }
    
    @objc func handleMessagesButton() {
        let controller = ConversationsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTapUserGame() {
        print("TAPPED USER GAME")
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }
        PostService.fetchFeedPosts { (posts) in
            self.posts = posts
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.collectionView.refreshControl?.endRefreshing()
            }
            self.checkIfUserLikedPosts()
        }
    }
    
    func checkIfUserLikedPosts() {
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { (didLike) in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { (post) in
                PostService.checkIfUserLikedPost(post: post) { (didLike) in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = UIColor(named: "Background 1")
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: view.frame.height))
        titleLabel.text = "Notstagram"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 24)
        navigationItem.titleView = titleLabel
        navigationItem.backButtonDisplayMode = .minimal
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(CurrentGamesCollectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton)]
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CurrentGamesCollectionCell
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
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

// MARK: - CurrentGamesCollectionCellDelegate

extension FeedController: CurrentGamesCollectionCellDelegate {
    func currentGameCell(_ currentGameCell: CurrentGamesCollectionCell, _ currentGame: CurrentGameCell, didTapUser bool: Bool) {
        self.currentGame = currentGame
        presentMenu()
    }
}
