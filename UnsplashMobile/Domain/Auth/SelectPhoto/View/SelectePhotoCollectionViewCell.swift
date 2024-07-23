//
//  SelectePhotoCollectionViewCell.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

class SelectPhotoCollectionViewCell: BaseCollectionViewCell {

    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        configUnselectedUI()
    }
    
    func configCell(image: UIImage) {
        imageView.layer.cornerRadius = contentView.frame.height * 0.5
        imageView.image = image
    }
    
    func configUnselectedUI() {
        imageView.layer.borderWidth = Resource.UIConstants.Border.width1
        imageView.layer.borderColor = Resource.Asset.CIColor.gray.cgColor
        imageView.alpha = Resource.UIConstants.Alpha.half
    }
    
    func configSelectedUI() {
        imageView.layer.borderWidth = Resource.UIConstants.Border.width3
        imageView.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        imageView.alpha = Resource.UIConstants.Alpha.full
    }
}
