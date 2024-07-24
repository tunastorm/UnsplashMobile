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
    case randomPhoto
    case photoStatistics(_ id: String)

    var method: HTTPMethod {
        switch self {
        case .topicPhotos, .searchPhotos, .randomPhoto, .photoStatistics:
            return .get
        }
    }
    
    static let headers: HTTPHeaders = [
        "Authorization" : "Client-ID " + APIKey.Unsplash.accessKey
    ]
    
    private var path: String {
        return switch self {
        case .topicPhotos(let id, let sort, let page):
            "/topics/\(id.query)/photos"
        case .searchPhotos:
            "/search/photos"
        case .randomPhoto:
            "/photos/random"
        case .photoStatistics(let id):
            "/photos/\(id)/statistics"
        }
    }
    
    var baseParameters: Parameters {
        switch self {
        case .topicPhotos, .searchPhotos:
            [ 
                "query" : "",
                "page" : 1,
                "per_page": 20,
                "order_by": Sorting.latest,
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
   
    
    private var parameters: Parameters? {
        var parameters: Parameters = self.baseParameters
        switch self {
        case .searchPhotos(let query, let sort, let page):
            parameters["page"] = page
            parameters["order_by"] = sort.rawValue
        case .topicPhotos(let id, let sort, let page):
            parameters["per_page"] = 10
            parameters["page"] = page
            parameters["order_by"] = sort.rawValue
        case .randomPhoto: break
        case .photoStatistics(let id):
            parameters["id"] = id
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
