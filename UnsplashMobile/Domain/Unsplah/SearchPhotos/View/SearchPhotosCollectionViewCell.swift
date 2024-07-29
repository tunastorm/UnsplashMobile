//
//  SearchPhotosCollectionViewCell.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import UIKit
import SnapKit
import Then

final class SearchPhotosCollectionViewCell: BaseCollectionViewCell {
    
    var delegate: SearchPhotosCollectionViewCellDelegate?
    
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
        $0.setImage(Resource.Asset.NamedImage.likeInActive, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Asset.CIColor.white
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
    
    func configCell(data: Photo, index: Int) {
        guard let urlString = data.urls?.small, let url = URL(string: urlString) else { return }
        likeButton.tag = index
        likeButton.setTitle(data.identifier, for: .normal)
        let likes = data.likes.formatted()
        let likeButtonWidth = 34 + likes.count * 10
        photoView.kf.setImage(with: url)
        starButton.setTitle(likes, for: .normal)
        starButton.snp.updateConstraints { make in
            make.width.equalTo(likeButtonWidth)
        }
        layoutIfNeeded()
    }
    
    func likeButtonToggle(_ isLiked: Bool = false) {
        print(#function, "isLiked: ", isLiked)
        likeButton.isSelected = isLiked
        likeButton.setImage(Resource.Asset.NamedImage.like, for: .selected)
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        let index = sender.isSelected ? sender.tag : nil
        let id = sender.isSelected ? nil : sender.title(for: .normal)
        delegate?.likeButtonToggleEvent(index, id)
        if likeButton.isSelected {
            likeButton.setImage(Resource.Asset.NamedImage.like, for: .selected)
        } else {
            likeButton.setImage(Resource.Asset.NamedImage.likeInActive, for: .normal)
        }
    }
    
}
