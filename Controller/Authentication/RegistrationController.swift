//
//  RegistrationController.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/25/20.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 90, weight: .regular)), for: .normal)
        button.tintColor = .white
        button.setDimensions(height: 150, width: 150)
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Confirm Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.authButton(text: "Signup")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account? ", secondPart: "Sign In.", size: CGFloat(16))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        } else if sender == confirmPasswordTextField {
            viewModel.confirmPassword = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credentials) { (error) in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        //plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, usernameTextField, passwordTextField, confirmPasswordTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 1
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        //plusPhotoButton.setDimensions(height: 150, width: 150)
        self.dismiss(animated: true, completion: nil)
    }
}
