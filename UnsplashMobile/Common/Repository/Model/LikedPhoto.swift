//
//  LikedPhoto.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class LikedPhoto: Object {
    @Persisted(primaryKey: true) var id: ObjectId
}
