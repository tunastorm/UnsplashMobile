//
//  NotificationName.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import Foundation

enum NotificationName {
    
    enum DetailView {
        case searchPhotos
        case topicPhotos
        case randomPhotos
        case likedPhotos
        
        var name: String {
            return switch self {
            case .searchPhotos: "SearchPhotosLikeToggle"
            case .topicPhotos: "TopicPhotosLikeToggle"
            case .randomPhotos: "RandomPhotosLikeToggle"
            case .likedPhotos: "LikedPhotosLikeToggle"
            }
        }
    }
    
    enum SearchPhotosView {
        case likedPhotos
        
        var name: String {
            return switch self {
            case .likedPhotos: "deleteLikedPhotos"
            }
        }
    }
    
    enum LikedPhotosView {
        case searchPhotos
        
        var name: String {
            return switch self {
            case .searchPhotos: "updateLikedPhoto"
            }
        }
    }
    

}
