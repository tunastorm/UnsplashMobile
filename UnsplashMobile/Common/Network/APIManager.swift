//
//  APIClient.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import Alamofire


final class APIManager {
    
    private init() { }
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: APIError) -> Void)
    
    static func request<T>(_ object: T.Type,
                           router: APIRouter,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T:
    Decodable {
        AF.request(router)
            .responseDecodable(of: object) { response in
                if let statusCode = response.response?.statusCode, let error = convertResponseStatus(statusCode){
                    return
                }
                switch response.result {
                case .success:
                    guard let decodedData = response.value else {return}

                    success(decodedData)
                case .failure(let AFError):
                    let error = convertAFErrorToAPIError(AFError)
                    failure(error)
                }
            }
    }
    
    private static func convertResponseStatus(_ statusCode: Int) -> APIError? {
        return switch statusCode {
        case 200 ..< 300: nil
        case 300 ..< 400: APIError.redirectError
        case 400 ..< 500: APIError.clientError
        case 500 ..< 600: APIError.serverError
        default: APIError.networkError
        }
    }
    
    private static func convertAFErrorToAPIError(_ error: AFError) -> APIError {
        return switch error {
        case .createUploadableFailed(let error): .failedRequest
        case .createURLRequestFailed(let error): .clientError
        case .downloadedFileMoveFailed(let error, let source, let destination): .invalidData
        case .explicitlyCancelled: .canceled
        case .invalidURL(let url): .clientError
        case .multipartEncodingFailed(let reason): .failedRequest
        case .parameterEncodingFailed(let reason): .failedRequest
        case .parameterEncoderFailed(let reason):  .failedRequest
        case .requestAdaptationFailed(let error):  .failedRequest
        case .requestRetryFailed(let retryError, let originalError): .failedRequest
        case .responseValidationFailed(let reason): .invalidResponse
        case .responseSerializationFailed(let reason): .invalidData
        case .serverTrustEvaluationFailed(let reason): .networkError
        case .sessionDeinitialized: .invalidSession
        case .sessionInvalidated(let error): .invalidSession
        case .sessionTaskFailed(let error): .networkError
        case .urlRequestValidationFailed(let reason): .clientError
        }
    }
}
