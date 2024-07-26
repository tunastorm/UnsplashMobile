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
    
    private let filterView = UIView()
    
    private let sortFilterButton = UIButton().then {
        $0.addTarget(self, action: #selector(sortFilterButtonClicked), for: .touchUpInside)
        $0.backgroundColor = Resource.Asset.CIColor.white
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem18
        $0.layer.masksToBounds = true
        $0.tintColor = .black
    }
    
    private let colorFilterLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 2.0, leading: 4.0, bottom: 2.0, trailing: 4.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
       
        var configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
      
        return layout
    }
    
    private let searchPhotosLayout = {
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
    
    private let backgroundView = UIView()
    private let messageLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textColor = Resource.Asset.CIColor.gray
        $0.textAlignment = .center
    }
    
    
    override func configHierarchy() {
        if let searchBar { addSubview(searchBar) }
        addSubview(filterView)
        filterView.addSubview(filterCollectionView)
        filterView.addSubview(sortFilterButton)
        addSubview(collectionView)
        backgroundView.addSubview(messageLabel)
    }
    
    override func configLayout() {
        searchBar?.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        filterView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(safeAreaLayoutGuide).inset(6)
            make.horizontalEdges.equalToSuperview()
        }
        filterCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        sortFilterButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(72)
            make.verticalEdges.equalToSuperview().inset(4)
            make.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        messageLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
        
    }
    
    override func configView() {
        filterCollectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView = backgroundView
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        sortFilterButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        sortFilterButton.layer.cornerRadius = sortFilterButton.frame.height / 2
    }
    
    @objc private func sortFilterButtonClicked(_ sender: UIButton) {
        sortFilterButtonToggle(sender.tag)
    }
    
    private func sortFilterButtonToggle(_ tag: Int) {
        var sort: APIRouter.Sorting?
        switch tag {
        case 0: sort = APIRouter.Sorting.allCases[1]
        case 1: sort = APIRouter.Sorting.allCases[0]
        default: break
        }
        if let sort {
            sortFilterButton.setTitle(sort.krName, for: .normal)
        }
    }
    
    func getSortOption() -> Int {
        return sortFilterButton.tag
    }

}
