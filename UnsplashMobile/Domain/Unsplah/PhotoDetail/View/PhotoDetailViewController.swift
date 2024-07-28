//
//  SearchPhotoDetail.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit

protocol PhotoDetailViewDelegate {
   
    func sendData() -> (Photo, PhotoStatisticsResponse?, Bool)?
    
    func likeButtonToggle(id: String?)
    
}


final class PhotoDetailViewController: BaseViewController<PhotoDetailView, PhotoDetailViewModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView?.configData()
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
    
    }
}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    
    func sendData() -> (Photo, PhotoStatisticsResponse?, Bool)? {
        return viewModel?.outputPhotoDetailData.value
    }
    
    func likeButtonToggle(id: String?) {
        print(#function, "좋아요버튼 토글 이벤트")
        viewModel?.inputLikeButtonClicked.value = id
    }
    
}
