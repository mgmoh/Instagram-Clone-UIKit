//
//  ProfileController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit
import Firebase

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: User {
        didSet { collectionView.reloadData() }
    }
    private var posts = [Post]()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(named: "Background 1")
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    // MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { (stats) in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { (posts) in
            self.posts = posts
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.collectionView.refreshControl?.endRefreshing()
            }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to signout user.")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = user.username
        navigationItem.backButtonDisplayMode = .minimal
        //collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    func showEditProfileController() {
        let controller = EditProfileController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SinglePostController(post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        if user.isCurrentUser {
            showEditProfileController()
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { (error) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { (error) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(toUid: user.uid, fromUser: currentUser, type: .follow)
            }
        }
    }
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowersFor user: User) {
        let controller = SearchController(config: .followers(user.uid))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowingFor user: User) {
        let controller = SearchController(config: .following(user.uid))
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}
