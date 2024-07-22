//
//  SignUpView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

final class SignUpView: BaseView {
    
    var delegate: SignUpViewDelegate?
    
    let profileView = UIView()
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.UIConstants.Border.width3
        $0.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.profileImageView
        $0.layer.masksToBounds = true
    }
    let cameraIconView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.cameraIcon
        $0.layer.masksToBounds = true
    }
    let cameraIcon = UIImageView(image: Resource.Asset.SystemImage.cameraFill).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Asset.CIColor.white
    }
    let nickNameTextField = UITextField().then {
        $0.addTarget(self, action: #selector(checkNickName), for: .editingChanged)
    }
    let lineView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    let messageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.Asset.CIColor.red
    }
    let completeButton = UIButton().then {
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.UIConstants.Text.startButton, for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.white, for: .normal)
        $0.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func configHierarchy() {
        addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        addSubview(nickNameTextField)
        addSubview(lineView)
        addSubview(messageLabel)
        addSubview(completeButton)
    }
    
    override func configLayout() {
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cameraIconView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.bottom.trailing.equalToSuperview()
        }
        cameraIcon.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        nickNameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(nickNameTextField.snp.bottom)
        }
        messageLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        completeButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
        }
    }
    
    @objc func checkNickName(_ sender: UITextField) {
        guard let nickname = sender.text else { return }
        delegate?.checkNickName(nickname: nickname)
    }
    
    @objc func signUp() {
        delegate?.addUser()
    }
}
