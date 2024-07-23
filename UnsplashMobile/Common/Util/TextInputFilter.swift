//
//  TextInputFilter.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

final class TextInputFilter {
    
    private init() {}
    
    static let shared = TextInputFilter()
    
    // 걸러내야 할 케이스를 클로저 내부에 조건으로 설정
    private var spaceFilter = {(text: String) -> Bool in text != (text.trimmingCharacters(in: .whitespacesAndNewlines))
                                                         || (text.filter{ $0.isWhitespace }.count > 1)}
    private var countFilter = {(text: String) -> Bool in text.count < 2 || text.count >= 10}
    private var specialFilter = "@#$%"
    private var serialSpaceFilter = "  "
    
    func removeSerialSpace(_ inputText: String?) -> String? {
        guard let inputText else {
            return nil
        }
        let trimed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        let replaced = trimed.replacingOccurrences(of: serialSpaceFilter, with:"")
        return (inputText == trimed && trimed.count - replaced.count <= 1) ? replaced : nil
    }
    
    func filterSpace(_ inputText: String ) -> ValidationStatus? {
        guard let replaced = removeSerialSpace(inputText) else {
            return ValidationStatus.nicknameWithSpace
        }
        return nil
    }
    
    func filterCount(_ inputText: String) -> ValidationStatus? {
        guard countFilter(inputText) else {
            return nil
        }
        return ValidationStatus.nicknameCountOver
    }
    
    func filterSpecial(_ inputText: String) -> ValidationStatus? {
        let specialStr = inputText.filter({ specialFilter.contains($0) })
        guard specialStr.count > 0 else {
            return nil
        }
        return ValidationStatus.nicknameWithSpecialCharacter
    }
    
    func filterNumber(_ inputText: String) -> ValidationStatus? {
        let numberStr = inputText.filter({ $0.isNumber })
        guard numberStr.count > 0 else {
            return nil
        }
        return ValidationStatus.nicknameWithNumber
    }
}
