//
//  LikedPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

protocol LikedPhotosViewDelegate {
    func searchingWithSortFilter(_ sort: String)
}

protocol LikedPhotosCollectionViewCellDelegate {
    func likeButtonToggleEvent(_ index: Int?, _ id: String?)
}


final class LikedPhotosViewController: BaseViewController<LikedPhotosView, LikedPhotosViewModel> {

    var likedPhotosDataSource: UICollectionViewDiffableDataSource<SearchPhotosSection, Photo>?
    var filterDataSource: UICollectionViewDiffableDataSource<FilterSection, ColorFilter>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFilterDataSource()
        configureLikedPhotosDataSource()
        updateFilterSnapShot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView?.layoutIfNeeded()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: false)
        navigationItem.title = Resource.UIConstants.Text.searchPhotosTitle
    }
    
    override func configInteraction() {
        print(#function, "configInteraction 실행")
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        viewModel?.outputLikedPhotos.bind({ [weak self] _ in
            self?.fetchShearchPhotos()
        })
        viewModel?.outputLikeButtonClickResult.bind({ result in
            print(result?.message)
        })
    }
    
    private func fetchShearchPhotos() {
        guard let result = viewModel?.outputLikedPhotos.value else {
            return
        }
        var photoList: [Photo] = []
        switch result {
        case .success(let SearchPhotos):
            photoList = SearchPhotos
        case .failure(let error):
            self.rootView?.makeToast(error.message, duration: 3.0, position: .bottom, title: error.title)
            return
        }
        print(#function, "검색결과 수: ", photoList.count)
        updateLikedPhotosSnapShot(photoList)
    }
    
}

extension LikedPhotosViewController: LikedPhotosViewDelegate {
    
    func searchingWithSortFilter(_ sort: String) {
        viewModel?.inputSortFilter.value = sort
    }
    
}

extension LikedPhotosViewController: LikedPhotosCollectionViewCellDelegate {
    
    func likeButtonToggleEvent(_ index: Int?, _ id: String?) {
        viewModel?.inputLikeButtonClicked.value = (index, id)
    }
    
}


