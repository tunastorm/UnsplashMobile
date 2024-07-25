//
//  TopicPhotosModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/24/24.
//

import Foundation


enum TopicID: String, CaseIterable {
    case architectureInterior
    case goldenHour
    case wallpapers
    case nature
    case ThreeDementionRenders
    case travel
    case texturesPatterns
    case streetPhotography
    case film
    case archival
    case experimental
    case animals
    case fashionBeauty
    case people
    case businessWork
    case foodDrink
    
    var query: String {
        switch self {
        case .architectureInterior:
            "architecture-interior"
        case .goldenHour:
            "golden-hour"
        case .wallpapers:
            "wallpapers"
        case .nature:
            "nature"
        case .ThreeDementionRenders:
            "3d-renders"
        case .travel:
            "travel"
        case .texturesPatterns:
            "textures-patterns"
        case .streetPhotography:
            "street-photography"
        case .film:
            "film"
        case .archival:
            "archival"
        case .experimental:
            "experimental"
        case .animals:
            "animals"
        case .fashionBeauty:
            "fashion-beauty"
        case .people:
            "people"
        case .businessWork:
            "business-work"
        case .foodDrink:
            "food-drink"
        }
    }
    
    var krTitle: String {
        switch self {
        case .architectureInterior:
            "건축 및 인테리어"
        case .goldenHour:
            "골든 아워"
        case .wallpapers:
            "배경 화면"
        case .nature:
            "자연"
        case .ThreeDementionRenders:
            "3D 렌더링"
        case .travel:
            "여행하다"
        case .texturesPatterns:
            "텍스쳐 및 패턴"
        case .streetPhotography:
            "거리 사진"
        case .film:
            "필름"
        case .archival:
            "기록의"
        case .experimental:
            "실험적인"
        case .animals:
            "동물"
        case .fashionBeauty:
            "패션 및 뷰티"
        case .people:
            "사람"
        case .businessWork:
            "비즈니스 및 업무"
        case .foodDrink:
            "식음료"
        }
    }
    
    static var randomIDs: [TopicID] {
        var result: [TopicID] = []
        var copy = TopicID.allCases
        (0..<3).forEach { _ in
            result.append(copy.remove(at: Int.random(in: 0..<copy.count)))
        }
        return result
    }
}
