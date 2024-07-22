//
//  UIImage+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

extension UIImage {
    var name: String {
        return String(self.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
    }
}
