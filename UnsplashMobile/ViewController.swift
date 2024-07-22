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
        
        
        
        
        let router = APIRouter.searchPhotos("flower", .latest, 1)
        APIClient.request(UnsplashResponse<SearchPhotos>.self, router: router) { response in
            dump(response)
        } failure: { error in
            print(error)
        }

    }
}

