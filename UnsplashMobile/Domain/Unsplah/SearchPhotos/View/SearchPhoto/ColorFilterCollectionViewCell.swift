//
//  ColorFilterCollectionViewcell.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import UIKit
import SnapKit
import Then

final class ColorFilterCollectionViewCell: BaseCollectionViewCell {
    
    let colorView = UIView().then {
        $0.layer.masksToBounds = true
    }
    
    let textLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .center
    }
    
    override func configHierarchy() {
        contentView.addSubview(colorView)
        contentView.addSubview(textLabel)
    }
    
    override func configLayout() {
        colorView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.leading.equalToSuperview().inset(6)
            make.verticalEdges.equalToSuperview().inset(6)
        }
        textLabel.snp.makeConstraints{ make in
            make.trailing.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalTo(colorView.snp.trailing)
        }
    }
    
    override func configView() {
        backgroundColor = Resource.Asset.CIColor.lightGray
        layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.height / 2
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }
    
    func configCell(data: ColorFilter) {
        colorView.backgroundColor = data.color
        textLabel.text = data.krName
        layoutIfNeeded()
    }

    func colorFilterToggle() {
        backgroundColor =  isSelected ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.lightGray
        textLabel.textColor = isSelected ? Resource.Asset.CIColor.white : Resource.Asset.CIColor.black
    }
    
}
