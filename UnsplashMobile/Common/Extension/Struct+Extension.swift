//
//  Struct+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/26/24.
//

import Foundation
import RealmSwift


public protocol Persistable {
    associatedtype ManagedObject : RealmSwift.Object

    init(managedObject : ManagedObject)

    func managedObject() -> ManagedObject
}

extension Photo: Persistable {
  
    init(managedObject: LikedPhoto) {
        self.identifier = managedObject.id
        self.createdAt = managedObject.createdAt
        self.width = managedObject.width
        self.height = managedObject.height
        self.color = managedObject.color
        if let realmUrls = managedObject.urls {
            self.urls = URLs(managedObject: realmUrls)
        } else {
            self.urls = nil
        }
        self.likes = managedObject.likes
        if let realmUser = managedObject.user {
            self.user = Artist(managedObject: realmUser)
        } else {
            self.user = nil
        }
    }
    
    func managedObject() -> LikedPhoto {
        let likedPhoto = LikedPhoto()
        likedPhoto.id = self.identifier
        likedPhoto.createdAt = self.createdAt
        likedPhoto.width = self.width
        likedPhoto.height = self.height
        likedPhoto.color = self.color
        likedPhoto.urls = self.urls?.managedObject()
        likedPhoto.likes = self.likes
        likedPhoto.user = self.user?.managedObject()
        return likedPhoto
    }
    
}

extension URLs: Persistable {
    
    init(managedObject: RealmURLs) {
        self.raw = managedObject.raw
        self.small = managedObject.small
    }
    
    func managedObject() -> RealmURLs {
        let URLs = RealmURLs()
        URLs.raw = self.raw
        URLs.small = self.small
        return URLs
    }
}

extension Artist: Persistable {

    init(managedObject: RealmArtist) {
        self.name = managedObject.name
        do {
            if let profileImage = managedObject.profileImage {
                self.profileImage = try ProfileImage(managedObject: profileImage)
            } else {
                self.profileImage = nil
            }
        } catch { }
    }

    func managedObject() -> RealmArtist {
        let artist = RealmArtist()
        artist.name = self.name
        artist.profileImage = self.profileImage?.managedObject()
        return artist
    }
    
}

extension ProfileImage: Persistable {
     
    init(managedObject: RealmProfileImage) {
        self.medium = managedObject.medium
    }
    
    func managedObject() -> RealmProfileImage {
        let profileImage = RealmProfileImage()
        profileImage.medium = self.medium
        return profileImage
    }
    
}







