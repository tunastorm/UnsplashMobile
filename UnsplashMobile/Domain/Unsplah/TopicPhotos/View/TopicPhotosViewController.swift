//
//  TopicPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit
import SnapKit
import Then


protocol TopicPhotosCustomViewDelegate {
    func pushToEditProfile()
}


class TopicPhotosViewController: BaseViewController<TopicPhotosView, TopicPhotosViewModel> {
  
    typealias CellType = Photo
    typealias SectionType = TopicID
    typealias SectionDict = [SectionType: [CellType]]
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, CellType>?
    
    lazy var editProfileButton = {
        guard let image = viewModel?.outputProfileImageName.value else { return UIButton()}
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)
        button.contentMode = .scaleToFill
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(pushToEditProfile), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = Resource.UIConstants.Border.width3
        button.layer.borderColor = Resource.Asset.CIColor.blue.cgColor
        return button
    }()
    
    let customView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputGetUser.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        guard let imageName = viewModel?.outputProfileImageName.value else {
            return
        }
        setCustomView()
        let item = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = item
    }
    
    override func bindData() {
        viewModel?.outputProfileImageName.bind { [weak self] _ in
            self?.fetchProfileImage()
        }
        viewModel?.outputRequestTopicPhotos.bind { [weak self] result in
            guard let result else { return }
            self?.fetchTopicPhotos(result)
        }
        viewModel?.inputGetUser.value = ()
        viewModel?.inputRequestTopicPhotos.value = ()
    }
    
    private func setCustomView() {
          customView.addSubview(editProfileButton)
          editProfileButton.snp.makeConstraints { make in
              make.edges.equalToSuperview()
              make.width.height.equalTo(40)
          }
    }
    
    private func fetchProfileImage() {
        guard let imageName = viewModel?.outputProfileImageName.value else { return }
        let image = UIImage(named: imageName)
        editProfileButton.setImage(image, for: .normal)
    }
    
    private func fetchTopicPhotos(_ result: [TopicID : Result<[Photo],APIError>]) {
        var sectionDict: [TopicID : [Photo]] = [:]
        result.keys.forEach { [weak self] topic in
            switch result[topic] {
            case .success(let photoList): sectionDict[topic] = photoList
            case .failure(let error):
                self?.rootView?.makeToast(error.message, duration: 3.0, position: .bottom, title:error.title)
            default: break
            }
        }
        guard sectionDict.keys.count > 0 else { return }
        configureDataSource(Array(sectionDict.keys))
        updateSnapShot(sectionDict)
    }
    
}

extension TopicPhotosViewController: TopicPhotosCustomViewDelegate {
    
    @objc func pushToEditProfile() {
       print(#function, "클릭됨")
       let vc = SignUpViewController(view: SignUpView(), viewModel: SignUpViewModel())
       vc.viewModel?.inputUpdatePresentation.value = ()
       pushAfterView(view: vc, backButton: true, animated: true)
   }
    
}



