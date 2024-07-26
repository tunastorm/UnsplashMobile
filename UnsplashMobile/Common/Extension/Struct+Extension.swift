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

extension URLs: Persistable {
    
    init(managedObject: RealmURLs) {
        self.raw = managedObject.raw
        self.small = managedObject.small
    }
    
    func managedObject() -> RealmURLs {
        let URLs = RealmURLs()
        URLs.raw = self.raw
        URLs.small = self.small ?? ""
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
                self.profileImage = ProfileImage(medium: "")
            }
        } catch { }
    }

    func managedObject() -> RealmArtist {
        let artist = RealmArtist()
        artist.name = self.name
        artist.profileImage = self.profileImage.managedObject()
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







