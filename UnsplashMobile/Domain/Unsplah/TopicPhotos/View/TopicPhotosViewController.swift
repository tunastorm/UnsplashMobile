//
//  TopicPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit




class TopicPhotosViewController: BaseViewController<TopicPhotosView, TopicPhotosViewModel> {
    
    typealias CellType = Photo
    typealias SectionType = TopicID
    typealias SectionDict = [SectionType: [CellType]]
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, CellType>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        guard let imageName = viewModel?.outputProfileImageName.value else { return }
        let view = TopicPhotosCustomView()
        view.configButtonImage(imageName)
        let barButtonItem = UIBarButtonItem(customView: view)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func bindData() {
        viewModel?.outputRequestTopicPhotos.bind { [weak self] result in
            guard let result else { return }
            self?.fetchTopicPhotos(result)
        }
        viewModel?.inputRequestTopicPhotos.value = ()
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
