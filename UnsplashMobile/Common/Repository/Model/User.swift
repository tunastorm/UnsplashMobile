//
//  User.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profileImage: String
    @Persisted var signUpDate: Date
    @Persisted var mbti: String
    @Persisted var likedList: List<LikedPhoto>
    
    convenience init(nickname: String, profilImage: String, mbti: String) {
        self.init()
        self.nickname = nickname
        self.profileImage = profilImage
        self.mbti = mbti
        self.signUpDate = Date()
    }
    
    enum Column: String, CaseIterable, ColumnManager {
        case id
        case nickname
        case profileImage
        case signUpDate
        case mbti
        case likedList
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .id:
               "아이디"
            case .nickname:
               "닉네임"
            case .profileImage:
               "프로필 이미지"
            case .signUpDate:
                "가입일"
            case .mbti:
                "MBTI"
            case .likedList:
                "좋아요 목록"
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
