//
//  LikedPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

protocol LikedPhotosViewDelegate {
    func queryWithSortFilter(_ sort: Int?)
}

protocol LikedPhotosCollectionViewCellDelegate {
    func likeButtonToggleEvent(_ index: Int?, _ id: String?)
}


final class LikedPhotosViewController: BaseViewController<LikedPhotosView, LikedPhotosViewModel> {

    var likedPhotosDataSource: UICollectionViewDiffableDataSource<SearchPhotosSection, LikedPhoto>?
    var filterDataSource: UICollectionViewDiffableDataSource<FilterSection, ColorFilter>?
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputGetLikedList.value = ()
        rootView?.layoutIfNeeded()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: false)
        navigationItem.title = Resource.UIConstants.Text.likedPhotosTitle
    }
    
    override func configInteraction() {
        print(#function, "configInteraction 실행")
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        viewModel?.outputLikedPhotos.bind({ [weak self] _ in
            self?.fetchLikedPhotos()
        })
        viewModel?.outputLikeButtonClickResult.bind { [weak self] result in
            print(result?.message)
        }
        configureFilterDataSource()
        configureLikedPhotosDataSource()
        updateFilterSnapShot()
    }
    
    private func fetchLikedPhotos() {
        guard let result = viewModel?.outputLikedPhotos.value else {
            return
        }
        var photoList: [LikedPhoto] = []
        switch result {
        case .success(let likedPhotos):
            photoList = likedPhotos
        case .failure(let error):
            self.rootView?.makeToast(error.message, duration: 3.0, position: .bottom)
            return
        }
        print(#function, "조회 결과 수: ", photoList.count)
        updateLikedPhotosSnapShot(photoList)
    }
    
}

extension LikedPhotosViewController: LikedPhotosViewDelegate {
    
    func queryWithSortFilter(_ sort: Int?) {
        viewModel?.inputSortFilter.value = sort
    }
    
}

extension LikedPhotosViewController: LikedPhotosCollectionViewCellDelegate {
    
    func likeButtonToggleEvent(_ index: Int?, _ id: String?) {
        viewModel?.inputLikeButtonClicked.value = (index, id)
    }
    
}


