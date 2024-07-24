//
//  APIError.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

enum APIError: Error {
    case canceled
    case failedRequest
    case noData
    case invalidResponse
    case invalidSession
    case networkError
    case redirectError
    case clientError
    case serverError
    case invalidData
    case noResultError
    case unExpectedError
    
    var title: String {
        return switch self {
        case .canceled:
            "[ 세션 요청 취소 ]"
        case .failedRequest:
            "[ 세션 요청 실패 ]"
        case .noData:
            "[ 응답 데이터 없음 ]"
        case .invalidResponse:
            "[ 응답 유효성 에러 ]"
        case .invalidSession:
            "[ 세션 인증 실패 ]"
        case .networkError:
            "[ 네트워크 에러 ]"
        case .redirectError:
            "[ 리소스 경로 변경 ]"
        case .clientError:
            "[ 잘못된 요청 ]"
        case .serverError:
            "[ 서비스 상태 불량 ]"
        case .invalidData:
            "[ 데이터 유효성 에러 ]"
        case .noResultError:
            "[ 검색 결과 없음 ]"
        case .unExpectedError:
            "[ 비정상적인 에러 ]"
        }
    }
    
    var message: String {
        return switch self {
        case .canceled:
            "요청이 취소되었습니다."
        case .failedRequest:
            "데이터 요청에 실패하였습니다.\n 네트워크 환경을 확인하세요."
        case .noData:
            "검색결과가 없습니다. 다른 검색어를 입력하세요."
        case .invalidResponse:
            "유효하지 않은 응답입니다."
        case .invalidSession:
            "세션의 정보가 유효하지 않습니다. 다시 로그인해 주세요."
        case .networkError:
            "네트워크 연결상태를 확인하세요."
        case .redirectError:
            "요청한 리소스의 주소가 변경되었습니다.\n  올바른 주소로 다시 요청해주세요."
        case .clientError:
            "잘못된 요청이거나 접근권한이 없습니다."
        case .serverError:
            "일시적인 서비스 장애입니다.\n  잠시 후 다시 시도해주세요."
        case .invalidData:
            "응답 데이터가 유효하지 않습니다."
        case .noResultError:
            "검색어에 해당하는 결과가 없습니다."
        case .unExpectedError:
            "알 수 없는 에러가 발생하였습니다.\n 고객센터로 문의하세요."
        }
    }
}
