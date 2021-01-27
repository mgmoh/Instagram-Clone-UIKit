//
//  DuelController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit
import BLTNBoard

protocol PickGameView2Delegate: class {
    func gameType(_ game: String)
}

class DuelController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}

class PickGameBLTNItem: BLTNPageItem, PickGameViewDelegate {
    
    weak var delegate: PickGameView2Delegate?
    
    func gameType(_ game: String) {
        delegate?.gameType(game)
    }
    
    
    public lazy var pickGameView = PickGameView()
    
    override public func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        pickGameView.delegate = self
        return [pickGameView]
    }
}
