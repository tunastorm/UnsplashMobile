//
//  FilterModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import UIKit

enum FilterSection: CaseIterable {
    case main
}

enum ColorFilter: String, CaseIterable {
    case red
    case purple
    case green
    case blue
    case yellow
    case black
    case white
    
    var krName: String {
        return switch self {
        case .red: "레드"
        case .purple: "퍼플"
        case .green: "그린"
        case .blue: "블루"
        case .yellow: "옐로우"
        case .black: "블랙"
        case .white: "화이트"
        }
    }
    
    var color: UIColor {
        return UIColor.init(hexCode: self.HexaColor)
    }
    
    var HexaColor: String {
        return switch self {
        case .black:
            "#000000"
        case .white:
            "#FFFFFF"
        case .yellow:
            "#FFEF62"
        case .red:
            "#F04452"
        case .purple:
            "#9636E1"
        case .green:
            "#02B946"
        case .blue:
            "#3C59FF"
        }
    }
}
