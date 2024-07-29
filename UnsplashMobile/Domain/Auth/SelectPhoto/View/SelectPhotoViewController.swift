//
//  SelectPhotoViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit


final class SelectPhotoViewController: BaseViewController<SelectPhotoView, BaseViewModel> {
    
    var delegate: SelectPhotoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUpdateViewToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configProfileImage()
    }
    
    func configProfileImage() {
        guard let delegate, let row = delegate.getSelectedPhoto()?.row, let selectedPhoto = Resource.Asset.NamedImage.profileImage(number: row) else {
            return
        }
        rootView?.profileImageView.image = selectedPhoto
        rootView?.collectionView.reloadData()
    }
    
    override func configInteraction() {
        rootView?.collectionView.delegate = self
        rootView?.collectionView.dataSource = self
        rootView?.collectionView.register(SelectPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
    }
    
    func configUpdateViewToggle() {
        guard let delegate, let isUpdatePresentation = delegate.getIsUpdatePresentation() else {
            return
        }
        navigationItem.title = isUpdatePresentation ? Resource.UIConstants.Text.editProfileTitle : Resource.UIConstants.Text.profileSetting
    }
}
