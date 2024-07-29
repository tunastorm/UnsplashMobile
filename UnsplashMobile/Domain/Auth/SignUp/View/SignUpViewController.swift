//
//  SignUpViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import Toast

protocol SelectPhotoDelegate {
    func getIsUpdatePresentation() -> Bool?
    func setSelectedPhoto(_ indexPath: IndexPath)
    func getSelectedPhoto() -> IndexPath?
    func receiveSelectedPhoto<T>(data: T)
}

protocol SignUpViewDelegate {
    func getIsUpdatePresentation() -> Bool?
    func checkNickName(nickname: String)
    func setMBTI(_ fieldIndex: Int, _ alphabetIndex: Int) 
    func addUser(_ nickname: String, _ imageName: String)
    func deleteUserAlert()
}

final class SignUpViewController: BaseViewController<SignUpView, SignUpViewModel> {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
    }
    
    override func bindData() {
        viewModel?.outputViewDidLoadTrigger.bind { [weak self] userInfo in
            self?.rootView?.configProfileToggle(userInfo.0, userInfo.1, userInfo.2)
            self?.updatePresentationToggle()
        }
        viewModel?.outputValidationResult.bind { [weak self] result in 
            guard let result else { return }
            self?.rootView?.nickNameValidationToggle(result)
            self?.saveButtonToggle(result)
        }
        viewModel?.outputUpdatedMBTIAlphabet.bind{ [weak self] mbtiInfo in
            guard let mbtiInfo else { return }
            self?.rootView?.mbtiAlphabetViewToggle(mbtiInfo.0, mbtiInfo.1)
        }
        viewModel?.outputAddUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
                return
            }
            self?.goTopicPhotosViewController()
        }
        viewModel?.outputUpdateUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
                return
            }
            self?.rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
            self?.popBeforeView(animated: true)
        }
        viewModel?.outputDeleteUserResult.bind { [weak self] result in
            self?.deleteUserComplition()
        }
        viewModel?.inputViewDidLoadTrigger.value = ()
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSelectPhotoView))
        rootView?.addTapGestureProfileView(tapGesture)
    }
    
    func setUpdatePresentation() {
        viewModel?.inputUpdatePresentation.value = ()
    }
    
    private func updatePresentationToggle() {
        if let isUpdatePresentation = viewModel?.outputUpdatePresentation.value, isUpdatePresentation {
            navigationItem.title = Resource.UIConstants.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.UIConstants.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateUser))
            navigationItem.rightBarButtonItem = barButtonItem
        } else {
            navigationItem.title = Resource.UIConstants.Text.profileSetting
        }
        rootView?.updatePresentationViewToggle(viewModel?.outputUpdatePresentation.value)
    }
    
    private func saveButtonToggle(_ result: ValidationStatus) {
        let isValid = result == .allIsValid
        navigationItem.rightBarButtonItem?.isEnabled = isValid
    }
    
    private func goTopicPhotosViewController() {
        let nextVC = UnsplashTabBarController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    @objc private func updateUser() {
        guard let userInfo = rootView?.getNicknameAndImageName() else {
            return
        }
        self.viewModel?.inputUpdateUser.value = userInfo
    }
    
    @objc private func pushSelectPhotoView() {
        let vc = SelectPhotoViewController(view: SelectPhotoView())
        vc.delegate = self
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    private func deleteUserComplition() {
        guard let result = viewModel?.outputDeleteUserResult.value else {
            return
        }
        rootView?.makeToast(result.message, duration: 3.0, position: .bottom)
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        let vc = OnboardingViewController(view: OnboardingView(), viewModel: BaseViewModel())
        sceneDelegate.changeRootVCWithNavi(vc, animated: false)
    }
    
    func getIsUpdatePresentation() -> Bool? {
        return viewModel?.outputUpdatePresentation.value
    }
}

extension SignUpViewController: SelectPhotoDelegate  {
    
    func setSelectedPhoto(_ indexPath: IndexPath) {
        viewModel?.selectedPhoto = indexPath
    }
    
    func getSelectedPhoto() -> IndexPath? {
        return viewModel?.selectedPhoto
    }
    
    func receiveSelectedPhoto<T>(data: T) {
        guard let image = data as? UIImage else { return }
        rootView?.setSelectedProfileImage(image)
    }
}


extension SignUpViewController: SignUpViewDelegate {
    
    func checkNickName(nickname: String) {
        viewModel?.inputNickNameValidate.value = nickname
    }
    
    func setMBTI(_ fieldIndex: Int, _ alphabetIndex: Int) {
        viewModel?.inputSelectMBTIAlphabet.value = (fieldIndex, alphabetIndex)
        viewModel?.inputMBTIValidation.value = ()
    }
    
    func addUser(_ nickname: String, _ imageName: String) {
        self.viewModel?.inputAddUser.value = (nickname, imageName)
    }
    
    func deleteUserAlert() {
        showAlert(style: .alert, title: Resource.UIConstants.Text.secessionAlertTitle, message: Resource.UIConstants.Text.secessionAlertMessage) { [weak self] _ in
            print(#function, "회원탈퇴")
            self?.viewModel?.inputDeleteUser.value = ()
        }
    }
    
}


