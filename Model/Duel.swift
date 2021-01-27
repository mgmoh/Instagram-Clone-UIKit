//
//  Duel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 11/23/20.
//

import Firebase

enum DuelGame: Int {
    case pong
    case ballpool
    case snake
    
    var gameType: String {
        switch self {
        case .pong:
            return "Pong"
        case .ballpool:
            return "8 Ball"
        case .snake:
            return "Snake"
        }
    }
}

enum DuelType: Int {
    case picture
    case announcement
    case profilepic
    case dm
    
    var duelType: String {
        switch self {
        case .picture:
            return "picture"
        case .announcement:
            return "announcement"
        case .profilepic:
            return "profilepic"
        case .dm:
            return "dm"
        }
    }
}

//struct Duel {
//    let uid: String
//    let opponentUid: String
//    var postImageUrl: String?
//    var postId: String?
//    let timestamp: Timestamp
//    let game: DuelGame
//    let type: DuelType
//    let id: String
//    let userProfileImageUrl: String
//    let username: String
//    var userIsFollowed = false
//    
//    
//    init(dictionary: [String: Any]) {
//        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
//        self.id = dictionary["id"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
//        self.postId = dictionary["postId"] as? String ?? ""
//        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
//        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
//        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
//        self.username = dictionary["username"] as? String ?? ""
//    }
//}
