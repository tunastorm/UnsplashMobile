//
//  TopicPhotosTitleView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/24/24.
//

import UIKit
import SnapKit
import Then

final class TopicPhotosSupplementrayHeaderView: BaseCollectionResuableView {
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.boldSystem20
    }
    
    override func configHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        backgroundColor = .clear
    }
}
