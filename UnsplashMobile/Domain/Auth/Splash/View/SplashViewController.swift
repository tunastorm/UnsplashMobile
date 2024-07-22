//
//  ViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

class SplashViewController: BaseViewController<BaseView, SplashViewModel> {
    
    private var nextView: UIViewController?
    private var withNavi: Bool?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        viewModel?.inputGetUser.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationbar(navigationColor: Resource.Asset.CIColor.white, shadowImage: false)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }

    override func bindData() {
        viewModel?.outputUser.bind { [weak self]_  in
            self?.authonticateUser()
        }
    }
    
    func authonticateUser() {
        if let user = viewModel?.outputUser.value {
            let tabBar = UnsplashTabBarController()
            nextView = tabBar
            withNavi = false
        } else {
            let nextVC = OnboadingViewController(view: OnboardingView())
            nextView = nextVC
            withNavi = true
        }
        // 2초 간 대기후 화면 전환
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeRootview), userInfo: nil, repeats: false)
        timer.tolerance = 0.2
    }
    
    @objc func changeRootview() {
        guard let nextView else { return }
        if let withNavi, withNavi {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVCWithNavi(nextView, animated: false)
        } else {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextView, animated: false)
        }
    }
}
