//
//  PostViewModel.swift
//  High Jinx
//
//  Created by Mohamed Mohamed on 10/27/20.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUsername
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "heart.fill" : "heart"
        return UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold))
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) LIKES"
        } else {
            return "\(post.likes) LIKE"
        }
    }
    
    var timestampString: String? {
        return timeAgoSinceDate(post.timestamp.dateValue(), currentDate: Date(), numericDates: true)
    }
    
    init(post: Post) {
        self.post = post
    }
}
