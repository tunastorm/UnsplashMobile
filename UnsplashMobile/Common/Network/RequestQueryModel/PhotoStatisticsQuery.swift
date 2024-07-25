//
//  PhotoStatisticsQuery.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import Foundation


struct PhotoStatisticsQuery: Encodable {
    let id: String
    let resolution = "days"
    let quantity = 30
}
