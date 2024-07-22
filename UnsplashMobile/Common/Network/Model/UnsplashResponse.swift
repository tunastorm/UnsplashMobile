//
//  UnsplashResponse.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

struct UnsplashResponse<T: Decodable>: Decodable {
    var total: Int
    var totalPages: Int
    var results: [T]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct CoverPhoto: Decodable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let color: Int16
    let likes: Int
    let urls: URLs
}

struct User: Decodable {
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
    let small: String
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
