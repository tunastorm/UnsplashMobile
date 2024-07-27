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
    var inputGetPhotoDetailData: Observable<Int?> = Observable(nil)
    var inputScrollTrigger: Observable<Void?> = Observable(nil)
    
    var outputSearchPhotos: Observable<SearchPhotosResult?> = Observable(nil)
    var outputLikedList: Observable<[LikedPhoto]> = Observable([])
    var outputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<(RepositoryResult)?> = Observable(nil)
    var outputPhotoDetailData: Observable<(Photo, PhotoStatisticsResponse?, Bool)?> = Observable(nil)
    var outputScrollToTop: Observable<Void?> = Observable(nil)
   
    private var responseInfo = SearchPhotosResponse<Photo>(total: 0, page: 0, totalPages: 1)
    var showDetailPhotoIndex: Int?

    override func transform() {
        inputRequestSearchPhotos.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
        }
        inputGetLikedList.bind { [weak self] _ in
            self?.getLikeList()
        }
        inputSelectedColorFilter.bind { [weak self] indexPath in
            self?.outputSelectedColorFilter.value = indexPath
            self?.clearSearchRecord()
            self?.callRequestSearchPhotos()
        }
        inputSortFilter.bind { [weak self] _ in
            self?.clearSearchRecord()
            self?.callRequestSearchPhotos()
        }
        inputLikeButtonClicked.bind { [weak self] _ in
            self?.likeButtonToggle()
        }
        inputGetPhotoDetailData.bind { [weak self] _ in
            self?.setDetailViewData()
        }
        inputScrollTrigger.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
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
    }

    private func clearSearchRecord() {
        outputSearchPhotos.value = nil
        responseInfo.total = 0
        responseInfo.totalPages = 1
        responseInfo.page = 0
        outputScrollToTop.value = ()
    }
   
    private func pageNation() -> Int? {
        guard let page = responseInfo.page else {
            return nil
        }
        let newPage = page + 1
        guard newPage <= responseInfo.totalPages else {
            return nil
        }
        responseInfo.page = newPage
        print(#function, responseInfo.page)
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
        var likedInfo = inputLikeButtonClicked.value
        if likedInfo == (nil, nil) { // DetailView에서 좋아요 누른 경우
            likedInfo = (showDetailPhotoIndex, nil)
        }
        if let index = likedInfo.0 {
            addLikedItem(index)
            return
        }
        if let id = likedInfo.1  {
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
    
    private func setDetailViewData() {
        guard let index = inputGetPhotoDetailData.value, let photo = getSelectedPhoto(index) else {
            return
        }
        let isLiked = outputLikedList.value.filter{ $0.id == photo.id }.count > 0
        let statistics = callRequestPhotoStatistic(photo.id)
        showDetailPhotoIndex = index
        outputPhotoDetailData.value = (photo, statistics, isLiked)
    }
    
    private func getSelectedPhoto(_ index: Int) -> Photo? {
        return switch outputSearchPhotos.value {
        case .success(let photoList): photoList[index]
        default: nil
        }
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
