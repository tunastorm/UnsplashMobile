//
//  Utils.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


enum Utils {
    static let photoManager = PhotoManager()
    static let textFilter = TextInputFilter.shared
    static let dateFormatter = DateFormatter()

    static func getDateFromFormattedString(dateString: String, formatter: String) -> Date? {
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: dateString)
    }
    
    static func getFormattedDate(date: Date, formatter: String) -> String {
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
}
