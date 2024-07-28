//
//  IndexPath+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/28/24.
//

import Foundation


extension IndexPath {
    
    func getColorFilter() -> ColorFilter? {
        let cases = ColorFilter.allCases
        let color = self.item <= cases.count ? cases[self.item] : nil
        return color
    }
    
}

