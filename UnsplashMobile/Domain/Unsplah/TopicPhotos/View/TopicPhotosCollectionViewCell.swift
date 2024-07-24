//
//  TopicPhotosCollectionViewCell.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/24/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class TopicPhotosCollectionViewCell: BaseCollectionViewCell {
    
    let photoView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    let likeButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        $0.titleLabel?.font = Resource.Asset.Font.system13
        $0.imageView?.backgroundColor = .clear
        $0.setImage(Resource.Asset.SystemImage.starFill?.withConfiguration(config), for: .normal)
        $0.backgroundColor = Resource.Asset.CIColor.darkGray
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        $0.layer.masksToBounds = true
        $0.tintColor = .systemYellow
    }
    
    override func configHierarchy() {
        contentView.addSubview(photoView)
        contentView.addSubview(likeButton)
    }
    
    override func configLayout() {
        photoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(photoView.snp.leading).inset(10)
            make.bottom.equalTo(photoView.snp.bottom).inset(10)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        likeButton.imageView?.frame.size = .init(width: 10, height: 10)
        likeButton.layer.cornerRadius = likeButton.frame.height * 0.5
        photoView.layer.cornerRadius = photoView.frame.height * 0.06
    }
    
    func configCell(data: Photo) {
        guard let urlString = data.urls.small, let url = URL(string: urlString) else { return }
        let likes = String(data.likes)
        let likeButtonWidth = 34 + likes.count * 10
        photoView.kf.setImage(with: url)
        likeButton.setTitle(likes, for: .normal)
        likeButton.snp.updateConstraints { make in
            make.width.equalTo(likeButtonWidth)
        }
        layoutIfNeeded()
    }
}
