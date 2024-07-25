//
//  SearchPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

final class SearchPhotosViewController: BaseViewController<SearchPhotosView, SearchPhotosViewModel> {
    
    typealias CellType = Photo
    typealias SectionType = SearchPhotosSection
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, CellType>?
    
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
    
    private func filterCellRegistration() -> UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, ColorFilter> {
        UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, CellType> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func configureFilterDataSource() {
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = SearchPhotosCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
    private func updateFilterSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<SectionType, CellType>()
        snapShot.appendSections(FilterSection.allCases)
        snapShot.appendItems(ColorFilter.allCases, toSection: .main)
        dataSource?.apply(snapShot)
    }
    
    
    private func SearchPhotosCellRegistration() -> UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, CellType> {
        UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, CellType> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func configureSearchPhotosDataSource() {
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = SearchPhotosCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
    private func updateSearchPhotosSnapShot(_ photoList: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<SectionType, CellType>()
        snapShot.appendSections(SearchPhotosSection.allCases)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(photoList, toSection: .main)
        }
        dataSource?.apply(snapShot)
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    
}


