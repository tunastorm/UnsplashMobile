//
//  SearchPhotosQuery.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import Foundation

struct SearchPhotosQuery: Encodable {
    let query: String
    let sort: String?
    let color: String?
    let page: Int
    let perPage = 20
    
    enum CodingKeys: String, CodingKey {
        case query
        case sort
        case color
        case page
        case perPage = "per_page"
    }
}
