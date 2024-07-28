//
//  OnboardingViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

protocol OnboardingViewDelegate {
    func pushToSignUpViewController()
}


final class OnboardingViewController: BaseViewController<OnboardingView, BaseViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationbar(navigationColor: Resource.Asset.CIColor.white, shadowImage: false)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    
    func pushToSignUpViewController() {
        let vc = SignUpViewController(view: SignUpView(), viewModel: SignUpViewModel())
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
}

