//
//  SearchPhotosViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class SearchPhotosViewModel: BaseViewModel {
    
    typealias SearchPhotosResult = Result<[Photo], APIError>

    var inputRequestSearchPhotos: Observable<String?> = Observable(nil)
    var inputGetLikedList: Observable<Void?> = Observable(nil)
    var inputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var inputSortFilter: Observable<String?> = Observable(nil)
    var inputLikeButtonClicked: Observable<(Int?,String?)> = Observable((nil,nil))
    var inputSelectedPhoto: Observable<Int?> = Observable(nil)
    var inputRequestPhotoStatistics: Observable<String?> = Observable(nil)
    
    var outputSearchPhotos: Observable<SearchPhotosResult?> = Observable(nil)
    var outputLikedList: Observable<[LikedPhoto]> = Observable([])
    var outputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<RepositoryResult?> = Observable(nil)
    var outputSelectedPhoto: Observable<Photo?> = Observable(nil)
    var outputPhotoStatistic: Observable<PhotoStatisticsResponse?> = Observable(nil)
   
    private var responseInfo = SearchPhotosResponse<Photo>(total: 0, page: 1, totalPages: 1)
    
    override func transform() {
        inputRequestSearchPhotos.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
        }
        inputGetLikedList.bind { [weak self] _ in
            self?.getLikeList()
        }
        inputSelectedColorFilter.bind { [weak self] indexPath in
            self?.outputSelectedColorFilter.value = indexPath
            self?.callRequestSearchPhotos()
        }
        inputSortFilter.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
        }
        inputLikeButtonClicked.bind { [weak self] _ in
            self?.likeButtonToggle()
        }
        inputSelectedPhoto.bind { [weak self] _ in
            self?.getSelectedPhoto()
        }
        inputRequestPhotoStatistics.bind { [weak self] _ in
            self?.callRequestPhotoStatistic()
        }
    }
    
    private func callRequestSearchPhotos() {
        guard let keyword = inputRequestSearchPhotos.value else { return }
        guard let page = pageNation() else { return }
        let color = getColorFilter(inputSelectedColorFilter.value)
        let sort = getSortFilter(inputSortFilter.value)
        let query = SearchPhotosQuery(query: keyword, sort: sort, color: color, page: page)
        let router = APIRouter.searchPhotos(query)
        
        print(#function, "keyword: ", keyword, "sort: ", sort)
        APIManager.request(SearchPhotosResponse<Photo>.self, router: router) { [weak self] response in
            self?.searchCompletion(response)
        } failure: { [weak self] error in
            self?.outputSearchPhotos.value = .failure(error)
        }
    }
    
    private func getColorFilter(_ indexPath: IndexPath?) -> String? {
        var color: String?
        if let indexPath {
            color = ColorFilter.allCases[indexPath.item].rawValue
        }
        return color
    }
    
    private func getSortFilter(_ sort: String?) -> String? {
        if let sort {
            return sort
        }
        return nil
    }
    
    private func searchCompletion(_ response: SearchPhotosResponse<Photo>){
        getLikeList()
        setNewResponse(response)
        outputSearchPhotos.value = .success(response.results)
    }

    private func clearSearchRecord() {
        outputSearchPhotos.value = nil
        responseInfo.total = 0
        responseInfo.page = 1
    }
   
    private func pageNation() -> Int? {
        guard let page = responseInfo.page, page > 1 else {
            return responseInfo.page
        }
        let newPage = page + 1
        guard newPage <= responseInfo.totalPages else {
            return nil
        }
        return newPage
    }
    
    private func setNewResponse(_ response: SearchPhotosResponse<Photo>) {
        if let page = responseInfo.page, page > 1, outputSearchPhotos.value != nil {
            switch outputSearchPhotos.value {
            case .success(let photoList):
                var newList = photoList
                newList.append(contentsOf: response.results)
                outputSearchPhotos.value = .success(newList)
            default: break
            }
            return
        }
        if responseInfo.page == 1 {
            responseInfo.total = response.total
            responseInfo.totalPages = response.totalPages
            outputSearchPhotos.value = .success(response.results)
        }
    }
    
    private func getLikeList() {
        guard let user = repository.fetchAll(obejct: User.self, sortKey: User.Column.signUpDate).last else {
            return
        }
        self.user = user
        outputLikedList.value = Array(user.likedList)
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
        guard let searchResult = outputSearchPhotos.value else {
            return
        }
        switch searchResult {
        case .success(let photoList):
            guard let likedList = self.user?.likedList else {
                return
            }
            var colorFilter = outputSelectedColorFilter.value?.item
            let photo = photoList[index]
            let likedPhoto = photo.managedObject()
            likedPhoto.colorFilter = colorFilter
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

    private func deleteLikedItem(_ id: String) {
        let likedPhoto = outputLikedList.value.filter { $0.id == id }.last
    
        guard let likedPhoto else {
            return
        }
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
    
    private func getSelectedPhoto() {
        guard let index = inputSelectedPhoto.value else {
            return
        }
        switch outputSearchPhotos.value {
        case .success(let photoList): 
            outputSelectedPhoto.value = photoList[index]
            inputRequestPhotoStatistics.value = photoList[index].id
        default: break
        }
    }
    
    private func callRequestPhotoStatistic() {
        guard let id = inputRequestPhotoStatistics.value else { return }
        let query = PhotoStatisticsQuery(id: id)
        let router = APIRouter.photoStatistics(query)
        
        APIManager.request(PhotoStatisticsResponse.self, router: router) { [weak self] result in
            self?.outputPhotoStatistic.value = result
        } failure: { error in
            dump(error)
        }
    }
}
