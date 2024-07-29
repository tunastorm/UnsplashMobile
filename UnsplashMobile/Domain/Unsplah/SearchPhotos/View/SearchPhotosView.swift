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
    
    private var delegate: SearchPhotosViewDelegate?
    
    private var searchBar = UISearchBar().then {
        $0.backgroundImage = UIImage()
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    private let filterView = UIView()
    
    private let sortFilterButton = UIButton().then {
        $0.addTarget(self, action: #selector(sortFilterButtonClicked), for: .touchUpInside)
        $0.setImage(Resource.Asset.NamedImage.sort, for: .normal)
        $0.setTitle(APIRouter.Sorting.relevant.krName, for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.black, for: .normal)
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem14
        $0.backgroundColor = Resource.Asset.CIColor.white
        $0.layer.masksToBounds = true
    }
    
    private let colorFilterLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1.0))
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
    
    override func configHierarchy() {
        addSubview(searchBar)
        addSubview(lineView)
        addSubview(filterView)
        filterView.addSubview(filterCollectionView)
        filterView.addSubview(sortFilterButton)
        addSubview(collectionView)
    }
    
    override func configLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        filterView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(lineView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
        filterCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        sortFilterButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(72)
            make.verticalEdges.equalToSuperview().inset(4)
            make.trailing.equalToSuperview()
            make.leading.equalTo(filterCollectionView.snp.trailing).offset(2)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    override func configView() {
        filterCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        collectionView.setEmptyView(message: Resource.UIConstants.Text.searchPhotosIdleMessage)
        sortFilterButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        sortFilterButton.layer.cornerRadius = sortFilterButton.frame.height / 2
    }
    
    override func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        let vc = viewController as? SearchPhotosViewController
        delegate = vc
        searchBar.delegate = vc
        filterCollectionView.delegate = vc
        collectionView.delegate = vc
        collectionView.prefetchDataSource = vc
    }
    
    func noResultToggle(isNoResult: Bool) {
        if isNoResult {
            collectionView.setEmptyView(message: Resource.UIConstants.Text.noSearchResultMessage)
        } else {
            collectionView.restoreBackgroundView()
            filterInteractionToggle(isActive: true)
        }
    }
    
    @objc private func sortFilterButtonClicked(_ sender: UIButton) {
        let sortList = APIRouter.Sorting.allCases
        switch sender.tag {
        case 0: sender.tag = 1
        case 1: sender.tag = 0
        default: break
        }
        delegate?.searchingWithSortFilter(sortList[sender.tag].name)
        sortFilterButton.setTitle(sortList[sender.tag].krName, for: .normal)
        collectionView.scrollsToTop = true
    }
    
    func setSearchBarText(_ keyword: String) {
        searchBar.text = keyword
    }
    
    func filterInteractionToggle(isActive: Bool = false) {
        filterCollectionView.isUserInteractionEnabled = isActive
        sortFilterButton.isEnabled = isActive
    }

}
