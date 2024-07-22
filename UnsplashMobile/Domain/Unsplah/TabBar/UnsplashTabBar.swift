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
        
        topicNavi.tabBarItem = UITabBarItem(title: "", image: Resource.Asset.NamedImage.tabTrendInActive, tag: 0)
        randomNavi.tabBarItem = UITabBarItem(title: "",
                                                  image: Resource.Asset.NamedImage.tabRandomInActive, tag: 1)
        searchNavi.tabBarItem = UITabBarItem(title: "",
                                                  image: Resource.Asset.NamedImage.tabSearchInActive, tag: 2)
        likeNavi.tabBarItem = UITabBarItem(title: "",
                                                 image: Resource.Asset.NamedImage.tabLikeInActive, tag: 3)

        setViewControllers([topicNavi, randomNavi, searchNavi, likeNavi], animated: true)
    }
}


