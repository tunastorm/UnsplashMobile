//
//  LikedPhotosCollectionViewCell.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit
import SnapKit
import Then

final class LikedPhotosCollectionViewCell: BaseCollectionViewCell {
    
    private var data: LikedPhoto?
    
    private var delegate: LikedPhotosCollectionViewCellDelegate?
    
    private let photoView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    private let starButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        $0.titleLabel?.font = Resource.Asset.Font.system13
        $0.imageView?.backgroundColor = .clear
        $0.setImage(Resource.Asset.SystemImage.starFill?.withConfiguration(config), for: .normal)
        $0.backgroundColor = Resource.Asset.CIColor.darkGray
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        $0.layer.masksToBounds = true
        $0.tintColor = .systemYellow
        $0.isUserInteractionEnabled = false
    }
    
    private let likeButtonView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.white
        $0.layer.masksToBounds = true
        $0.layer.opacity = 0.2
    }
    
    private let likeButton = UIButton().then {
        $0.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        $0.setImage(Resource.Asset.NamedImage.like, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override func configHierarchy() {
        contentView.addSubview(photoView)
        contentView.addSubview(starButton)
        contentView.addSubview(likeButtonView)
        contentView.addSubview(likeButton)
    }
    
    override func configLayout() {
        photoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        starButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(photoView.snp.leading).inset(10)
            make.bottom.equalTo(photoView.snp.bottom).inset(10)
        }
        likeButtonView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.bottom.equalToSuperview().inset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        starButton.imageView?.frame.size = .init(width: 10, height: 10)
        starButton.layer.cornerRadius = starButton.frame.height / 2
        likeButtonView.layer.cornerRadius = likeButtonView.frame.height / 2
    }
    
    override func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        let vc = viewController as? LikedPhotosViewController
        delegate = vc
    }
    
    func configCell(data: LikedPhoto, index: Int) {
        guard let urlString = data.urls?.small, let url = URL(string: urlString) else { return }
        self.data = data
        likeButton.tag = index
        likeButton.setTitle(data.id, for: .normal)
        let likes = data.likes.formatted()
        let likeButtonWidth = 30 + likes.count * 10
        photoView.kf.setImage(with: url)
        starButton.setTitle(likes, for: .normal)
        starButton.snp.updateConstraints { make in
            make.width.equalTo(likeButtonWidth)
        }
        layoutIfNeeded()
    }

    @objc private func likeButtonClicked(_ sender: UIButton) {
        guard let data else { return }
        likeButton.isSelected.toggle()
        delegate?.likeButtonToggleEvent(isAdd: isSelected, data)
        if likeButton.isSelected {
            likeButton.setImage(Resource.Asset.NamedImage.like, for: .selected)
        } else {
            likeButton.setImage(Resource.Asset.NamedImage.likeInActive, for: .normal)
        }
    }
    
}

