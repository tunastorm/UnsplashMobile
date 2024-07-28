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
    var inputSetPhotoDetailData: Observable<(IndexPath,Photo)?> = Observable(nil)
    
    
    var outputRequestTopicPhotos: Observable<[TopicID : TopicPhotosResult]?> = Observable(nil)
    var outputProfileImageName: Observable<String?> = Observable(nil)
    var outputPhotoDetailData: Observable<(Photo, PhotoStatisticsResponse?, Bool)?> = Observable(nil)
    
    private var resultDict: [TopicID : TopicPhotosResult] = [:]
    
    override func transform() {
        inputRequestTopicPhotos.bind { [weak self] _ in
            self?.callRequestTopicPhotos(sort: .latest)
            self?.getProfileImage()
            self?.getLikeList()
        }
        inputSetPhotoDetailData.bind { [weak self] _ in
            self?.setDetailViewData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getLikeList), name: NSNotification.Name(LikeButtonNotificationName.topicPhotos.name), object: nil)
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
            self?.outputRequestTopicPhotos.value = self?.resultDict
        }
    }
    
    private func setDetailViewData() {
        guard let index = inputSetPhotoDetailData.value?.0, let photo = inputSetPhotoDetailData.value?.1 else {
            return
        }
        guard let likedList = user?.likedList else { return }
        
        let isLiked = likedList.filter{ $0.id == photo.id }.count > 0
        let statistics = callRequestPhotoStatistic(photo.id)
        outputPhotoDetailData.value = (photo, statistics, isLiked)
    }
    
    @objc private func getLikeList() {
        guard let user = repository.fetchAll(obejct: User.self, sortKey: User.Column.signUpDate).last else {
            return
        }
        self.user = user
    }
    
    private func callRequestPhotoStatistic(_ id: String) -> PhotoStatisticsResponse? {
        let query = PhotoStatisticsQuery(id: id)
        let router = APIRouter.photoStatistics(query)
        
        var response: PhotoStatisticsResponse?
        APIManager.request(PhotoStatisticsResponse.self, router: router) { [weak self] result in
            response = result
        } failure: { error in
            response = nil
        }
        return response
    }
    
}
