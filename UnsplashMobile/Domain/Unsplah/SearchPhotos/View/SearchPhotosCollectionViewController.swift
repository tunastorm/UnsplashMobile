//
//  SearchPhotosCollectionViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/26/24.
//

import UIKit

extension SearchPhotosViewController {

    private func filterCellRegistration() -> UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> {
        UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func SearchPhotosCellRegistration() -> UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, Photo> {
        UICollectionView.CellRegistration<SearchPhotosCollectionViewCell, Photo> { [weak self] cell, indexPath, itemIdentifier in
            print(#function, "outputLikedList: ", self?.viewModel?.outputLikedList.value)
            let isLiked = self?.viewModel?.outputLikedList.value.filter{ $0.id == itemIdentifier.id }.count ?? 0 > 0
            cell.delegate = self
            cell.configCell(data: itemIdentifier, index: indexPath.item)
            cell.likeButtonToggle(isLiked)
        }
    }
    
   func configureFilterDataSource() {
        guard let collectionView = rootView?.filterCollectionView else { return }
        let cellRegistration = filterCellRegistration()
        filterDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
   func configureSearchPhotosDataSource() {
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = SearchPhotosCellRegistration()
        searchPhotosDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
    }
    
    func updateFilterSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<FilterSection, ColorFilter>()
        snapShot.appendSections(FilterSection.allCases)
        snapShot.appendItems(ColorFilter.allCases, toSection: .main)
        filterDataSource?.apply(snapShot)
    }
    
    func updateSearchPhotosSnapShot(_ photoList: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<SearchPhotosSection, Photo>()
        snapShot.appendSections(SearchPhotosSection.allCases)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(photoList, toSection: .main)
        }
        searchPhotosDataSource?.apply(snapShot)
    }
    
}

extension SearchPhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == rootView?.filterCollectionView {
            if let before = viewModel?.outputSelectedColorFilter.value {
                let beforeCell = collectionView.cellForItem(at: before) as? ColorFilterCollectionViewCell
                beforeCell?.isSelected = false
                beforeCell?.colorFilterToggle()
                guard before != indexPath else {
                    viewModel?.inputSelectedColorFilter.value = nil
                    return
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? ColorFilterCollectionViewCell
            cell?.colorFilterToggle()
            viewModel?.inputSelectedColorFilter.value = indexPath
            return
        }
    }
    
}
