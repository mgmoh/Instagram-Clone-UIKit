//
//  PickGameView.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/19/20.
//

import UIKit
import BLTNBoard

protocol PickGameViewDelegate: class {
    func gameType(_ game: String)
}

class PickGameView: UIView {
    
    // MARK: - Properties
    
    var viewModel: DuelViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: PickGameViewDelegate?
    
    private lazy var pongButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "card3")
        button.layer.cornerRadius = 10
        button.setWidth(80)
        button.setHeight(80)
        button.setTitle("Pong", for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(pongButtonTapped), for: .touchUpInside)
        button.startAnimatingPressActions()
        return button
    }()
    
    private lazy var poolButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "card2")
        button.layer.cornerRadius = 10
        button.setWidth(80)
        button.setHeight(80)
        button.setTitle("8 Ball", for: .normal)
        button.imageView?.tintColor = .white
        //button.addTarget(self, action: #selector(duelButtonTapped), for: .touchUpInside)
        button.startAnimatingPressActions()
        return button
    }()
    
    private lazy var snakeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "color3")
        button.layer.cornerRadius = 10
        button.setWidth(80)
        button.setHeight(80)
        button.setTitle("Snake", for: .normal)
        button.imageView?.tintColor = .white
        //button.addTarget(self, action: #selector(duelButtonTapped), for: .touchUpInside)
        button.startAnimatingPressActions()
        return button
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        let buttonStack = UIStackView(arrangedSubviews: [pongButton, poolButton, snakeButton])
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        
        addSubview(buttonStack)
        
        buttonStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        //pongButton.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
    @objc func pongButtonTapped() {
        delegate?.gameType("pong")
    }
}

