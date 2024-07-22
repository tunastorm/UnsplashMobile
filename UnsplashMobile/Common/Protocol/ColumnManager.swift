//
//  ComlumnManager.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

protocol ColumnManager {
    
    var name: String { get }
    
    var krName: String { get }
    
    var inputErrorMessage: String { get }
    
    var updatePropertySuccessMessage: String { get }
    
    var updatePropertyErrorMessage: String { get }
    
}
