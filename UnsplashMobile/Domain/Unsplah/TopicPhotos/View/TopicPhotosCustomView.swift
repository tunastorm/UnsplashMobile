//
//  TopicPhotosCustomView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/25/24.
//

import UIKit
import SnapKit

final class TopicPhotosCustomView: BaseView {

    var delegate: TopicPhotosCustomViewDelegate?
    
    let button = UIButton()
    
    override func configHierarchy() {
        addSubview(button)
    }
    
    override func configLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        button.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    override func configView() {
        self.isUserInteractionEnabled = false
        button.isUserInteractionEnabled = true
        button.backgroundColor = Resource.Asset.CIColor.lightGray
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .systemFont(ofSize: 0)
        button.layer.borderWidth = Resource.UIConstants.Border.width3
        button.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        button.layer.masksToBounds = true
    }
    
    func configButtonImage(_ imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    @objc private func buttonClicked() {
        print(#function, "버튼 클릭됨")
        delegate?.pushToEditProfile()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
    }
    
}
