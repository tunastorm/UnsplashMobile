//
//  TopicPhotosViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

final class TopicPhotosViewModel: BaseViewModel {
    
    typealias TopicPhotos = [Photo]
    typealias TopicPhotosResult = Result<TopicPhotos, APIError>
    
    var inputRequestTopicPhotos: Observable<Void?> = Observable(nil)
    
    var outputRequestTopicPhotos: Observable<[TopicID : TopicPhotosResult]?> = Observable(nil)
    
    private var resultDict: [TopicID : TopicPhotosResult] = [:]
    
    override func transform() {
        inputRequestTopicPhotos.bind { [weak self] _ in
            self?.callRequestTopicPhotos()
        }
    }
    
    private func callRequestTopicPhotos() {
        let group = DispatchGroup()
    
        TopicID.randomIDs.forEach { id in
            group.enter()
            DispatchQueue.global().async(group: group) {
                let router = APIRouter.topicPhotos(id, .relevant, 1)
                APIClient.request(TopicPhotos.self, router: router) { [weak self] result in
                    self?.resultDict[id] = .success(result)
                    group.leave()
                } failure: { [weak self] error in
                    self?.resultDict[id] = .failure(error)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.outputRequestTopicPhotos.value = self?.resultDict
        }
    }
}
