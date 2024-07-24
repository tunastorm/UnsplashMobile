//
//  UnsplashResponse.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

struct SearchPhotosResponse<T: Decodable>: Decodable {
    var total: Int
    var totalPages: Int
    var results: [T] = []
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let color: String
    let urls: URLs
    let likes: Int
    let user: Artist
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case urls
        case likes
        case user
    }
}

struct Artist: Decodable {
    let name: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let medium: String
}

struct URLs: Decodable {
    let raw: String
//    let full: String
//    let regular: String
    let small: String?
//    let thumb: String
}

struct Links: Decodable {
    let itSelf: String
    let html: String
    let download: String
    
    enum CodingKeys: String, CodingKey {
        case itSelf = "self"
        case html
        case download
    }
}
