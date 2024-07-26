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
        viewModel?.outputSearchPhotos.bind { [weak self] photoList in
            self?.fetchShearchPhotos()
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
        dump(photoList)
        updateSearchPhotosSnapShot(photoList)
    }
}

extension SearchPhotosViewController: SearchPhotosViewDelegate {
    func searchingWithSortFilter(_ sort: String) {
        viewModel?.inputSortFilter.value = sort
    }
}
