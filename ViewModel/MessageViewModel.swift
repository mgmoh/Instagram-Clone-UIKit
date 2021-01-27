//
//  MessageViewModel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/1/20.
//

import UIKit

struct MessageViewModel {
    private let message: Message
    
    var messageBackgroundColor: UIColor { return message.isFromCurrentUser ? .systemGray6 : .white }
    
    var messageBorderWidth: CGFloat { return message.isFromCurrentUser ? 0 : 1.0 }
    
    var rightAnchorActive: Bool { return message.isFromCurrentUser  }
    
    var leftAnchorActive: Bool {  return !message.isFromCurrentUser }
    
    var shouldHideProfileImage: Bool { return message.isFromCurrentUser }
    
    var messageText: String { return message.text }
    
    var username: String { return message.username }
    
    var profileImageUrl: URL? { return URL(string: message.profileImageUrl) }
    
    var timestampString: String? { return timeAgoSinceDate((message.timestamp?.dateValue())!, currentDate: Date(), numericDates: true) }
    
    init(message: Message) {
        self.message = message
    }
}
