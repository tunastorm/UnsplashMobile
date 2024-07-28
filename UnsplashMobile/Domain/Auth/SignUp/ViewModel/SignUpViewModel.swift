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
    var inputMBTIValidation: Observable<Void?> = Observable(nil)
    var inputSelectMBTIAlphabet: Observable<(Int,Int)?> = Observable(nil)
    var inputDeleteUser: Observable<Void?> = Observable(nil)
    
    var outputUpdatePresentation: Observable<Bool> = Observable(false)
    var outputViewDidLoadTrigger: Observable<(String?,String,[Int]?)> = Observable((nil,"",nil))
    var outputAddUserResult: Observable<RepositoryResult> = Observable(RepositoryError.createFailed)
    var outputUpdateUserResult: Observable<RepositoryResult> = Observable(RepositoryError.updatedFailed)
    var outputValidationResult: Observable<ValidationStatus?> = Observable(nil)
    var outputUpdatedMBTIAlphabet: Observable<(Int,Int)?> = Observable(nil)
    var outputDeleteUserResult: Observable<RepositoryResult?> = Observable(nil)

    var selectedPhoto: IndexPath?
    var mbtiList: [Int] = [9,9,9,9]
    private var validationStatus: (ValidationStatus,ValidationStatus) = (.idle, .idle)
   
    override func transform() {
        inputUpdatePresentation.bind { [weak self] _ in
            self?.outputUpdatePresentation.value = true
        }
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.getUser()
        }
        inputNickNameValidate.bind { [weak self] _ in
            self?.validation(target: .nickname)
        }
        inputMBTIValidation.bind { [weak self] _ in
            self?.validation(target: .mbti)
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
        inputDeleteUser.bind { [weak self] _ in
            self?.deleteUser()
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
        selectedPhoto = IndexPath(row: row, section: 0)
        outputViewDidLoadTrigger.value = (nickname, imageName, mbtiList)
    }
    
    private func validation(target: ValidationTarget) {
        var result = outputValidationResult.value
        switch target {
        case .nickname: validationStatus.0 = nicknameValidation()
        case .mbti: validationStatus.1 = mbtiValidation()
        }
        print(#function, "validationStatus: ", validationStatus)
        switch validationStatus {
        case (.nicknameIsValid, .mbtiIsValid): result = .allIsValid
        default:
            result = validationStatus.0
        }
        outputValidationResult.value = result
        print(#function, "outputValidationResult: ",outputValidationResult.value)
    }
    
    private func nicknameValidation() -> ValidationStatus {
        guard let inputText = inputNickNameValidate.value else {
            return .idle
        }
        guard let nickname = Utils.textFilter.removeSerialSpace(inputText), inputText.count - nickname.count <= 1 else {
            return .nicknameWithSpace
        }
        if let error = Utils.textFilter.filterCount(inputText) {
            return error
        }
        if let error = Utils.textFilter.filterSpecial(inputText) {
            return error
        }
        if let error = Utils.textFilter.filterNumber(inputText) {
            return error
        }
        return .nicknameIsValid
    }
    
    private func mbtiValidation() -> ValidationStatus {
        print(#function,"| start | validationStatus: ", validationStatus)
        let mbtiCheckSum = mbtiList.reduce(0, +)
        if  mbtiCheckSum > 4 ||  mbtiCheckSum < 0 {
            return ValidationStatus.mbtiInCorrect
        }
        return ValidationStatus.mbtiIsValid
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
        guard let nickname = inputUpdateUser.value?.0, let imageName = inputUpdateUser.value?.1  else {
            return
        }
        guard mbtiList.reduce(0,+) <= 4 else { // 리스트가 0 or 1 인 요소 4개를 가지고 있으므로 합이 4초과인 경우 예외처리
            return
        }
        let user: [String : Any] = [
            User.Column.id.name: user?.id,
            User.Column.nickname.name: nickname,
            User.Column.profileImage.name: imageName,
            User.Column.mbti.name: MBTI.combination(list: mbtiList)
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
    
    private func deleteUser() {
        guard let user else { return }
        repository.deleteUser(user) { [weak self] result in
            switch result {
            case .success(let status): self?.outputDeleteUserResult.value = status
            case .failure(let error): self?.outputDeleteUserResult.value = error
            }
        }
    }
}
