//
//  BaseViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

class BaseViewModel {
    
    deinit {
        print("deinit: ", self.self)
    }
    
    let repository = Repository()
    let object = User.self
    
    var user: User?
    
    init() {
        print(self.self, #function)
        repository.detectRealmURL()
        transform()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transform() {
        
    }
}
