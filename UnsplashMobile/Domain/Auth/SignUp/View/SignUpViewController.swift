//
//  SignUpViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

protocol SelectPhotoDelegate {
    func getIsUpdatePresentation() -> Bool?
    func setSelectedPhoto(_ indexPath: IndexPath)
    func getSelectedPhoto() -> IndexPath?
    func receiveSelectedPhoto<T>(data: T)
}

class SignUpViewController: BaseViewController<SignUpView, SignUpViewModel> {
   
    let profileView = UIView()
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.Border.width3
        $0.layer.borderColor = Resource.CIColor.blue.cgColor
        $0.layer.cornerRadius = Resource.CornerRadious.profileImageView
        $0.layer.masksToBounds = true
    }
    let cameraIconView = UIView().then {
        $0.backgroundColor = Resource.CIColor.blue
        $0.layer.cornerRadius = Resource.CornerRadious.cameraIcon
        $0.layer.masksToBounds = true
    }
    let cameraIcon = UIImageView(image: Resource.Asset.SystemImage.cameraFill).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.CIColor.white
    }
    let nickNameTextField = UITextField().then {
        $0.addTarget(self, action: #selector(checkNickName), for: .editingChanged)
    }
    let lineView = UIView().then {
        $0.backgroundColor = Resource.CIColor.lightGray
    }
    let messageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.CIColor.red
    }
    let completeButton = UIButton().then {
        $0.backgroundColor = Resource.CIColor.blue
        $0.layer.cornerRadius = Resource.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.Text.startButton, for: .normal)
        $0.setTitleColor(Resource.CIColor.white, for: .normal)
        $0.addTarget(self, action: #selector(addUser), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(nickNameTextField)
        view.addSubview(lineView)
        view.addSubview(messageLabel)
        view.addSubview(completeButton)
    }
    
    override func configLayout() {
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(nickNameTextField.snp.bottom)
        }
        messageLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        completeButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
        }
    }
    
    override func bindData() {
        viewModel?.outputViewDidLoadTrigger.bind { [weak self] userInfo in
            self?.configProfileToggle(userInfo.0, userInfo.1)
            self?.updatePresentationToggle()
        }
        viewModel?.outputValidationResult.bind { [weak self] result in
            self?.messageLabel.text = result
        }
        viewModel?.outputAddUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
                return
            }
            self?.goMainViewController()
        }
        viewModel?.outputUpdateUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
                return
            }
            self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
            self?.popBeforeView(animated: true)
        }
        viewModel?.inputViewDidLoadTrigger.value = ()
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func setUpdatePresentation() {
        viewModel?.inputUpdatePresentation.value = ()
    }
    
    private func configProfileToggle(_ nickname: String?, _ imageName: String) {
        print(#function, nickname, imageName)
        profileImageView.image = UIImage(named: imageName)
        nickNameTextField.text = nickname
    }
    
    private func updatePresentationToggle() {
        print(#function, viewModel?.outputUpdatePresentation.value )
        if let isUpdatePresentation = viewModel?.outputUpdatePresentation.value, isUpdatePresentation {
            navigationItem.title = Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateUser))
            navigationItem.rightBarButtonItem = barButtonItem
            completeButton.isHidden = true
            nickNameTextField.placeholder = nil
        } else {
            navigationItem.title = Resource.Text.profileSetting
            completeButton.isHidden = false
            nickNameTextField.placeholder = Resource.Text.nickNamePlaceholder
        }
    }
    
    func goMainViewController() {
        let nextVC = SplashViewController(view: SplashView(), viewModel: SplashViewModel())
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    @objc private func addUser() {
        guard let nickname = nickNameTextField.text, let imageName = profileImageView.image?.name else {
            return
        }
        self.viewModel?.inputAddUser.value = (nickname, imageName)
    }
    
    @objc private func updateUser() {
        guard let nickname = nickNameTextField.text, let imageName = profileImageView.image?.name else {
            return
        }
        self.viewModel?.inputUpdateUser.value = (nickname, imageName)
    }
    
    @objc func checkNickName(_ sender: UITextField) {
        viewModel?.inputNickNameValidate.value = sender.text
    }
    
    @objc func pushSelectPhotoView() {
//        let vc = SelectPhotoViewController()
//        vc.delegate = self
//        
//        pushAfterView(view: vc, backButton: true, animated: true)
    }
}

extension SignUpViewController: SelectPhotoDelegate  {
    func getIsUpdatePresentation() -> Bool? {
        return viewModel?.outputUpdatePresentation.value
    }
    
    func setSelectedPhoto(_ indexPath: IndexPath) {
        viewModel?.selectedPhoto = indexPath
    }
    
    func getSelectedPhoto() -> IndexPath? {
        return viewModel?.selectedPhoto
    }
    
    func receiveSelectedPhoto<T>(data: T) {
        guard let image = data as? UIImage else { return }
        profileImageView.image = image
    }
}


