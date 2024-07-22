//
//  ReusableIdentifier.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

protocol ReuseIdentifierProtocol {
    static var identifier: String { get }
}

extension ReuseIdentifierProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReuseIdentifierProtocol {}

extension UITableViewCell: ReuseIdentifierProtocol {}

extension UICollectionViewCell: ReuseIdentifierProtocol {}
