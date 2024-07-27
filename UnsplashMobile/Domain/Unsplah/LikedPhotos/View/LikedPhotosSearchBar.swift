//
//  LikedPhotosSearchBar.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit

extension LikedPhotosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       print(#function, "검색실행")
        guard let keyword = searchBar.text else {
            return
        }
        viewModel?.inputRequestLikedPhotos.value = keyword
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
       return true
    }
    
}
