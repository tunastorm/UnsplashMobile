//
//  SignUpView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then


final class SignUpView: BaseView {
    
    var delegate: SignUpViewDelegate?
    
    private let profileView = UIView()
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.UIConstants.Border.width3
        $0.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        $0.layer.masksToBounds = true
    }
    private let cameraIconView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.cameraIcon
        $0.layer.masksToBounds = true
    }
    private let cameraIcon = UIImageView(image: Resource.Asset.SystemImage.cameraFill).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Asset.CIColor.white
    }
    private let nickNameTextField = UITextField().then {
        $0.addTarget(self, action: #selector(checkNickName), for: .editingChanged)
    }
    private let lineView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    private let messageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.Asset.CIColor.red
    }
    
    private let mbtiLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.mbtiLabel
    }
    
    private let mbtiHorizontalStackView = UIStackView()
    
    private let mbtiAlphabetLabel: (Int, String) -> UILabel = { index, alphabet in
        let label = UILabel()
        label.text = alphabet
        label.textAlignment = .center
        label.font = Resource.Asset.Font.system20
        label.layer.cornerRadius = Resource.UIConstants.CornerRadious.mbtiButton
        label.layer.masksToBounds = true
        label.tag = index
        return label
    }
    
    private let completeButton = UIButton().then {
        $0.backgroundColor = Resource.Asset.CIColor.gray
        $0.layer.cornerRadius = Resource.UIConstants.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.UIConstants.Text.compeleteButton, for: .normal)
        $0.setTitleColor(Resource.Asset.CIColor.white, for: .normal)
        $0.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        $0.isUserInteractionEnabled = false
    }
    
    private let deleteButton = UIButton().then {
        $0.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = Resource.Asset.Font.system15
        $0.setTitleColor(Resource.Asset.CIColor.blue, for: .normal)
        $0.setTitle(Resource.UIConstants.Text.secessionLabel, for: .normal)
        $0.setUnderline()
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
        addSubview(mbtiLabel)
        addSubview(mbtiHorizontalStackView)
        addSubview(deleteButton)
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
        mbtiLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(messageLabel).multipliedBy(0.3)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        mbtiHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.width.equalTo(messageLabel).multipliedBy(0.7)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.leading.equalTo(mbtiLabel.snp.trailing)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        completeButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(120)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        configMBTIStackView()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height * 0.5
        mbtiHorizontalStackView.arrangedSubviews.forEach { view in
            let verticalStackView = view as? UIStackView
            verticalStackView?.arrangedSubviews.forEach { view in
                guard let label = view.subviews.first else { return }
                label.layer.cornerRadius = label.frame.height * 0.5
            }
        }
    }
    
    private func configMBTIStackView() {
        MBTI.allCases.forEach { field in
            configVerticalStackView(field)
            mbtiAlphabetViewToggle(field.rawValue, 0)
        }
    }
 
    private func configVerticalStackView(_ field: MBTI) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        mbtiHorizontalStackView.addArrangedSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(mbtiHorizontalStackView).multipliedBy(0.25)
        }
        
        field.valuePair.enumerated().forEach { index, alphabet in
            let view = UIView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(mbtiAlphabetViewClicked))
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.height.equalTo(60)
            }
            let label = mbtiAlphabetLabel(index, alphabet)
            view.tag = field.rawValue
            view.addGestureRecognizer(tap)
            view.addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(5)
            }
        }
        mbtiHorizontalStackView.addArrangedSubview(stackView)
    }
    
    @objc private func checkNickName(_ sender: UITextField) {
        guard let nickname = sender.text else { return }
        delegate?.checkNickName(nickname: nickname)
    }
    
    @objc private func mbtiAlphabetViewClicked(_ sender: UITapGestureRecognizer) {
        guard let fieldIndex = sender.view?.tag, let alphabetIndex = sender.view?.subviews.first?.tag else {
            return
        }
        delegate?.setMBTI(fieldIndex, alphabetIndex)
    }
    
    @objc private func signUp() {
        guard let nickname = nickNameTextField.text, let imageName = profileImageView.image?.name else {
            return
        }
        delegate?.addUser(nickname, imageName)
    }
    
    @objc private func deleteButtonClicked(_ sender: UIButton) {
        delegate?.deleteUserAlert()
    }
    
    func addTapGestureProfileView(_ tapGesture: UITapGestureRecognizer) {
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func configProfileToggle(_ nickname: String?, _ imageName: String, _ mbtiList: [Int]?){
        profileImageView.image = UIImage(named: imageName)
        nickNameTextField.text = nickname
        layoutIfNeeded()
        guard let mbtiList else { return }
        mbtiList.enumerated().forEach { fieldIndex, alphabetIndex in
            mbtiAlphabetViewToggle(fieldIndex, alphabetIndex)
        }
    }
    
    func updatePresentationViewToggle(_ isUpdatePresentation: Bool?) {
        if let isUpdatePresentation, isUpdatePresentation {
            completeButton.isHidden = true
            deleteButton.isHidden = false
            nickNameTextField.placeholder = ""
        } else {
            completeButton.isHidden = false
            deleteButton.isHidden = true
            nickNameTextField.placeholder = Resource.UIConstants.Text.nickNamePlaceholder
        }
    }
    
    func mbtiAlphabetViewToggle(_ fieldIndex : Int, _ alphabetIndex: Int) {
        let verticalStackView = mbtiHorizontalStackView.arrangedSubviews[fieldIndex] as? UIStackView
        verticalStackView?.arrangedSubviews.enumerated().forEach{ index, view in
            let label = view.subviews.first as? UILabel
            if index == alphabetIndex {
                label?.textColor = Resource.Asset.CIColor.white
                label?.backgroundColor = Resource.Asset.CIColor.blue
                label?.layer.borderWidth = 0
                return
            }
            label?.backgroundColor = .clear
            label?.layer.borderColor = Resource.Asset.CIColor.gray.cgColor
            label?.layer.borderWidth = Resource.UIConstants.Border.width1
            label?.textColor = Resource.Asset.CIColor.gray
        }
    }
    
    func nickNameValidationToggle(_ result: ValidationStatus) {
        let isValid = result == .allIsValid
        completeButton.isUserInteractionEnabled = isValid
        completeButton.backgroundColor =  isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.gray
        messageLabel.text = result.message
        messageLabel.textColor = (isValid || result == .nicknameIsValid)
        ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.red
    }
    
    func setSelectedProfileImage(_ image: UIImage) {
        profileImageView.image = image
    }
    
    func getNicknameAndImageName() -> (String, String)? {
        guard let nickname = nickNameTextField.text, let imageName = profileImageView.image?.name else {
            return nil
        }
        return (nickname, imageName)
    }

}
