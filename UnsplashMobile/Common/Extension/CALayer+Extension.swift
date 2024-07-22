//
//  CALayer+Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

extension CALayer {
    // 뷰의 특정 방향에만 보더를 추가하는 함수
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat, opacity: Float? = nil) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default: break
            }
            border.backgroundColor = color.cgColor
            if let opacity {
                border.opacity = opacity
            }
            self.addSublayer(border)
        }
    }
}
