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

    var inputFetchLikedPhotos: Observable<Void?> = Observable(nil)
    var inputRequestSearchPhotos: Observable<String?> = Observable(nil)
    var inputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var inputSortFilter: Observable<String?> = Observable(nil)
    var inputLikeButtonClicked: Observable<(Int?,String?)> = Observable((nil,nil))
    var inputScrollTrigger: Observable<Void?> = Observable(nil)
    var inputCealerResultList: Observable<Void?> = Observable(nil)
    
    var outputSearchPhotos: Observable<SearchPhotosResult?> = Observable(nil)
    var outputFetchedPhotos: Observable<[Photo]> = Observable([])
    var outputSelectedColorFilter: Observable<IndexPath?> = Observable(nil)
    var outputLikeButtonClickResult: Observable<(RepositoryResult)?> = Observable(nil)
    var outputScrollToTop: Observable<Void?> = Observable(nil)
    var outputUpdatedLikeButton: Observable<IndexPath?> = Observable(nil)
   
    private var responseInfo = SearchPhotosResponse<Photo>(total: 0, page: 0, totalPages: 1)
    var showDetailPhotoIndex: IndexPath?
    var likedIds: [String] = []
    
    
    override func transform() {
        inputRequestSearchPhotos.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
        }
        inputFetchLikedPhotos.bind { [weak self] _ in
            self?.fetchLikedPhotos(isUpdate: true)
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
        inputScrollTrigger.bind { [weak self] _ in
            self?.callRequestSearchPhotos()
        }
        inputCealerResultList.bind { [weak self] _ in
            self?.clearSearchRecord()
        }
    }
    
    private func callRequestSearchPhotos() {
        
        guard let keyword = inputRequestSearchPhotos.value else {
            print(#function, "검색캔슬: ", inputRequestSearchPhotos.value )
            return
        }
        print(#function, "검색시작: ", keyword)
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
            color = ColorFilter.allCases[indexPath.item].name
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
    }
    
    private func fetchPhotosIsLiked(_ photos: [Photo]) -> [Photo]{
        var likedList = likedIds
        var likedPhotos: [Photo] = []
        for photo in photos {
            var fetched = photo
            if likedList.contains(photo.identifier) {
                fetched.isLiked = true
                likedList.removeAll(where: { $0 == photo.identifier})
            }
            likedPhotos.append(fetched)
        }
        print(#function, "likedPhotos: ", likedPhotos.count)
        return likedPhotos
    }
    
    private func setNewResponse(_ response: SearchPhotosResponse<Photo>) {
        if let page = responseInfo.page, page > 1, outputSearchPhotos.value != nil {
            switch outputSearchPhotos.value {
            case .success(let photoList):
                print(#function, "스크롤 실행중")
                var newList = photoList
                newList.append(contentsOf: response.results)
                let fetchedPhotos = fetchPhotosIsLiked(newList)
                print(#function, "fetchedPhotos: ", fetchedPhotos.count)
                outputSearchPhotos.value = .success(fetchedPhotos)
            default: break
            }
            return
        }
        if responseInfo.page == 1 {
            responseInfo.total = response.total
            responseInfo.totalPages = response.totalPages
            let fetchedPhotos = fetchPhotosIsLiked(response.results)
            outputSearchPhotos.value = .success(fetchedPhotos)
            return
        }
    }
    
    @objc private func fetchLikedPhotos(isUpdate: Bool = false) {
        guard let user = repository.fetchUser(sortKey: User.Column.signUpDate).last else {
            return
        }
        self.user = user
        likedIds = user.likedList.filter { !$0.isDelete }.map{ $0.id }
        if isUpdate {
            switch outputSearchPhotos.value {
            case .success(let searchPhotos):
                outputFetchedPhotos.value = fetchPhotosIsLiked(searchPhotos)
            default: break
            }
        }
    }
    
    private func likeButtonToggle() {
        var likedInfo = inputLikeButtonClicked.value
        if likedInfo == (nil, nil) { // DetailView에서 좋아요 누른 경우
            likedInfo = (showDetailPhotoIndex?.item, nil)
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
    
    private func addLikedItem(_ index: Int) {
        print(#function, "좋아요 추가")
        guard let searchResult = outputSearchPhotos.value else {
            return
        }
        switch searchResult {
        case .success(let photoList):
            guard let likedList = self.user?.likedList else {
                return
            }
            let photo = photoList[index]
            let likedPhoto = photo.managedObject()
            if let colorFilter = outputSelectedColorFilter.value?.item {
                likedPhoto.colorFilter = colorFilter
            }
            repository.addLikedPhoto(list: likedList, item: likedPhoto) { [weak self] result in
                switch result {
                case .success(let status):
                    self?.fetchLikedPhotos(isUpdate: true)
                    self?.outputLikeButtonClickResult.value = status
                case .failure(let error):
                    self?.outputLikeButtonClickResult.value = error
                }
            }
        default: self.outputLikeButtonClickResult.value = RepositoryError.createFailed
        }
    }

    private func deleteLikedItem(_ id: String) {
        guard let likedPhoto = user?.likedList.filter{ !$0.isDelete && $0.id == id }.last else {
            return
        }
        let object = ["item": likedPhoto]
        print(#function, "object :" , object )
        repository.deleteLikedPhoto(likedPhoto) { [weak self] result in
            switch result {
            case .success(let status):
                self?.fetchLikedPhotos(isUpdate: true)
                self?.outputLikeButtonClickResult.value = status
            case .failure(let error):
                self?.outputLikeButtonClickResult.value = error
            }
        }
    }
}
