//
//  TopicPhotosQuery.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import Foundation

struct TopicPhotosQuery: Encodable {
    let id: String
    let sort: String
    let page: Int
    let perPage = 10
    
    enum CodingKeys: String, CodingKey {
        case id
        case sort
        case page
        case perPage = "per_page"
    }
}
