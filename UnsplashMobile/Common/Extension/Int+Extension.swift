//
//  Int+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import Foundation


extension Int {
    
    func getSortFilter() -> Repository.Sorting {
        let cases = Repository.Sorting.allCases
        let result = self <= cases.count ? Repository.Sorting.allCases[self] : .latest
        return result
    }
    
}
