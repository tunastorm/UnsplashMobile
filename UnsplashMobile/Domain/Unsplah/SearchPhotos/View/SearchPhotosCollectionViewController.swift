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
        print(#function, "스냅샷 업데이트")
        rootView?.noResultToggle(isNoResult: snapShot.numberOfItems == 0 )
        searchPhotosDataSource?.apply(snapShot)
    }
    
}

extension SearchPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == rootView?.filterCollectionView {
            if let before = viewModel?.outputSelectedColorFilter.value {
                print(#function, "이전 컬러필터 UI 변경")
                let beforeCell = collectionView.cellForItem(at: before) as? ColorFilterCollectionViewCell
                beforeCell?.isSelected = false
                beforeCell?.colorFilterToggle()
                guard before != indexPath else {
                    viewModel?.inputSelectedColorFilter.value = nil
                    return
                }
            }
            print(#function, "클릭된 컬러필터 UI 변경")
            let cell = collectionView.cellForItem(at: indexPath) as? ColorFilterCollectionViewCell
            cell?.colorFilterToggle()
            viewModel?.inputSelectedColorFilter.value = indexPath
            return
        }
        
        if collectionView == rootView?.collectionView {
            guard let item = searchPhotosDataSource?.itemIdentifier(for: indexPath) else { return }
            pushToPhotoDetailViewController(indexPath, item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView == rootView?.collectionView {
            indexPaths.forEach { [weak self] indexPath in
                switch self?.viewModel?.outputSearchPhotos.value {
                case .success(let photoList):
                    if photoList.count - 1 == indexPath.row {
                        self?.viewModel?.inputScrollTrigger.value = ()
                    }
                default: self?.rootView?.makeToast("마지막 페이지입니다.", duration: 3.0, position: .bottom)
                }
            }
            return
        }
    }

}
