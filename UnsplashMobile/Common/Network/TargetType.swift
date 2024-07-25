//
//  TargetType.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
//    var queryItems: [URLQueryItem]? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        print(#function, url)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.method = method
        urlRequest.headers = headers
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}






