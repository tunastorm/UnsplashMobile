//
//  TopicPhotosCustomView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import UIKit
import SnapKit

final class TopicPhotosCustomView: BaseView {

    let button = UIButton()
    
    override func configHierarchy() {
        addSubview(button)
    }
    
    override func configLayout() {
        button.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.verticalEdges.equalToSuperview()
        }
    }
    
    override func configView() {
        button.backgroundColor = Resource.Asset.CIColor.lightGray
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .systemFont(ofSize: 0)
        button.layer.borderWidth = Resource.UIConstants.Border.width3
        button.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
    }
    
    func configButtonImage(_ imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
//        layoutIfNeeded()
    }
}
