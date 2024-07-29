//
//  PhotoDetailViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import Foundation

final class PhotoDetailViewModel: BaseViewModel {
    
    var inputSetPhotoDetailData: Observable<(IndexPath, Photo, IndexPath?)?> = Observable(nil)
    var inputLikeButtonClicked: Observable<String?> = Observable(nil)
    var inputGetLikedPhotos: Observable<Void?> = Observable(nil)
    
    var outputPhotoDetailData: Observable<(Photo, PhotoStatisticsResponse?, Bool)?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<RepositoryResult?> = Observable(nil)
    var outputFetchIsLiked: Observable<Bool> = Observable(false)
    
    
    var beforeViewController: NotificationName.DetailView?
    private var indexPath: IndexPath?
    private var colorFilter: IndexPath?
    
    override func transform() {
        inputGetLikedPhotos.bind { [weak self] _ in
            self?.fetchIsLiked()
        }
        
        inputSetPhotoDetailData.bind { [weak self] _ in
            self?.fetchIsLiked()
            self?.setDetailViewData()
        }
        
        inputLikeButtonClicked.bind { [weak self] _ in
            self?.likeButtonToggle()
        }
        
    }

    private func fetchIsLiked() {
        guard let user = repository.fetchUser(sortKey: User.Column.signUpDate).last else {
            return
        }
        self.user = user
        guard let data = outputPhotoDetailData.value else {
            return
        }
        let photo = data.0
        let likedList = user.likedList.filter{ !$0.isDelete }
        print(#function, "photo.id: ", photo.identifier)
        print(#function, "likedList")
        dump(likedList)
        outputFetchIsLiked.value = likedList.filter{ $0.id == photo.identifier }.count > 0
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
        let isLiked = likedList.filter{ $0.id == photo.identifier && !$0.isDelete }.count > 0
        let statistics = callRequestPhotoStatistic(photo.identifier)
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
        guard let likedList = self.user?.likedList, let photo = inputSetPhotoDetailData.value?.1 else {
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
                self?.fetchIsLiked()
                self?.outputLikeButtonClickResult.value = status
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }

    private func deleteLikedItem(_ id: String) {
        guard let likedList = user?.likedList,
              let likedPhoto = likedList.filter { $0.id == id && !$0.isDelete }.last else {
            return
        }
        repository.deleteLikedPhoto(likedPhoto) { [weak self] result in
            switch result {
            case .success(let status):
                self?.fetchIsLiked()
                self?.outputLikeButtonClickResult.value = status
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }
}
