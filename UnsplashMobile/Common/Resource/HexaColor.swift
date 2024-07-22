//
//  HexaColor.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


enum HexaColor: String, CaseIterable {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
    
    var name: String{
        return self.rawValue
    }
    
    var krName: String {
        return switch self {
        case .black:
            "검정"
        case .white:
            "흰색"
        case .yellow:
            "노랑"
        case .red:
            "빨강"
        case .purple:
            "보라"
        case .green:
            "초록"
        case .blue:
            "파랑"
        }
    }
    
    var value: String {
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
