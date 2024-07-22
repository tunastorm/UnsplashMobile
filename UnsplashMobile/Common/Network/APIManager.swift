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
        APIClient.request(SearchPhotosResponse<Photo>.self, router: router) { response in
            dump(response)
        } failure: { error in
            print(error)
        }
    }
    
    func callRequestTopicPhotos(_ topicID: TopicID, _ sort: APIRouter.Sorting, page: Int) {
        let router = APIRouter.topicPhotos(topicID, sort, page)
        APIClient.request([Photo].self, router: router) { response in
            let topicPhotos = TopicPhotosResponse<Photo>(results: response)
            dump(topicPhotos)
        } failure: { error in
            print(error)
        }
    }
}
