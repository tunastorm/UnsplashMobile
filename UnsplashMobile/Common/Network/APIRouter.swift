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
        case .topicPhotos(let query):
            "/topics/\(query.id)/photos"
        case .searchPhotos:
            "/search/photos"
        case .randomPhoto:
            "/photos/random"
        case .photoStatistics(let query):
            "/photos/\(query.id)/statistics"
        }
    }
    
    var baseParameters: Parameters {
        switch self {
        case .topicPhotos, .searchPhotos:
            [ 
                "query" : "",
                "page" : 1,
                "per_page": 20,
            ]
        case .randomPhoto:
            [  
                "count": 10
            ]
        case .photoStatistics:
            [
                "id" : "",
                "resolution" : "days",
                "quantity": 30
            ]
        }
    }
    
    var parameters: Parameters? {
        var parameters: Parameters = self.baseParameters
        switch self {
        case .searchPhotos(let query):
            parameters["query"] = query.query
            parameters["page"] = query.page
            parameters["order_by"] = query.sort
        case .topicPhotos(let query):
            parameters["per_page"] = 10
            parameters["page"] = query.page
            parameters["order_by"] = query.sort
        case .randomPhoto: break
        case .photoStatistics(let query):
            parameters["id"] = query.id
        }
        return parameters
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .topicPhotos, .searchPhotos, .randomPhoto, .photoStatistics:
            return URLEncoding.default
        }
    }
    
    enum Sorting: String, CaseIterable {
        case latest
        case relevant

        var krName: String {
            return switch self {
            case .latest:
                "정확도"
            case .relevant:
                "날짜순"
            }
        }
    }
}
