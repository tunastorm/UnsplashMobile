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

enum ColorFilter: CaseIterable {
    case red
    case purple
    case green
    case blue
    
    var krName: String {
        return switch self {
        case .red: "레드"
        case .purple: "퍼플"
        case .green: "그린"
        case .blue: "블루"
        }
    }
    
    var color: UIColor {
        return switch self {
        case .red: Resource.Asset.CIColor.red
        case .purple: .systemPurple
        case .green: .systemGreen
        case .blue: Resource.Asset.CIColor.blue
        }
    }
}
