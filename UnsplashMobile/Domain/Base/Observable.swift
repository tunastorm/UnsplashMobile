//
//  Observable.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

class Observable<T> {
    
    deinit {
        print("deinit: ", self.self)
    }
    
    typealias LogicHandler = (T) -> Void
    
    var closure: LogicHandler?
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping LogicHandler) {
        self.closure = closure
    }
}
