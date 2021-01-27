//
//  NotificationViewModel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/28/20.
//

import UIKit

struct NotificationViewModel {
    var notification: Notifications
    
    init(notification: Notifications) {
        self.notification = notification
    }
    
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "") }
    
    var profileImageUrl: URL? { return URL(string: notification.userProfileImageUrl) }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: " \(timestampString ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var timestampString: String? {
        return timeAgoSinceDate(notification.timestamp.dateValue(), currentDate: Date(), numericDates: true)
    }
    
    var shouldHidePostImage: Bool {
        return self.notification.type == .follow
    }
    
    var followButtonText: String {
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
        
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }
}
