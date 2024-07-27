//
//  SearchPhotoDetail.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit

protocol SearchPhotoDetailViewDelegate {
   
    func sendData() -> (Photo, PhotoStatisticsResponse)?
    
    func likeButtonToggle()
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
    
    func sendData() -> (Photo, PhotoStatisticsResponse)? {
        print(#function, "outputSelectedPhoto: ", viewModel?.outputSelectedPhoto.value)
        guard let photo = viewModel?.outputSelectedPhoto.value, let statistics = viewModel?.outputPhotoStatistic.value else {
            return nil
        }
        return (photo, statistics)
    }
    
    func likeButtonToggle() {
        
    }
    
}
