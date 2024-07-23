//
//  MBTI.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


enum MBTI: Int, CaseIterable {
    case field1 = 0
    case field2
    case field3
    case field4
    
    var valuePair: [String] {
        return switch self {
        case .field1:
            ["E", "I"]
        case .field2:
            ["S", "N"]
        case .field3:
            ["T", "F"]
        case .field4:
            ["J", "P"]
        }
    }
    
    static func combination(list: [Int]) -> String {
        let array =  list.enumerated().map { index, valueIndex in
            MBTI.allCases[index].valuePair[valueIndex]
        }
        return array.joined()
    }
    
    static func convertToIntegerArray(combination: String) -> [Int]{
        return combination.enumerated().map { index, char in
            guard let result = MBTI.allCases[index].valuePair.firstIndex(of: String(char)) else {
                return 9
            }
            return result
        }
    }
}
