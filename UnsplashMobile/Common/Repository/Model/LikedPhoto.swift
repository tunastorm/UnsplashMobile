//
//  LikedPhoto.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class LikedPhoto: Object {
    @Persisted(primaryKey: true) var realmId: ObjectId
    @Persisted var id: String
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var color: String
    @Persisted var urls: RealmURLs?
    @Persisted var likes: Int
    @Persisted var user: RealmArtist?
    @Persisted var colorFilter: Int?
    
    convenience init(id: String, createdAt: String, width: Int, height: Int, color: String, urls: RealmURLs? = nil, likes: Int, user: RealmArtist? = nil, colorFilter: Int? = nil) {
        self.init()
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.urls = urls
        self.likes = likes
        self.user = user
        self.colorFilter = colorFilter
    }
}

final class RealmURLs: Object {
    @Persisted(primaryKey: true) var realmId: ObjectId
    @Persisted var raw: String
    @Persisted var small: String?
    
    convenience init(id: String, raw: String, small: String? = nil) {
        self.init()
        self.raw = raw
        self.small = small
    }
}

final class RealmArtist: Object {
    @Persisted(primaryKey: true) var realmId: ObjectId
    @Persisted var name: String
    @Persisted var profileImage: RealmProfileImage?
    
    convenience init(id: String, name: String, profileImage: RealmProfileImage? = nil) {
        self.init()
        self.name = name
        self.profileImage = profileImage
    }
}

final class RealmProfileImage: Object {
    @Persisted(primaryKey: true) var realmId: ObjectId
    @Persisted var medium: String
    
    convenience init(id: String, medium: String) {
        self.init()
        self.medium = medium
    }
}
