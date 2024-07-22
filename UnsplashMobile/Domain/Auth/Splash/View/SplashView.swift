//
//  SplashView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class SplashView: BaseView {
    
    let appTitle = UILabel().then {
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textColor = Resource.CIColor.blue
        $0.text = Resource.Text.appTitle
        $0.numberOfLines = 0
    }
    
    let imageView = UIImageView(image: Resource.Asset.NamedImage.launch).then {
        $0.contentMode = .scaleToFill
    }
    
    let applicantLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Resource.Font.boldSystem16
        $0.textColor = Resource.CIColor.blue
        $0.text = Resource.Text.applicantName
    }
    
    override func configHierarchy() {
        addSubview(appTitle)
        addSubview(imageView)
        addSubview(applicantLabel)
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
        }
        
        applicantLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
