//
//  EditProfileCell.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/1/20.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.textColor = .lightGray
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 20)
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,
                             bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
    }
}
