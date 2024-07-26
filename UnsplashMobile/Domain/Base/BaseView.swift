//
//  BaseView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class BaseView: UIView {
        
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
        self.backgroundColor = Resource.Asset.CIColor.white
    }
    
    func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        
    }
}
