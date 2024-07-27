//
//  LikedPhotosViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

final class LikedPhotosViewModel: BaseViewModel {
    
    typealias LikedPhotosResult = Result<[Photo], APIError>

    var inputRequestLikedPhotos: Observable<String?> = Observable(nil)
//    var inputGetLikedList: Observable<Void?> = Observable(nil)
    var inputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var inputSortFilter: Observable<String?> = Observable(nil)
    var inputLikeButtonClicked: Observable<(Int?,String?)> = Observable((nil,nil))
    
    var outputLikedPhotos: Observable<LikedPhotosResult?> = Observable(nil)
//    var outputLikedList: Observable<[LikedPhoto]> = Observable([])
    var outputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<RepositoryResult?> = Observable(nil)
   
    private var responseInfo = SearchPhotosResponse<Photo>(total: 0, page: 1, totalPages: 1)
    
    override func transform() {
        inputRequestLikedPhotos.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
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
    }
    
    private func callRequestSearchPhotos() {
        guard let keyword = inputRequestLikedPhotos.value else { return }
        guard let page = pageNation() else { return }
        let color = getColorFilter(inputSelectedColorFilter.value)
        let sort = getSortFilter(inputSortFilter.value)
        let query = SearchPhotosQuery(query: keyword, sort: sort, color: color, page: page)
        let router = APIRouter.searchPhotos(query)
        
        print(#function, "keyword: ", keyword, "sort: ", sort)
        APIManager.request(SearchPhotosResponse<Photo>.self, router: router)
        { [weak self] response in
            self?.searchCompletion(response)
        } failure: { [weak self] error in
            self?.outputLikedPhotos.value = .failure(error)
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
        setNewResponse(response)
        outputLikedPhotos.value = .success(response.results)
    }

    private func clearSearchRecord() {
        outputLikedPhotos.value = nil
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
        if let page = responseInfo.page, page > 1, outputLikedPhotos.value != nil {
            switch outputLikedPhotos.value {
            case .success(let photoList):
                var newList = photoList
                newList.append(contentsOf: response.results)
                outputLikedPhotos.value = .success(newList)
            default: break
            }
            return
        }
        if responseInfo.page == 1 {
            responseInfo.total = response.total
            responseInfo.totalPages = response.totalPages
            outputLikedPhotos.value = .success(response.results)
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
        guard let searchResult = outputLikedPhotos.value else {
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
                    self
                    self?.outputLikeButtonClickResult.value = status
                case .failure(let error):
                    self?.outputLikeButtonClickResult.value = error
                }
            }
        default: self.outputLikeButtonClickResult.value = RepositoryError.createFailed
        }
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
