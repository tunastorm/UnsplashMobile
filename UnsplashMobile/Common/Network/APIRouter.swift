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
    case searchPhotos(_ query: String, _ sort: Sorting, _ page: Int)

    var method: HTTPMethod {
        switch self {
        case .searchPhotos:
            return .get
        }
    }
    
    static let headers: HTTPHeaders = [
        "Authorization" : APIKey.Unsplash.accessKey
    ]
    
    private var path: String {
        switch self {
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
            return  APIRouter.defaultParameters
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchPhotos:
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
    
    enum Color: String, CaseIterable {
        case black
        case white
        case yellow
        case red
        case purple
        case green
        case blue
        
        var name: String{
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .black:
                "검정"
            case .white:
                "흰색"
            case .yellow:
                "노랑"
            case .red:
                "빨강"
            case .purple:
                "보라"
            case .green:
                "초록"
            case .blue:
                "파랑"
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
