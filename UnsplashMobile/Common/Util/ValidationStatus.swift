//
//  TextInputError.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


enum ValidationTarget {
    case nickname
    case mbti
}

enum ValidationStatus: Error {
    case idle
    case nicknameWithSpace
    case nicknameWithSpecialCharacter
    case nicknameWithNumber
    case nicknameCountOver
    case mbtiInCorrect
    case mbtiIsValid
    case nicknameIsValid
    case allIsValid
    
    var message: String {
        return switch self {
        case .idle:
            "닉네임과 MBTI를 입력하세요"
        case .mbtiIsValid:
            "닉네임을 입력하세요"
        case .nicknameIsValid, .mbtiInCorrect:
            "MBTI를 모두 입력해 주세요"
        case .allIsValid:
            "회원가입을 진행할 수 있어요!"
        case .nicknameWithSpace:
            "닉네임의 공백은 띄어쓰기 1회만 사용가능합니다"
        case .nicknameWithSpecialCharacter:
            "닉네임에 @, #, $, %는 포함할 수 없어요"
        case .nicknameWithNumber:
            "닉네임에 숫자는 포함할 수 없어요"
        case .nicknameCountOver:
            "2글자 이상 10글자 미만으로 설정해주세요"
        }
    }
}
