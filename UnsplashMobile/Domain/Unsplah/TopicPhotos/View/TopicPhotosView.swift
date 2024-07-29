//
//  TopicPhotosView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class TopicPhotosView: BaseView {
    
    let titleLabel: UILabel = UILabel().then {
        $0.text = Resource.UIConstants.Text.topicPhotosTitle
        $0.font = Resource.Asset.Font.boldSystem30
        $0.textAlignment = .left
    }
    
    private let createLayout: () -> UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configHierarchy() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    override func configLayout() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        super.configView()
        collectionView.backgroundColor = .clear
    }
    
    override func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        let vc = viewController as? TopicPhotosViewController
        collectionView.delegate = vc
    }
}
