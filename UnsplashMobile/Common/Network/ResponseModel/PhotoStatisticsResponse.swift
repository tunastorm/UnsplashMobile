//
//  PhotoStatisticsResponse.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/24/24.
//

import Foundation


struct PhotoStatisticsResponse: Decodable {
    let id: String
    let downloads: DownloadStatistics
}

struct DownloadStatistics: Decodable {
    let total: Int
    let historical: HistoricalStatistics
}

struct HistoricalStatistics: Decodable {
    let values: [StatisticsValue]
}

struct StatisticsValue: Decodable, Hashable {
    let date: String
    let value: Int
}
