//
//  CurrentGamesCollectionCell.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/20/20.
//

import UIKit
import PopMenu

protocol CurrentGameCellDelegate: class {
    func currentGameCell(_ currentGameCell: CurrentGameCell, didTapUser bool: Bool)
}

protocol CurrentGamesCollectionCellDelegate: class {
    func currentGameCell(_ currentGameCell: CurrentGamesCollectionCell, _ currentGame: CurrentGameCell, didTapUser bool: Bool)
}

class CurrentGamesCollectionCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CurrentGameCellDelegate {
    func currentGameCell(_ currentGameCell: CurrentGameCell, didTapUser bool: Bool) {
        delegate?.currentGameCell(self, currentGameCell, didTapUser: true)
    }
    
    
    private let cellIdentifier = "cellIdentifier"
    
    weak var delegate: CurrentGamesCollectionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let currentGameCell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func setupView() {
        addSubview(currentGameCell)
        currentGameCell.dataSource = self
        currentGameCell.delegate = self
        currentGameCell.register(CurrentGameCell.self, forCellWithReuseIdentifier: cellIdentifier)
        currentGameCell.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CurrentGameCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

class CurrentGameCell: UICollectionViewCell {
    
    weak var delegate: CurrentGameCellDelegate?
    
    @objc func buttonTap() {
        delegate?.currentGameCell(self, didTapUser: true)
    }
    
    private lazy var profileImageView: UIButton = {
        let iv = UIButton(type: .custom)
        iv.setImage(UIImage(named: "test"), for: .normal)
        iv.setImage(UIImage(named: "test"), for: .highlighted)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.setDimensions(height: 60, width: 60)
        iv.backgroundColor = .lightGray
        iv.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        iv.startAnimatingPressActions()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(profileImageView)
        
    }
}
