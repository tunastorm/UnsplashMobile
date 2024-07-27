//
//  SearchPhotoDetail.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit

protocol SearchPhotoDetailViewDelegate {
   
    func sendData() -> (Photo, PhotoStatisticsResponse?, Bool)?
    
    func likeButtonToggle(id: String?)
}


final class SearchPhotoDetailViewController: BaseViewController<SearchPhotoDetailView, SearchPhotosViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.configData()
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
         
    }
}

extension SearchPhotoDetailViewController: SearchPhotoDetailViewDelegate {
    
    func sendData() -> (Photo, PhotoStatisticsResponse?, Bool)? {
        return viewModel?.outputPhotoDetailData.value
    }
    
    func likeButtonToggle(id: String?) {
        if let id {
            viewModel?.inputLikeButtonClicked.value = (nil, id)
        } else {
            viewModel?.inputLikeButtonClicked.value = (nil, nil)
        }
    }
    
}
