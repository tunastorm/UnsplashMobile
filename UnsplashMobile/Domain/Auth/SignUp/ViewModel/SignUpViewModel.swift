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
    var inputSelectMBTIAlphabet: Observable<(Int,Int)?> = Observable(nil)
    
    var outputUpdatePresentation: Observable<Bool> = Observable(false)
    var outputViewDidLoadTrigger: Observable<(String?,String,[Int]?)> = Observable((nil,"",nil))
    var outputAddUserResult: Observable<RepositoryResult> = Observable(RepositoryError.createFailed)
    var outputUpdateUserResult: Observable<RepositoryResult> = Observable(RepositoryError.updatedFailed)
    var outputValidationResult: Observable<(Bool, String)?> = Observable(nil)
    var outputUpdatedMBTIAlphabet: Observable<(Int,Int)?> = Observable(nil)

    var selectedPhoto: IndexPath?
    var mbtiList: [Int] = [Int.random(in: 0...1), Int.random(in: 0...1), Int.random(in: 0...1), Int.random(in: 0...1)]
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
        inputSelectMBTIAlphabet.bind { [weak self] _ in
            self?.setMBTIList()
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
        let mbtiList = user?.mbti == nil ? mbtiList : MBTI.convertToIntegerArray(combination: user?.mbti ?? "ESTJ")
        guard let imageName, let row = Int(imageName.replacingOccurrences(of: "profile_", with: "")) else {
            return
        }
        print(#function, nickname, imageName, row, mbtiList)
        selectedPhoto = IndexPath(row: row, section: 0)
        outputViewDidLoadTrigger.value = (nickname, imageName, mbtiList)
    }
    
    private func validation() {
        guard let inputText = inputNickNameValidate.value else {
            outputValidationResult.value = nil
            return
        }
        guard let nickname = Utils.textFilter.removeSerialSpace(inputText), inputText.count - nickname.count <= 1 else {
            outputValidationResult.value = (false, TextinputFilterError.haveSpace.nickNameMessage)
            return
        }
        if let error = Utils.textFilter.filterCount(inputText) {
            outputValidationResult.value = (false, error.nickNameMessage)
            return
        }
        if let error = Utils.textFilter.filterSpecial(inputText) {
            outputValidationResult.value = (false, error.nickNameMessage)
            return
        }
        if let error = Utils.textFilter.filterNumber(inputText) {
            outputValidationResult.value = (false, error.nickNameMessage)
            return
        }
        outputValidationResult.value = (true, Resource.UIConstants.Text.nickNameSuccess)
        signUpInfo = (true, nickname)
    }
    
    private func setMBTIList() {
        guard let indexInfo = inputSelectMBTIAlphabet.value else {
            return
        }
        mbtiList[indexInfo.0] = indexInfo.1
        print(#function, "mbtiList: ", mbtiList)
        outputUpdatedMBTIAlphabet.value = indexInfo
    }

    private func addUser() {
        print(#function, "user: ", inputAddUser.value)
        guard let nickname = inputAddUser.value?.0, let imageName = inputAddUser.value?.1 else {
            return
        }
        guard mbtiList.reduce(0,+) <= 4 else { // 리스트가 0 or 1 인 요소 4개를 가지고 있으므로 합이 4초과인 경우 예외처리
            return
        }
        let mbti = MBTI.combination(list: mbtiList)
        let user = User(nickname: nickname, profilImage: imageName, mbti: mbti)
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
