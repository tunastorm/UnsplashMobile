//
//  SearchPhotosView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class SearchPhotosView: BaseView {
    
    var searchBar: UISearchBar?
    
    let filterView = UIView()
    
    let sortFilterButton = UIButton().then {
        $0.backgroundColor = Resource.Asset.CIColor.white
        $0.tintColor = .black
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem18
    }
    
    let colorFilterLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    let searchPhotosLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: colorFilterLayout())
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: searchPhotosLayout())
    
    
    override func configHierarchy() {
        if let searchBar {
            addSubview(searchBar)
        }
        addSubview(filterView)
        filterView.addSubview(filterCollectionView)
        filterView.addSubview(sortFilterButton)
        addSubview(collectionView)
    }
    
    override func configLayout() {
        filterView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        filterCollectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        sortFilterButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(72)
            make.verticalEdges.equalToSuperview().inset(4)
            make.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        filterView.backgroundColor = .blue
        filterCollectionView.backgroundColor = .green
    }
}
