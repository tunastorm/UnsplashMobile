//
//  SelectPhotoCollectionViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

extension SelectPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Resource.Asset.NamedImage.allProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! SelectPhotoCollectionViewCell
        
        let thisPhoto = Resource.Asset.NamedImage.allProfile[indexPath.row]
        cell.configCell(image: thisPhoto)
        guard let selectedCell = delegate?.getSelectedPhoto(), let selectedPhoto = Resource.Asset.NamedImage.profileImage(number: selectedCell.row) else {
            return cell
        }
        // 이름이 같을 경우 해당 셀을 선택된 상태로 설정
        // -> 페이지 로드시 이전 화면에서 랜덤 생성된 이미지가 기본 선택됨
        if selectedPhoto.name == thisPhoto.name {
            cell.configSelectedUI()
            delegate?.setSelectedPhoto(indexPath)
        } else {
            cell.configUnselectedUI()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate else { return }
        if let selectedCell = delegate.getSelectedPhoto() {
            let lastCell = collectionView.cellForItem(at: selectedCell) as! SelectPhotoCollectionViewCell
            lastCell.configUnselectedUI()
        }
        delegate.setSelectedPhoto(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! SelectPhotoCollectionViewCell
        cell.configSelectedUI()
        rootView?.profileImageView.image = cell.imageView.image
        delegate.receiveSelectedPhoto(data: cell.imageView.image)
    }
}
