//
//  AuthenticationViewModel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/26/20.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullName: String?
    var username: String?
    var confirmPassword: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && username?.isEmpty == false && confirmPassword?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct ResetPasswordViewModel: AuthenticationViewModel {
    
    var email: String?
    
    var formIsValid: Bool { return email?.isEmpty == false }
    
    var buttonBackgroundColor: UIColor { return formIsValid ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.5) }
    
    var buttonTitleColor: UIColor { return formIsValid ? .white : UIColor(white: 1, alpha: 0.67) }
}
