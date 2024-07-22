//
//  SearchPhotos.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

struct TopicPhotosResponse<T: Decodable>: Decodable {
    let results: [T]
}
