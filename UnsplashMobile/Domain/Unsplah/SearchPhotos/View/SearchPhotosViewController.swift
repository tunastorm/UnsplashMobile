//
//  SearchPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

final class SearchPhotosViewController: BaseViewController<SearchPhotosView, SearchPhotosViewModel> {
    
    var searchPhotosDataSource: UICollectionViewDiffableDataSource<SearchPhotosSection, Photo>?
    var filterDataSource: UICollectionViewDiffableDataSource<FilterSection, ColorFilter>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFilterDataSource()
        updateFilterSnapShot()
    }
    
    override func configInteraction() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        rootView?.searchBar = searchController.searchBar
        rootView?.searchBar?.setShowsCancelButton(false, animated: false)
        rootView?.searchBar?.delegate = self
    }
    
    override func bindData() {
        viewModel?.outputSearchPhotos.bind { [weak self] photoList in
            self?.fetchShearchPhotos()
        }
        viewModel?.inputRequestSearchPhotos.value = ("flower", .relevant)
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
        configureSearchPhotosDataSource()
        updateSearchPhotosSnapShot(photoList)
    }
    
    private func filterCellRegistration() -> UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> {
        UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func configureFilterDataSource() {
        guard let collectionView = rootView?.filterCollectionView else { return }
        let cellRegistration = filterCellRegistration()
        filterDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
    private func updateFilterSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<FilterSection, ColorFilter>()
        snapShot.appendSections(FilterSection.allCases)
        snapShot.appendItems(ColorFilter.allCases, toSection: .main)
        filterDataSource?.apply(snapShot)
    }
    
    
    private func SearchPhotosCellRegistration() -> UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, Photo> {
        UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, Photo> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func configureSearchPhotosDataSource() {
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = SearchPhotosCellRegistration()
        searchPhotosDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
    private func updateSearchPhotosSnapShot(_ photoList: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<SearchPhotosSection, Photo>()
        snapShot.appendSections(SearchPhotosSection.allCases)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(photoList, toSection: .main)
        }
        searchPhotosDataSource?.apply(snapShot)
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    
}


