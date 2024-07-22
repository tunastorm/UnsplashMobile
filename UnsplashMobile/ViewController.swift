//
//  ViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        APIManager.shared.callRequestTopicPhotos(.animals, .relevant, page: 1)
    }
}

