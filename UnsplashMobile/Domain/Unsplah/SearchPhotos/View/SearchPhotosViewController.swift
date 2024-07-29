//
//  SearchPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit


protocol SearchPhotosViewDelegate {
    func searchingWithSortFilter(_ sort: String)
}

protocol SearchPhotosCollectionViewCellDelegate {
    func likeButtonToggleEvent(_ index: Int?, _ id: String?)
}


final class SearchPhotosViewController: BaseViewController<SearchPhotosView, SearchPhotosViewModel> {
    
    var searchPhotosDataSource: UICollectionViewDiffableDataSource<SearchPhotosSection, Photo>?
    var filterDataSource: UICollectionViewDiffableDataSource<FilterSection, ColorFilter>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFilterDataSource()
        configureSearchPhotosDataSource()
        updateFilterSnapShot()
        rootView?.filterInteractionToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputFetchLikedPhotos.value = ()
        rootView?.layoutIfNeeded()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: false)
        navigationItem.title = Resource.UIConstants.Text.searchPhotosTitle
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        viewModel?.outputSearchPhotos.bind { [weak self] result in
            self?.fetchShearchPhotos()
        }
        viewModel?.outputScrollToTop.bind { [weak self] _ in
            if let rootView = self?.rootView  {
                rootView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        viewModel?.outputLikeButtonClickResult.bind { [weak self] result in
            guard let result else { return }
            self?.rootView?.makeToast(result.likeButtonMessage, duration: 3.0, position: .bottom)
        }
        viewModel?.outputFetchedPhotos.bind { [weak self] photoList in
            self?.updateSearchPhotosSnapShot(photoList)
        }
    }
    
    private func fetchShearchPhotos() {
        guard let result = viewModel?.outputSearchPhotos.value else {
            rootView?.filterInteractionToggle()
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
        let isNoResult = photoList.count == 0
        rootView?.noResultToggle(isNoResult: isNoResult)
        updateSearchPhotosSnapShot(photoList)
    }
    
    func pushToPhotoDetailViewController(_ indexPath: IndexPath, _ item: Photo) {
        let colorFilter = viewModel?.outputSelectedColorFilter.value
        let vc = PhotoDetailViewController(view: PhotoDetailView(), viewModel: PhotoDetailViewModel())
        vc.viewModel?.inputSetPhotoDetailData.value = (indexPath, item, colorFilter)
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
}

extension SearchPhotosViewController: SearchPhotosViewDelegate {
    
    func searchingWithSortFilter(_ sort: String) {
        viewModel?.inputSortFilter.value = sort
    }
    
}

extension SearchPhotosViewController: SearchPhotosCollectionViewCellDelegate {
    
    func likeButtonToggleEvent(_ index: Int?, _ id: String?) {
        viewModel?.inputLikeButtonClicked.value = (index, id)
    }
    
}
