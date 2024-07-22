//
//  SignUpViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation

class SignUpViewModel: BaseViewModel {
    
    var inputUpdatePresentation: Observable<Void?> = Observable(nil)
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputAddUser: Observable<(String, String)?> = Observable(nil)
    var inputUpdateUser: Observable<(String, String)?> = Observable(nil)
    var inputNickNameValidate: Observable<String?> = Observable(nil)
    
    var outputUpdatePresentation: Observable<Bool> = Observable(false)
    var outputViewDidLoadTrigger: Observable<(String?,String)> = Observable((nil,""))
    var outputAddUserResult: Observable<RepositoryResult> = Observable(RepositoryError.createFailed)
    var outputUpdateUserResult: Observable<RepositoryResult> = Observable(RepositoryError.updatedFailed)
    var outputValidationResult: Observable<String?> = Observable(nil)

    var selectedPhoto: IndexPath?
    private var signUpInfo: (Bool,String)?

    override func transform() {
        inputUpdatePresentation.bind { [weak self] _ in
            self?.outputUpdatePresentation.value = true
        }
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.getUser()
        }
        inputNickNameValidate.bind { [weak self] _ in
            self?.validation()
        }
        inputAddUser.bind { [weak self] _ in
            self?.addUser()
        }
        inputUpdateUser.bind { [weak self] _ in
            self?.updateUser()
        }
    }
    
    private func getUser() {
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        
        let nickname = user?.nickname == nil ? nil : user?.nickname
        let imageName = user?.profileImage == nil ? Resource.Asset.NamedImage.randomProfile.name : user?.profileImage

        guard let imageName, let row = Int(imageName.replacingOccurrences(of: "profile_", with: "")) else {
            return
        }
        print(#function, nickname, imageName, row)
        selectedPhoto = IndexPath(row: row, section: 0)
        outputViewDidLoadTrigger.value = (nickname, imageName)
    }
    
    private func validation() {
        guard let inputText = inputNickNameValidate.value else {
            outputValidationResult.value = nil
            return
        }
        guard let nickname = Utils.textFilter.removeSerialSpace(inputText), inputText.count - nickname.count <= 1 else {
            outputValidationResult.value = TextinputFilterError.haveSpace.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterCount(inputText) {
            outputValidationResult.value = error.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterSpecial(inputText) {
            outputValidationResult.value = error.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterNumber(inputText) {
            outputValidationResult.value = error.nickNameMessage
            return
        }
        outputValidationResult.value = Resource.UIConstants.Text.nickNameSuccess
        signUpInfo = (true, nickname)
    }

    private func addUser() {
        print(#function, "user: ", inputAddUser.value)
        guard let nickname = inputAddUser.value?.0, let imageName = inputAddUser.value?.1 else {
            return
        }
        let user = User(nickname: nickname, profilImage: imageName)
        repository.createItem(user) { [weak self] result in
            switch result {
            case .success(let status):
                self?.outputAddUserResult.value = status
            case .failure(let error):
                self?.outputAddUserResult.value = error
            }
        }
    }
    
    private func updateUser() {
        guard let nickname = inputUpdateUser.value?.0, let imageName = inputUpdateUser.value?.1 else {
            return
        }
        let user: [String : Any] = [
            User.Column.id.name: user?.id,
            User.Column.nickname.name: nickname,
            User.Column.profileImage.name: imageName
        ]
        repository.updateItem(object: object, value: user) { [weak self] result in
            switch result {
            case .success(let status):
                self?.outputUpdateUserResult.value = status
            case .failure(let error):
                self?.outputUpdateUserResult.value = error
            }
        }
    }
}
