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
    @Persisted var isDelete: Bool
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var color: String
    @Persisted var urls: RealmURLs?
    @Persisted var likes: Int
    @Persisted var user: RealmArtist?
    @Persisted var colorFilter: Int?
    @Persisted var regDate: Date
    
    convenience init(id: String, createdAt: String, width: Int, height: Int, color: String, urls: RealmURLs? = nil, likes: Int, user: RealmArtist? = nil, colorFilter: Int? = nil) {
        self.init()
        self.isDelete = false
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.urls = urls
        self.likes = likes
        self.user = user
        self.colorFilter = colorFilter
        self.regDate = Date()
    }
    
    enum Column: String, ColumnManager {
        
        case id
        case isDelete
        case createdAt
        case width
        case height
        case color
        case urls
        case likes
        case user
        case colorFilter
        case regDate
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .id: "사진 id"
            case .isDelete: "삭제 여부"
            case .createdAt: "게시일"
            case .width: "가로 길이"
            case .height: "세로 길이"
            case .color: "색상"
            case .urls: "주소"
            case .likes: "좋아요 수"
            case .user: "작성자"
            case .colorFilter: "색상 필터"
            case .regDate: "등록일"
            }
        }
        
        var inputErrorMessage: String {
            return "\(self.krName) 값이 없거나 유효하지 않습니다."
        }
        
        var updatePropertySuccessMessage: String {
            return "\(self.krName) 의 수정이 완료되었습니다."
        }
        
        var updatePropertyErrorMessage: String {
            return "\(self.krName) 의 수정에 실패하였습니다."
        }
    
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

//final class RealmPhotoStatistics: Ob
