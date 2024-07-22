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

protocol SignUpViewDelegate {
    
    func checkNickName(nickname: String)
    func addUser()
}

class SignUpViewController: BaseViewController<SignUpView, SignUpViewModel> {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
    }
    
    override func bindData() {
        viewModel?.outputViewDidLoadTrigger.bind { [weak self] userInfo in
            self?.configProfileToggle(userInfo.0, userInfo.1)
            self?.updatePresentationToggle()
        }
        viewModel?.outputValidationResult.bind { [weak self] result in
            self?.rootView?.messageLabel.text = result
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
        rootView?.profileView.addGestureRecognizer(tapGesture)
    }
    
    func setUpdatePresentation() {
        viewModel?.inputUpdatePresentation.value = ()
    }
    
    private func configProfileToggle(_ nickname: String?, _ imageName: String) {
        rootView?.profileImageView.image = UIImage(named: imageName)
        rootView?.nickNameTextField.text = nickname
    }
    
    private func updatePresentationToggle() {
        print(#function, viewModel?.outputUpdatePresentation.value )
        if let isUpdatePresentation = viewModel?.outputUpdatePresentation.value, isUpdatePresentation {
            navigationItem.title = Resource.UIConstants.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.UIConstants.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateUser))
            navigationItem.rightBarButtonItem = barButtonItem
            rootView?.completeButton.isHidden = true
            rootView?.nickNameTextField.placeholder = ""
        } else {
            navigationItem.title = Resource.UIConstants.Text.profileSetting
            rootView?.completeButton.isHidden = false
            rootView?.nickNameTextField.placeholder = Resource.UIConstants.Text.nickNamePlaceholder
        }
    }
    
    func goMainViewController() {
        let nextVC = SplashViewController(view: SplashView(), viewModel: SplashViewModel())
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    @objc private func updateUser() {
        guard let nickname = rootView?.nickNameTextField.text, let imageName = rootView?.profileImageView.image?.name else {
            return
        }
        self.viewModel?.inputUpdateUser.value = (nickname, imageName)
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
        rootView?.profileImageView.image = image
    }
}


extension SignUpViewController: SignUpViewDelegate {
    
    func checkNickName(nickname: String) {
        viewModel?.inputNickNameValidate.value = nickname
    }
    
    func addUser() {
        guard let nickname = rootView?.nickNameTextField.text, let imageName = rootView?.profileImageView.image?.name else {
            return
        }
        self.viewModel?.inputAddUser.value = (nickname, imageName)
    }
    
}


