//
//  TargetType.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import Foundation
import Alamofire

struct RequestEncodableConvertible<Parameters: Encodable>: URLRequestConvertible {
    
    typealias RequestModifier = (inout URLRequest) throws -> Void
    
    let url: URLConvertible
    let method: HTTPMethod
    let parameters: Parameters?
    let encoder: ParameterEncoder
    let headers: HTTPHeaders?
    let requestModifier: RequestModifier?

    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url, method: method, headers: headers)
        try requestModifier?(&request)

        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}

protocol TargetType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Encodable? { get }
    var encoder: ParameterEncoder { get }
}

extension TargetType{
    
    func asURLRequest() throws -> URLRequest {
        let url = try (baseURL + path).asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)

        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}







