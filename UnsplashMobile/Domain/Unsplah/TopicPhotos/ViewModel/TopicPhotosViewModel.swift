//
//  TopicPhotosViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class TopicPhotosViewModel: BaseViewModel {
    
    typealias TopicPhotos = [Photo]
    typealias TopicPhotosResult = Result<TopicPhotos, APIError>
    
    var inputRequestTopicPhotos: Observable<Void?> = Observable(nil)
    
    var outputRequestTopicPhotos: Observable<[TopicID : TopicPhotosResult]?> = Observable(nil)
    var outputProfileImageName: Observable<String?> = Observable(nil)
    
    private var resultDict: [TopicID : TopicPhotosResult] = [:]
    
    override func transform() {
        inputRequestTopicPhotos.bind { [weak self] _ in
            self?.callRequestTopicPhotos(sort: .latest)
            self?.getProfileImage()
        }
    }
    
    private func getProfileImage() {
        let imageName = repository.fetchAll(obejct: User.self, sortKey: User.Column.signUpDate).last?.profileImage
        outputProfileImageName.value = imageName
    }
    
    private func callRequestTopicPhotos(sort: APIRouter.Sorting) {
        let group = DispatchGroup()
    
        TopicID.randomIDs.forEach { id in
            group.enter()
            DispatchQueue.global().async(group: group) {
                let query = TopicPhotosQuery(id: id.query, sort: sort.name, page: 1)
                let router = APIRouter.topicPhotos(query)
                APIManager.request(TopicPhotos.self, router: router) { [weak self] result in
                    self?.resultDict[id] = .success(result)
                    group.leave()
                } failure: { [weak self] error in
                    self?.resultDict[id] = .failure(error)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
//            print(#function, "[ resultDict ]\n", self?.resultDict)
            self?.outputRequestTopicPhotos.value = self?.resultDict
        }
    }
}
