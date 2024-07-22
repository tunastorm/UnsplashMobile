//
//  SearchPhotos.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

struct SearchPhotos: Decodable {
//    let id: Int
//    let title: String
//    let description: String?
//    let publishedAt: Date
//    let updatedAt: Date
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let urls: URLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case likes
        case urls
    }
}
