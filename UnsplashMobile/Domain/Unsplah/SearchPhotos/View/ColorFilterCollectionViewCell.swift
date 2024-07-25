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
    
    let colorLabel = UILabel().then {
        $0.layer.masksToBounds = true
    }
    
    let textLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem16
        $0.textAlignment = .center
    }
    
    override func configHierarchy() {
        contentView.addSubview(colorLabel)
        contentView.addSubview(textLabel)
    }
    
    override func configLayout() {
        colorLabel.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.verticalEdges.equalToSuperview().inset(2)
        }
        textLabel.snp.makeConstraints{ make in
            make.width.equalTo(20)
            make.trailing.verticalEdges.equalToSuperview().inset(2)
            make.leading.equalTo(colorLabel.snp.trailing).offset(2)
        }
    }
    
    override func configView() {
        backgroundColor = Resource.Asset.CIColor.lightGray
        layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.height * 0.5
        colorLabel.layer.cornerRadius = colorLabel.frame.height * 0.5
    }
    
    func configCell(data: ColorFilter) {
        colorLabel.backgroundColor = data.color
        textLabel.text = data.krName
    }
}
