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
        viewModel?.inputGetLikedPhotos.value = ()
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        viewModel?.outputFetchIsLiked.bind { [weak self] isLiked in
            self?.rootView?.likeButtonUIToggle(isLiked)
        }
    }
}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    
    func sendData() -> (Photo, PhotoStatisticsResponse?, Bool)? {
        return viewModel?.outputPhotoDetailData.value
    }
    
    func likeButtonToggle(id: String?) {
        viewModel?.inputLikeButtonClicked.value = id
    }
    
}
