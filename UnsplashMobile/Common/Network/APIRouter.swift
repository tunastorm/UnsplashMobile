//
//  APIRouter.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    // 열거형 asoociate value
    case topicPhotos(_ id: TopicID, _ sort: Sorting, _ page: Int)
    case searchPhotos(_ query: String, _ sort: Sorting, _ page: Int)

    var method: HTTPMethod {
        switch self {
        case .topicPhotos, .searchPhotos:
            return .get
        }
    }
    
    static let headers: HTTPHeaders = [
        "Authorization" : "Client-ID " + APIKey.Unsplash.accessKey
    ]
    
    private var path: String {
        switch self {
        case .topicPhotos(let id, let sort, let page):
            return "/topics/\(id.query)/photos"
        case .searchPhotos:
            return "/search/photos"
        }
    }
    
    static var defaultParameters: Parameters = [
        "query" : "",
        "page" : 1,
        "per_page": 20,
        "order_by": Sorting.latest,
    ]
    
    private var parameters: Parameters? {
        switch self {
        case .searchPhotos(let query, let sort, let page):
            APIRouter.defaultParameters["query"] = query
            APIRouter.defaultParameters["page"] = page
            APIRouter.defaultParameters["order_by"] = sort.rawValue
        case .topicPhotos(let id, let sort, let page):
            APIRouter.defaultParameters["per_page"] = 10
            APIRouter.defaultParameters["page"] = page
            APIRouter.defaultParameters["order_by"] = sort.rawValue
        }
        return  APIRouter.defaultParameters
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .topicPhotos, .searchPhotos:
            return URLEncoding.default
        }
    }
    
    enum Sorting: String, CaseIterable {
        case latest
        case relevant
        
        var name: String{
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .latest:
                "정확도"
            case .relevant:
                "날짜순"
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = APIKey.Unsplash.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.method = method
        urlRequest.headers = APIRouter.headers
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}




enum TopicID: String {
    case architectureInterior
    case goldenHour
    case wallpapers
    case nature
    case ThreeDementionRenders
    case travel
    case texturesPatterns
    case streetPhotography
    case film
    case archival
    case experimental
    case animals
    case fashionBeauty
    case people
    case businessWork
    case foodDrink
    
    var query: String {
        return switch self {
        case .architectureInterior:
            "architecture-interior"
        case .goldenHour:
            "golden-hour"
        case .wallpapers:
            "wallpapers"
        case .nature:
            "nature"
        case .ThreeDementionRenders:
            "3d-renders"
        case .travel:
            "travel"
        case .texturesPatterns:
            "textures-patterns"
        case .streetPhotography:
            "street-photography"
        case .film:
            "film"
        case .archival:
            "archival"
        case .experimental:
            "experimental"
        case .animals:
            "animals"
        case .fashionBeauty:
            "fashion-beauty"
        case .people:
            "people"
        case .businessWork:
            "business-work"
        case .foodDrink:
            "food-drink"
        }
    }
}
