//
//  RespositoryResult.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

import Foundation

protocol RepositoryResult {
    var message: String { get }
}

enum RepositoryStatus: RepositoryResult {
    
    case createSuccess
    case updateSuccess
    case deleteSuccess
    
    var message: String {
        switch self {
        case .createSuccess:
            return "등록이 완료되었습니다"
        case .updateSuccess:
            return "수정이 완료되었습니다"
        case .deleteSuccess:
            return "삭제가 완료되었습니다"
        }
    }
}


enum RepositoryError: RepositoryResult, Error {
    case noResult
    case createFailed
    case updatedFailed
    case deleteFailed
    case unexpectedError
    
    var message: String {
        return switch self {
        case .noResult: "조회 결과가 없습니다."
        case .createFailed: "등록에 실패하였습니다."
        case .updatedFailed: "수정에 실패하였습니다."
        case .deleteFailed: "삭제에 실패하였습니다"
        case .unexpectedError: "예상치 못한 에러가 발생하였습니다."
        }
    }
}
