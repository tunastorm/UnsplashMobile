//
//  OnboardingView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

final class OnboardingView: BaseView {
    
    var delegate: OnboardingViewDelegate?
    
    private let appTitle = UILabel().then {
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textColor = Resource.Asset.CIColor.blue
        $0.text = Resource.UIConstants.Text.appTitle
        $0.numberOfLines = 0
    }
    
    private let imageView = UIImageView(image: Resource.Asset.NamedImage.launch).then {
        $0.contentMode = .scaleToFill
    }
    
    private let startButton = UIButton().then {
        $0.titleLabel?.font = Resource.Asset.Font.boldSystem16
        $0.setTitleColor(Resource.Asset.CIColor.white, for: .normal)
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.UIConstants.Text.compeleteButton, for: .normal)
        $0.addTarget(self, action: #selector(goSignUpViewController), for: .touchUpInside)
    }
    
    override func configHierarchy() {
        addSubview(appTitle)
        addSubview(imageView)
        addSubview(startButton)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(300)
            $0.center.equalTo(safeAreaLayoutGuide)
        }
        appTitle.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            $0.bottom.equalTo(imageView.snp.top).offset(-30)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        startButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc func goSignUpViewController() {
        delegate?.pushToSignUpViewController()
    }
}
