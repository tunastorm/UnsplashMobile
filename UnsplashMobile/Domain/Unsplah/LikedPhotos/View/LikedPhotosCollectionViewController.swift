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
    
    private func LikedPhotosCellRegistration() -> UICollectionView.CellRegistration<LikedPhotosCollectionViewCell, LikedPhoto> {
        UICollectionView.CellRegistration<LikedPhotosCollectionViewCell, LikedPhoto> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.configInteractionWithViewController(viewController: self)
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
        print(#function, "collectionView: ", rootView?.collectionView)
        guard let collectionView = rootView?.collectionView else { return }
        let cellRegistration = LikedPhotosCellRegistration()
        print(#function, "cellRegistration: ", cellRegistration)
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
    
    func updateLikedPhotosSnapShot(_ photoList: [LikedPhoto]) {
        var snapShot = NSDiffableDataSourceSnapshot<SearchPhotosSection, LikedPhoto>()
        snapShot.appendSections(SearchPhotosSection.allCases)
        print(#function, "photoList: ", photoList)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(photoList, toSection: .main)
        }
        likedPhotosDataSource?.apply(snapShot)
    }
    
}

extension LikedPhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == rootView?.filterCollectionView {
            guard let viewModel else { return }
            print(#function, "하이")
            var cell = collectionView.cellForItem(at: indexPath) as? ColorFilterCollectionViewCell
            
            var filterList = viewModel.outputSelectedColorFilter.value
            if filterList.contains(indexPath) {
                filterList.removeAll { $0 == indexPath }
                cell?.isSelected = false
            } else {
                filterList.append(indexPath)
            }
            viewModel.inputSelectedColorFilter.value = filterList
            cell?.colorFilterToggle()
            
        }
        
        if collectionView == rootView?.collectionView {
            let item = collectionView.cellForItem(at: indexPath)
            
        }
    }
}

