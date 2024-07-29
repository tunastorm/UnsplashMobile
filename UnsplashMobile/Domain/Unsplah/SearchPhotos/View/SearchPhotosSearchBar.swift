//
//  SearchPhotosSearchBar.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/26/24.
//

import UIKit

extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = Utils.textFilter.removeSerialSpaceForSearch(searchBar.text) else {
            rootView?.collectionView.setEmptyView(message: Resource.UIConstants.Text.searchPhotosIdleMessage)
            return
        }
        print(#function, "검색실행: ", keyword)
        if let oldKeyword = viewModel?.inputRequestSearchPhotos.value, oldKeyword ==  keyword {
            return
        }
        if viewModel?.outputSearchPhotos.value != nil {
            viewModel?.inputCealerResultList.value = ()
        }
        viewModel?.inputRequestSearchPhotos.value = keyword
        rootView?.setSearchBarText(keyword)
        rootView?.collectionView.scrollsToTop = true
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        rootView?.setSearchBarText("")
        return true
    }
    
}
