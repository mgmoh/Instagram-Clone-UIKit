//
//  ResetPasswordController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/29/20.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    var email: String?
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "High Jinx"
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.authButton(text: "Reset Password")
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { (error) in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                print("DEBUG: Failed to reset password with error \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        
        updateForm()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        emailTextField.text = email
        viewModel.email = email
        updateForm()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(logoLabel)
        logoLabel.centerX(inView: view)
        logoLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: logoLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
    }
}

// MARK: - FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}
