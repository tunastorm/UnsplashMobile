//
//  PhotoDetailViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import Foundation

enum LikeButtonNotificationName {
    case searchPhotos
    case topicPhotos
    case randomPhotos
    case likedPhotos
    
    var name: String {
        return switch self {
        case .searchPhotos: "SearchPhotosLikeToggle"
        case .topicPhotos: "TopicPhotosLikeToggle"
        case .randomPhotos: "RandomPhotosLikeToggle"
        case .likedPhotos: "LikedPhotosLikeToggle"
        }
    }
}

final class PhotoDetailViewModel: BaseViewModel {
    
    var inputSetPhotoDetailData: Observable<(IndexPath, Photo, IndexPath?)?> = Observable(nil)
    var inputLikeButtonClicked: Observable<String?> = Observable(nil)
    
    var outputPhotoDetailData: Observable<(Photo, PhotoStatisticsResponse?, Bool)?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<(RepositoryResult)?> = Observable(nil)
    
    var beforeViewController: LikeButtonNotificationName?
    private var indexPath: IndexPath?
    private var colorFilter: IndexPath?
    
    override func transform() {
        
        inputSetPhotoDetailData.bind { [weak self] _ in
            self?.getLikeList()
            self?.setDetailViewData()
        }
        
        inputLikeButtonClicked.bind { [weak self] _ in
            self?.likeButtonToggle()
        }
        
    }

    private func getLikeList() {
        guard let user = repository.fetchAll(obejct: User.self, sortKey: User.Column.signUpDate).last else {
            return
        }
        self.user = user
    }
    
    private func setDetailViewData() {
        indexPath = inputSetPhotoDetailData.value?.0
        colorFilter = inputSetPhotoDetailData.value?.2
        print(#function, "inputSetPhotoDetailData: ", inputSetPhotoDetailData.value)
        guard let indexPath, let photo = inputSetPhotoDetailData.value?.1 else {
            print(#function, "데이터 세팅 실패")
            return
        }
        guard let likedList = user?.likedList else { return }
        let isLiked = likedList.filter{ $0.id == photo.id }.count > 0
        let statistics = callRequestPhotoStatistic(photo.id)
        outputPhotoDetailData.value = (photo, statistics, isLiked)
        print(#function, "[ outputPhotoDetailData ]\n", outputPhotoDetailData.value)
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
    
    private func likeButtonToggle() {
        if let id = inputLikeButtonClicked.value {
            print(#function, " deleteLikedItem")
            deleteLikedItem(id)
        } else {
            print(#function, "addLikedItem")
            addLikedItem()
        }
    }
    
    private func addLikedItem() {
        guard let likedList = self.user?.likedList,let photo = inputSetPhotoDetailData.value?.1 else {
            print(#function, self.user)
            return
        }
        print(#function, "좋아요한 사진 추가")
        let likedPhoto = photo.managedObject()
        if let colorFilter {
            likedPhoto.colorFilter = colorFilter.item
        }
        repository.addLikedPhoto(list: likedList, item: likedPhoto) { [weak self] result in
            switch result {
            case .success(let status):
                self?.getLikeList()
                self?.outputLikeButtonClickResult.value = status
                self?.notificationLikeButtonClicked()
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }

    private func deleteLikedItem(_ id: String) {
        guard let likedList = user?.likedList,  let likedPhoto = likedList.filter { $0.id == id }.last else {
            return
        }
        print(#function, "좋아요한 사진 삭제")
        repository.deleteLikedPhoto(likedPhoto) { [weak self] result in
            switch result {
            case .success(let status):
                self?.getLikeList()
                self?.outputLikeButtonClickResult.value = status
                self?.notificationLikeButtonClicked()
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }
    
    func notificationLikeButtonClicked() {
        guard let beforeViewController else { return }
        var notificationName = beforeViewController.name
        var object = ["indexPath": indexPath]
        NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: object, userInfo: nil)
    }
    
}
