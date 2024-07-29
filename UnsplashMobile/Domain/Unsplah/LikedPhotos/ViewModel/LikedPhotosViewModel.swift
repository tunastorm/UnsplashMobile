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
    var inputSelectedColorFilter: Observable<[IndexPath]> = Observable([])
    var inputSortFilter: Observable<Int?> = Observable(nil)
    var inputLikeButtonClicked: Observable<(Bool, LikedPhoto)?> = Observable(nil)
    
    var outputLikedPhotos: Observable<LikedPhotosResult?> = Observable(nil)
    var outputSelectedColorFilter: Observable<[IndexPath]> = Observable([])
    var outputLikeButtonClickResult: Observable<RepositoryResult?> = Observable(nil)
    var outputDeleteLikedPhotoFromSnapshot: Observable<[LikedPhoto]?> = Observable(nil)
    
    override func transform() {
        inputGetLikedList.bind { [weak self] _ in
            self?.getLikeList()
        }
        inputQueryLikedPhotos.bind { [weak self] _ in
            self?.queryLikedPhotos()
        }
        inputSelectedColorFilter.bind { [weak self] indexPaths in
            self?.outputSelectedColorFilter.value = indexPaths
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
        guard let user = repository.fetchUser(sortKey: User.Column.signUpDate).last else {
            outputLikedPhotos.value = .failure(.noResult)
            return
        }
        self.user = user
        outputLikedPhotos.value = .success(Array(user.likedList.filter{ !$0.isDelete }))
    }
    
    private func queryLikedPhotos() {
        guard let user else { return }
        let colors = getColorfilterList()
        let sort = inputSortFilter.value?.getSortFilter() ?? .latest
        repository.queryLikedPhotoList(user, sort: sort, colors: colors) { [weak self] result in
            switch result {
            case .success(let likedPhotoList):
                guard let likedPhotoList else { return }
                self?.outputLikedPhotos.value = .success(Array(likedPhotoList))
            case .failure(let error):
                self?.outputLikedPhotos.value = .failure(error)
            }
        }
    }
    
    private func getColorfilterList() -> [Int]? {
        var filterList: [Int] = []
        inputSelectedColorFilter.value.forEach {
            if let filter = $0.getColorFilter()?.rawValue {
                filterList.append(filter)
            }
        }
        return filterList.count > 0 ? filterList : nil
    }
    
    private func likeButtonToggle() {
        guard let likedInfo = inputLikeButtonClicked.value else {
            return
        }
        let isAdd = likedInfo.0
        let likedPhoto = likedInfo.1
        if likedInfo.0 {
            addLikedItem(likedPhoto)
        } else {
            deleteLikedItem(likedPhoto)
        }
    }
    
    private func addLikedItem(_ likedPhoto: LikedPhoto) {
        guard let searchResult = outputLikedPhotos.value else {
            return
        }
        switch searchResult {
        case .success(let photoList):
            guard let likedList = self.user?.likedList else {
                return
            }
            repository.addLikedPhoto(list: likedList, item: likedPhoto) { [weak self] result in
                switch result {
                case .success(let status):
                    self?.getLikeList()
                    self?.outputLikeButtonClickResult.value = status
                case .failure(let error):
                    self?.outputLikeButtonClickResult.value = error
                }
            }
        default: self.outputLikeButtonClickResult.value = RepositoryError.createFailed
        }
    }

    private func deleteLikedItem(_ likedPhoto: LikedPhoto) {
        repository.deleteLikedPhoto(likedPhoto) { [weak self] result in
            switch result {
            case .success(let status):
                self?.getLikeList()
                self?.outputLikeButtonClickResult.value = status
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }
    
}
