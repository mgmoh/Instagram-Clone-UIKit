//
//  MainTabController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit
import Firebase
import YPImagePicker
import BLTNBoard

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private var gameType: String?
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = PickGameBLTNItem(title: "Pick a Game")
        
        item.delegate = self
        
        item.actionHandler = {_ in
            self.didTapBoardContinue()
        }
        
        item.alternativeHandler = {_ in
            self.didTapBoardCancel()
        }
        
        item.appearance.actionButtonColor = UIColor(named: "color3")!
        
        let item2 = BLTNPageItem(title: self.gameType ?? "")
        item2.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold))
        item2.actionButtonTitle = "Invite"
        item2.alternativeButtonTitle = "Back"
        item2.descriptionText = "Pick a user you would like to play against."
        item.next = item2
        
        return BLTNItemManager(rootItem: item)
    }()
    
    // MARK: - Actions
    
    func didTapBoardContinue() {
        boardManager.displayNextItem()
    }
    
    func didTapBoardCancel() {
        boardManager.dismissBulletin()
    }
    
    // MARK: - Lifecycle
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { (user) in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    @objc func duelButtonTapped() {
        boardManager.showBulletin(above: self)
    }
    
    //MARK: - Helpers
    
    func configureViewControllers(withUser user: User) {
        
        view.backgroundColor = UIColor(named: "Background 1")
        self.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!, rootViewController: SearchController(config: .all))
        
        let duel = templateNavigationController(unselectedImage: UIImage(systemName: "plus")!, selectedImage: UIImage(systemName: "plus")!, rootViewController: UIViewController.init())
        
        let notifications = templateNavigationController(unselectedImage: UIImage(systemName: "mail.stack")!, selectedImage: UIImage(systemName: "mail.stack.fill")!, rootViewController: NotificationsController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!, rootViewController: profileController)
        
        viewControllers = [feed, search, duel, notifications, profile]
        
        tabBar.tintColor = .black
        
//        let button = UIButton(type: .custom)
//        let toMakeButtonUp = 40
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 65, height: 65)
//        button.setImage(UIImage(systemName: "crown", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
//        button.setImage(UIImage(systemName: "crown", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .highlighted)
//        button.imageView?.tintColor = .white
//
//        button.imageView?.contentMode = .scaleAspectFit
//        button.backgroundColor = UIColor(named: "card3")
//        button.layer.cornerRadius = 65 / 2
//        let heightDifference: CGFloat = CGFloat(toMakeButtonUp)
//        if heightDifference < 0 {
//            button.center = tabBar.center
//        } else {
//            var center: CGPoint = tabBar.center
//            center.y = center.y - heightDifference / 2.0
//            button.center = center
//        }
//        button.addTarget(self, action: #selector(duelButtonTapped), for: .touchUpInside)
//        button.startAnimatingPressActions()
//
//        view.addSubview(button)
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
}

extension MainTabController: PickGameView2Delegate {
    
    func gameType(_ game: String) {
        self.gameType = game
        self.didTapBoardContinue()
    }
}

