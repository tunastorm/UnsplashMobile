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
        viewModel?.outputSearchPhotos.bind { [weak self] _ in
            self?.fetchShearchPhotos()
        }
        viewModel?.outputLikeButtonClickResult.bind({ [weak self] _ in
            self?.updatelikedPhoto()
        })
        viewModel?.outputPhotoDetailData.bind { [weak self] _ in
            let vc = SearchPhotoDetailViewController(view: SearchPhotoDetailView(), viewModel: self?.viewModel)
            self?.pushAfterView(view: vc, backButton: true, animated: true)
        }
    }
    
    private func fetchShearchPhotos() {
        guard let result = viewModel?.outputSearchPhotos.value else {
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
        updateSearchPhotosSnapShot(photoList)
    }
    
    private func updatelikedPhoto() {
        guard let index = viewModel?.showDetailPhotoIndex, 
              let dataSource = searchPhotosDataSource,
              let item = dataSource.itemIdentifier(for: IndexPath(row: index, section: 0)) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([item])
        searchPhotosDataSource?.apply(snapshot, animatingDifferences: true)
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
