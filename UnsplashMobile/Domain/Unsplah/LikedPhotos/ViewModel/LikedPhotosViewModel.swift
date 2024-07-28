//
//  LikedPhotosViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class LikedPhotosViewModel: BaseViewModel {
    
    typealias LikedPhotosResult = Result<[LikedPhoto], RepositoryError>
    
    var inputGetLikedList: Observable<Void?> = Observable(nil)
    var inputQueryLikedPhotos: Observable<Void?> = Observable(nil)
    var inputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var inputSortFilter: Observable<Int?> = Observable(nil)
    var inputLikeButtonClicked: Observable<(Int?,String?)> = Observable((nil,nil))
    
    var outputLikedPhotos: Observable<LikedPhotosResult?> = Observable(nil)
    var outputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<RepositoryResult?> = Observable(nil)

    override func transform() {
        inputGetLikedList.bind { [weak self] _ in
            self?.getLikeList()
        }
        inputQueryLikedPhotos.bind { [weak self] _ in
            self?.queryLikedPhotos()
        }
        inputSelectedColorFilter.bind { [weak self] indexPath in
            self?.outputSelectedColorFilter.value = indexPath
            self?.queryLikedPhotos()
        }
        inputSortFilter.bind { [weak self] _ in
            self?.queryLikedPhotos()
        }
        inputLikeButtonClicked.bind { [weak self] _ in
            self?.likeButtonToggle()
        }
    }
    
    private func getLikeList() {
        guard let user = repository.fetchAll(obejct: User.self, sortKey: User.Column.signUpDate).last else {
            outputLikedPhotos.value = .failure(.noResult)
            return
        }
        self.user = user
        outputLikedPhotos.value = .success(Array(user.likedList))
    }
    
    private func queryLikedPhotos() {
        guard let user else { return }
        let color = inputSelectedColorFilter.value?.getColorFilter()?.rawValue
        let sort = inputSortFilter.value?.getSortFilter() ?? .latest
        
        repository.queryLikedPhotoList(user, sort: sort, color: color) { [weak self] result in
            switch result {
            case .success(let likedPhotoList):
                guard let likedPhotoList else { return }
                self?.outputLikedPhotos.value = .success(Array(likedPhotoList))
            case .failure(let error):
                self?.outputLikedPhotos.value = .failure(error)
            }
        }
    }
    
    private func likeButtonToggle() {
        let likedInfo = inputLikeButtonClicked.value
        if let index = likedInfo.0 {
            addLikedItem(index)
            return
        }
        if let id = likedInfo.1 {
            deleteLikedItem(id)
           return
        }
    }
    
    private func addLikedItem(_ index: Int) {
//        guard let searchResult = outputLikedPhotos.value else {
//            return
//        }
//        switch searchResult {
//        case .success(let photoList):
//            guard let likedList = self.user?.likedList else {
//                return
//            }
//            var colorFilter = outputSelectedColorFilter.value?.item
//            let photo = photoList[index]
//            let likedPhoto = photo.managedObject()
//            likedPhoto.colorFilter = colorFilter
//            repository.addLikedPhoto(list: likedList, item: likedPhoto) { [weak self] result in
//                switch result {
//                case .success(let status):
//                    self
//                    self?.outputLikeButtonClickResult.value = status
//                case .failure(let error):
//                    self?.outputLikeButtonClickResult.value = error
//                }
//            }
//        default: self.outputLikeButtonClickResult.value = RepositoryError.createFailed
//        }
    }

    private func deleteLikedItem(_ id: String) {
//        guard let likedPhoto else {
//            return
//        }
//        repository.deleteLikedPhoto(likedPhoto) { [weak self] result in
//            switch result {
//            case .success(let status):
//         
//                self?.outputLikeButtonClickResult.value = status
//            case .failure(let error):
//                self?.outputLikeButtonClickResult.value = error
//            }
//        }
        
    }
    
}
