//
//  LikedPhotosCollectionViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit

extension LikedPhotosViewController {

    private func filterCellRegistration() -> UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> {
        UICollectionView.CellRegistration<ColorFilterCollectionViewCell, ColorFilter> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func LikedPhotosCellRegistration() -> UICollectionView.CellRegistration<LikedPhotosCollectionViewCell, Photo> {
        UICollectionView.CellRegistration<LikedPhotosCollectionViewCell, Photo> { [weak self] cell, indexPath, itemIdentifier in
            cell.delegate = self
            cell.configCell(data: itemIdentifier, index: indexPath.item)
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
    
   func configureLikedPhotosDataSource() {
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = LikedPhotosCellRegistration()
        likedPhotosDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
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
    
    func updateLikedPhotosSnapShot(_ photoList: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<SearchPhotosSection, Photo>()
        snapShot.appendSections(SearchPhotosSection.allCases)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(photoList, toSection: .main)
        }
        likedPhotosDataSource?.apply(snapShot)
    }
    
}

extension LikedPhotosViewController: UICollectionViewDelegate {
    
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
        
        if collectionView == rootView?.collectionView {
            let selectedCell = collectionView.cellForItem(at: )
            
        }
    }
}

