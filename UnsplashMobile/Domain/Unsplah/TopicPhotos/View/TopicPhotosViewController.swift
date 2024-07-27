//
//  TopicPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class TopicPhotosViewController: BaseViewController<TopicPhotosView, TopicPhotosViewModel> {
    
    typealias CellType = Photo
    typealias SectionType = TopicID
    typealias SectionDict = [SectionType: [CellType]]
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, CellType>?
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        guard let imageName = viewModel?.outputProfileImageName.value else { return }
        let view = TopicPhotosCustomView()
        view.configButtonImage(imageName)
        let barButtonItem = UIBarButtonItem(customView: view)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func bindData() {
        viewModel?.outputRequestTopicPhotos.bind { [weak self] result in
            guard let result else { return }
            self?.fetchTopicPhotos(result)
        }
        viewModel?.inputRequestTopicPhotos.value = ()
    }
    
    
    private func fetchTopicPhotos(_ result: [TopicID : Result<[Photo],APIError>]) {
        var sectionDict: [TopicID : [Photo]] = [:]
        result.keys.forEach { [weak self] topic in
            switch result[topic] {
            case .success(let photoList): sectionDict[topic] = photoList
            case .failure(let error):
                self?.rootView?.makeToast(error.message, duration: 3.0, position: .bottom, title:error.title)
            default: break
            }
        }
//        print(#function, sectionDict)
        guard sectionDict.keys.count > 0 else { return }
        configureDataSource(Array(sectionDict.keys))
        updateSnapShot(sectionDict)
    }
    
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
    
    private func configureDataSource(_ sectionTitles: [SectionType]) {
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
    
    private func updateSnapShot(_ sectionDict: SectionDict) {
        print(#function, "resultDict.keys: ", sectionDict.keys)
        let sectionList = Array(sectionDict.keys)
        var snapShot = NSDiffableDataSourceSnapshot<SectionType, CellType>()
        snapShot.appendSections(sectionList)
        snapShot.sectionIdentifiers.forEach { topic in
            snapShot.appendItems(sectionDict[topic] ?? [], toSection: topic)
        }
        dataSource?.apply(snapShot)
    }
}
