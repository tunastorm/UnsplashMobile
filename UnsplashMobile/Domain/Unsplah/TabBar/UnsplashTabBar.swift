//
//  UnsplashTabBar.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class UnsplashTabBarController: UITabBarController {
        
    private let topicNavi = UINavigationController(rootViewController: TopicPhotosViewController(view:TopicPhotosView(), viewModel: TopicPhotosViewModel()))
    private let randomNavi = UINavigationController(rootViewController: RandomPhotoViewController(view: RandomPhotoView(), viewModel: RandomPhotoViewModel()))
    private let searchNavi = UINavigationController(rootViewController: SearchPhotosViewController(view: SearchPhotosView(), viewModel: SearchPhotosViewModel()))
    private let likeNavi = UINavigationController(rootViewController: LikedPhotosViewController(view: LikedPhotosView(), viewModel: LikedPhotosViewModel()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tabBar.tintColor = Resource.Asset.CIColor.black
        tabBar.unselectedItemTintColor = Resource.Asset.CIColor.gray
        tabBar.layer.addBorder([.top], color: Resource.Asset.CIColor.lightGray, width: Resource.UIConstants.Border.width1)
        
        let topicTabBar = UITabBarItem(title: "", image: Resource.Asset.NamedImage.tabTrendInActive, tag: 0)
        topicTabBar.selectedImage = Resource.Asset.NamedImage.tabTrend
//
//        let randomTabBar = UITabBarItem(title: "", image: Resource.Asset.NamedImage.tabRandomInActive, tag: 1)
//        randomTabBar.selectedImage = Resource.Asset.NamedImage.tabRandom
//
        let searchTabBar = UITabBarItem(title: "", image: Resource.Asset.NamedImage.tabSearchInActive, tag: 1)
        searchTabBar.selectedImage = Resource.Asset.NamedImage.tabSearch
        
        let likeTabBar = UITabBarItem(title: "", image: Resource.Asset.NamedImage.tabLikeInActive, tag: 2)
        likeTabBar.selectedImage = Resource.Asset.NamedImage.like
        
        topicNavi.tabBarItem = topicTabBar
//        randomNavi.tabBarItem = randomTabBar
        searchNavi.tabBarItem = searchTabBar
        likeNavi.tabBarItem = likeTabBar

        setViewControllers([topicNavi, searchNavi, likeNavi], animated: true)
    }

}


