//
//  LikedPhotosViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

protocol LikedPhotosViewDelegate {
    func queryWithSortFilter(_ sort: Int?)
}

protocol LikedPhotosCollectionViewCellDelegate {
    func likeButtonToggleEvent(isAdd: Bool, _ item: LikedPhoto)
}


final class LikedPhotosViewController: BaseViewController<LikedPhotosView, LikedPhotosViewModel> {

    var likedPhotosDataSource: UICollectionViewDiffableDataSource<SearchPhotosSection, LikedPhoto>?
    var filterDataSource: UICollectionViewDiffableDataSource<FilterSection, ColorFilter>?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView?.filterInteractionToggle()
        viewModel?.inputGetLikedList.value = ()
        rootView?.layoutIfNeeded()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: false)
        navigationItem.title = Resource.UIConstants.Text.likedPhotosTitle
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        viewModel?.outputLikedPhotos.bind({ [weak self] _ in
            self?.fetchLikedPhotos()
        })
        viewModel?.outputLikeButtonClickResult.bind { [weak self] result in
            guard let result else { return }
            self?.rootView?.makeToast(result.likeButtonMessage, duration: 3.0, position: .bottom)
        }
        viewModel?.outputDeleteLikedPhotoFromSnapshot.bind { [weak self] _ in
            self?.deleteLikedPhoto()
        }
        configureFilterDataSource()
        configureLikedPhotosDataSource()
        updateFilterSnapShot()
    }
    
    private func fetchLikedPhotos() {
        guard let result = viewModel?.outputLikedPhotos.value else {
            rootView?.filterInteractionToggle()
            return
        }
        var photoList: [LikedPhoto] = []
        switch result {
        case .success(let likedPhotos):
            photoList = likedPhotos
        case .failure(let error):
            self.rootView?.makeToast(error.message, duration: 3.0, position: .bottom)
            return
        }
        rootView?.noLikedPhotosToggle(isNoLiked: photoList.count == 0)
        updateLikedPhotosSnapShot(photoList)
    }
    
    
    private func deleteLikedPhoto() {
        guard let likedPhotos = viewModel?.outputDeleteLikedPhotoFromSnapshot.value,
              let dataSource = likedPhotosDataSource else { return }
        if let id = likedPhotos.first?.id {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.LikedPhotosView.searchPhotos.name), object: nil, userInfo: ["id": id])
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(likedPhotos)
        likedPhotosDataSource?.apply(snapshot, animatingDifferences: true)
        viewModel?.outputDeleteLikedPhotoFromSnapshot.value = nil
    }
    
    func pushToPhotoDetailViewController(_ indexPath: IndexPath, _ item: LikedPhoto) {
        var colorFilter: IndexPath?
        if let index = item.colorFilter {
            colorFilter = IndexPath(row: index, section: 0)
        }
        let photo = Photo.init(managedObject: item)
        let vc = PhotoDetailViewController(view: PhotoDetailView(), viewModel: PhotoDetailViewModel())
        vc.viewModel?.inputSetPhotoDetailData.value = (indexPath, photo, colorFilter)
        vc.viewModel?.beforeViewController = .likedPhotos
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
}

extension LikedPhotosViewController: LikedPhotosViewDelegate {
    
    func queryWithSortFilter(_ sort: Int?) {
        viewModel?.inputSortFilter.value = sort
    }
    
}

extension LikedPhotosViewController: LikedPhotosCollectionViewCellDelegate {
    
    func likeButtonToggleEvent(isAdd: Bool, _ item: LikedPhoto) {
        viewModel?.inputLikeButtonClicked.value = (isAdd,  item)
    }
    
}


