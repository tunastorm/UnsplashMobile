//
//  APIManager.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


final class APIManager {
    
    static let shared = APIManager()
    
    private var searchPhotosInfo = SearchPhotosResponse<Photo>(total: 0, totalPages: 1)
    
    func callRequestSearchPhotos(_ query: String, _ sort: APIRouter.Sorting, page: Int) {
        let router = APIRouter.searchPhotos(query, sort, page)
        APIClient.request(SearchPhotosResponse<Photo>.self, router: router) { result in
            dump(result)
        } failure: { error in
            dump(error)
        }
    }
    
    func callRequestTopicPhotos(_ topicID: TopicID, _ sort: APIRouter.Sorting, page: Int) {
        let router = APIRouter.topicPhotos(topicID, sort, page)
        APIClient.request([Photo].self, router: router) { result in
            dump(result)
        } failure: { error in
            dump(error)
        }
    }
    
    func callRequestRandomPhoto() {
        let router = APIRouter.randomPhoto
        APIClient.request([Photo].self, router: router) { result in
            dump(result)
        } failure: { error in
            dump(error)
        }
    }
    
    func callRequestStatistics(_ photoID: String) {
        let router = APIRouter.photoStatistics(photoID)
        APIClient.request(PhotoStatisticsResponse.self, router: router) { result in
            dump(result)
        } failure: { error in
            dump(error)
        }
    }
}
