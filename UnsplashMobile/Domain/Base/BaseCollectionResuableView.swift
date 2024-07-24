//
//  BaseCollectionResuableView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/24/24.
//

import UIKit


class BaseCollectionResuableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        
    }
    
}
