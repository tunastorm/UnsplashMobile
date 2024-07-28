//
//  TopicPhotosCollectionViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import UIKit

extension TopicPhotosViewController {
    
    private func cellRegistration() -> UICollectionView.CellRegistration<TopicPhotosCollectionViewCell, CellType> {
        UICollectionView.CellRegistration<TopicPhotosCollectionViewCell,Photo> { cell, indexPath, itemIdentifier in
            cell.configCell(data: itemIdentifier)
        }
    }
    
    private func collectionViewHeaderRegestration(_ sectionTitles: [SectionType]) -> UICollectionView.SupplementaryRegistration<TopicPhotosSupplementrayHeaderView> {
        UICollectionView.SupplementaryRegistration<TopicPhotosSupplementrayHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = sectionTitles[indexPath.section].krTitle
        }
    }
    
    func configureDataSource(_ sectionTitles: [SectionType]) {
        guard let collectionView = rootView?.collectionView else { return }
        let headerRegistration = collectionViewHeaderRegestration(sectionTitles)
        let cellRegistration = cellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
          
            return cell
        })
        dataSource?.supplementaryViewProvider = {(view, kind, index) in
            return self.rootView?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    func updateSnapShot(_ sectionDict: SectionDict) {
        print(#function, "resultDict.keys: ", sectionDict.keys)
        let sectionList = Array(sectionDict.keys)
        var snapShot = NSDiffableDataSourceSnapshot<SectionType, CellType>()
        snapShot.appendSections(sectionList)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(sectionDict[topic] ?? [], toSection: topic)
        }
        dataSource?.apply(snapShot)
    }
    
    func pushToPhotoDetailViewController(_ indexPath: IndexPath, _ item: Photo) {
        let vc = PhotoDetailViewController(view: PhotoDetailView(), viewModel: PhotoDetailViewModel())
        vc.viewModel?.inputSetPhotoDetailData.value = (indexPath, item, nil)
        vc.viewModel?.beforeViewController = .topicPhotos
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
}

extension TopicPhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        pushToPhotoDetailViewController(indexPath, item)
        
    }
    
}
