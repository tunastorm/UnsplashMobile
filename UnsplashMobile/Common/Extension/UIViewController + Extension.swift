//
//  UIViewController + Extension.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(style: UIAlertController.Style, title: String, message: String,
                   completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        let delete = UIAlertAction(title: "확인",
                                   style: .destructive,
                                   handler: completionHandler)
        let cancle = UIAlertAction(title: "취소",
                                   style: .cancel)
        alert.addAction(cancle)
        alert.addAction(delete)
        present(alert, animated: false)
    }
    
}
