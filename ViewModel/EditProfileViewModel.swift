//
//  EditProfileViewModel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/1/20.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case email
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .email: return "Email"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullName
        case .email: return user.email
        }
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
