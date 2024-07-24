//
//  TopicPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class TopicPhotosViewController: BaseViewController<TopicPhotosView, TopicPhotosViewModel> {
    override func configView() {
        APIManager.shared.callRequestStatistics("LF8gK8-HGSg")
        APIManager.shared.callRequestRandomPhoto()
    }
}
