//
//  APIRouter.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import Alamofire

enum APIRouter {
    case topicPhotos(TopicPhotosQuery)
    case searchPhotos(SearchPhotosQuery)
    case randomPhoto
    case photoStatistics(PhotoStatisticsQuery)
}

extension APIRouter: TargetType {
 
    // 열거형 asoociate value
    var baseURL: String {
        return APIKey.Unsplash.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .topicPhotos, .searchPhotos, .randomPhoto, .photoStatistics:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        [ "Authorization" : "Client-ID " + APIKey.Unsplash.accessKey ]
    }

    var path: String {
        return switch self {
        case .topicPhotos(let query): "/topics/\(query.id)/photos"
        case .searchPhotos: "/search/photos"
        case .randomPhoto: "/photos/random"
        case .photoStatistics(let query): "/photos/\(query.id)/statistics"
        }
    }
    
    var parameters: Encodable? {
        return switch self {
        case .searchPhotos(let query): query
        case .topicPhotos(let query): query
        case .randomPhoto: nil
        case .photoStatistics(let query): query
        }
    }
    
    var encoder: ParameterEncoder {
        switch self {
        case .topicPhotos, .searchPhotos, .randomPhoto, .photoStatistics:
            return URLEncodedFormParameterEncoder.default
        }
    }
    
    enum Sorting: Int, CaseIterable {
        case relevant = 0
        case latest
    
        
        var name: String {
            return switch self {
            case .relevant: "relevant"
            case .latest: "latest"
            }
        }
        
        var krName: String {
            return switch self {
            case .relevant: "관련순"
            case .latest: "최신순"
            }
        }
    }
}
