//
//  LikedPhoto.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class LikedPhoto: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var id: String
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var color: String
    @Persisted var urls: URLsObject
    @Persisted var likes: Int
    @Persisted var user: ArtistObject
    
    init(id: String, createdAt: String, width: Int, height: Int, color: String, urls: URLsObject, likes: Int, user: ArtistObject) {
        self.init()
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.urls = urls
        self.likes = likes
        self.user = user
    }
}

final class URLsObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var raw: String
    @Persisted var small: String?
}

final class ArtistObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var profileImage: ProfileImageObject
 }


final class ProfileImageObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var medium: String
}
