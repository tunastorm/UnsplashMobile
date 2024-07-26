//
//  SearchPhotosSearchBar.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/26/24.
//

import UIKit

extension SearchPhotosViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       print(#function, "검색실행")
        guard let keyword = searchBar.text else {
            return
        }
        guard let sortIndex = rootView?.getSortOption() else  {
            return
        }
        viewModel?.inputRequestSearchPhotos.value = (keyword, APIRouter.Sorting.allCases[sortIndex])
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
       return true
    }
    
}
