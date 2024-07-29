//
//  UICollectionView+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/29/24.
//

import UIKit
import SnapKit

extension UICollectionView {
    
    func setEmptyView(message: String, image: UIImage? = nil) {
        restoreBackgroundView()
        
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = Resource.Asset.CIColor.gray
            label.font = Resource.Asset.Font.boldSystem18
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
    
        emptyView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emptyView.snp.centerX)
            make.centerY.equalTo(emptyView.snp.centerY)
        }
        self.backgroundView = emptyView
    
    }

    func restoreBackgroundView() {
        self.backgroundView = nil
    }
    
}
