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
    
//    func resize(targetSize: CGSize) -> UIImage? {
//        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
//        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 0)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        context.interpolationQuality = .high
//        draw(in: newRect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
}
