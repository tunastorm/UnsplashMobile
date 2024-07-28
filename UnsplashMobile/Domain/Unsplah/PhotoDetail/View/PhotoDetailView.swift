//
//  SearchPhotoDetailView.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/27/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

enum segmentedView: Int, CaseIterable {
    case views
    case download
    
    var krName: String {
        return switch self {
        case .views: "조회"
        case .download: "다운로드"
        }
    }
    
    static func krAllCases() -> [String] {
        return segmentedView.allCases.map { $0.krName }
    }
}


final class PhotoDetailView: BaseView {
    
    var delegate: PhotoDetailViewDelegate?
    
    private let artistView = UIView()
    
    private let profileImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    private let userInfoView = UIView()
    
    private let userName = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textAlignment = .left
    }
    
    private let createdDate = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textAlignment = .left
        $0.textColor = Resource.Asset.CIColor.black
    }
    
    private let likeButton = UIButton().then {
        $0.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        $0.setImage(Resource.Asset.NamedImage.likeInActive, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.tintColor = Resource.Asset.CIColor.gray
    }
    
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    private let infoLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem18
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.photoDetailInfoLabel
    }
    
    private let infoView = UIView()
    
    private let sizeInfoLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.photoDetailSizeInfoLabel
    }
    
    private let sizeLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system14
        $0.textAlignment = .right
    }
    
    private let viewInfoLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.photoDetailViewInfoLabel
    }
    
    private let viewCountLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system14
        $0.textAlignment = .right
    }
    
    private let downloadInfoLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.photoDetailViewDownloadInfoLabel
    }
    
    private let downloadCountLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system14
        $0.textAlignment = .right
    }
    
    private let chartLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem18
        $0.textAlignment = .left
        $0.text = Resource.UIConstants.Text.photoDetailChartLabel
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentedView.krAllCases())
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
    }()
    
    let viewCountView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    let downloadCountView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    var showingView: Int? {
        didSet {
            guard let showingView = showingView else { return }
            if showingView == 0 {
                viewCountView.isHidden = false
                downloadCountView.isHidden = true
            } else if showingView == 1 {
                viewCountView.isHidden = true
                downloadCountView.isHidden = false
            }
        }
    }
    
    override func configHierarchy() {
        addSubview(artistView)
        artistView.addSubview(profileImageView)
        artistView.addSubview(userInfoView)
        userInfoView.addSubview(userName)
        userInfoView.addSubview(createdDate)
        artistView.addSubview(likeButton)
        addSubview(photoImageView)
        addSubview(infoLabel)
        addSubview(infoView)
        infoView.addSubview(sizeInfoLabel)
        infoView.addSubview(sizeLabel)
        infoView.addSubview(viewInfoLabel)
        infoView.addSubview(viewCountLabel)
        infoView.addSubview(downloadInfoLabel)
        infoView.addSubview(downloadCountLabel)
        addSubview(chartLabel)
        addSubview(segmentedControl)
    }
    
    override func configLayout() {
        artistView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.leading.verticalEdges.equalToSuperview().inset(7)
        }
        userInfoView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(11)
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
        userName.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.horizontalEdges.equalToSuperview()
        }
        createdDate.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.top.equalTo(userName.snp.bottom).offset(2)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.trailing.verticalEdges.equalToSuperview().inset(11)
        }
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(artistView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        infoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(photoImageView).multipliedBy(0.25)
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        infoView.snp.makeConstraints { make in
            make.height.equalTo(66)
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.leading.equalTo(infoLabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        sizeInfoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.leading.equalToSuperview()
        }
        sizeLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview()
            make.leading.equalTo(sizeInfoLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
        }
        viewInfoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(sizeInfoLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview()
        }
        viewCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(sizeLabel.snp.bottom).offset(6)
            make.leading.equalTo(viewInfoLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
        }
        downloadInfoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(viewInfoLabel.snp.bottom).offset(6)
            make.leading.bottom.equalToSuperview()
        }
        downloadCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(viewCountLabel.snp.bottom).offset(6)
            make.leading.equalTo(downloadInfoLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
        }
        chartLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(infoLabel)
            make.top.equalTo(infoView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        segmentedControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(140)
            make.top.equalTo(infoView.snp.bottom).offset(20)
            make.leading.equalTo(chartLabel.snp.trailing)
        }
    }
    
    override func configView() {
        setSegmentedControl()
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        let vc = viewController as? PhotoDetailViewController
        delegate = vc
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    private func setSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
          
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
    
    func configData() {
        guard let data = delegate?.sendData() else {
            return
        }
        let photo = data.0
        let statistics = data.1
        let isLiked = data.2
        
        if let urls = photo.urls {
            let rawURL = URL(string: urls.raw)
            photoImageView.kf.setImage(with: rawURL)
        }
        if let profileImage = photo.user?.profileImage {
            let profileImageURL = URL(string: profileImage.medium)
            profileImageView.kf.setImage(with: profileImageURL)
        }
        userName.text = photo.user?.name
        if let date = Utils.getDateFromFormattedString(dateString: photo.createdAt, formatter: "yyyy-MM-ddEEEEEHH-mm-ssZ") {
            createdDate.text = Utils.getFormattedDate(date: date, formatter: "yyyy년 M월 d일 게시됨")
        }
        likeButton.setTitle(photo.id, for: .normal)
        print(#function,"\(photo.width) x \(photo.height)")
        sizeLabel.text = "\(photo.width) x \(photo.height)"
        
        if isLiked {
            likeButton.isSelected.toggle()
            likeButton.setImage(Resource.Asset.NamedImage.like, for: .selected)
        }
        
        if let statistics {
            viewCountLabel.text = statistics.views.total.formatted()
            downloadCountLabel.text = statistics.downloads.total.formatted()
        }
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        likeButton.isSelected.toggle()
        let id = likeButton.isSelected ? nil : sender.title(for: .normal)
        delegate?.likeButtonToggle(id: id)
        if likeButton.isSelected {
            likeButton.setImage(Resource.Asset.NamedImage.like, for: .selected)
        } else {
            likeButton.setImage(Resource.Asset.NamedImage.likeInActive, for: .normal)
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        
        self.showingView = segment.selectedSegmentIndex
//        if showingView == 1 && .isEmpty ||
//           showingView == 2 && flattenAbroad.isEmpty {
//            setRegionList()
//            return
//        }
//        
//        switch showingView {
//        case 0: filterredArr = flattenArr
//        case 1: filterredArr = flattenDomestic
//        case 2: filterredArr = flattenAbroad
//        default: return
//        }
//        tableView.reloadData()
    }
    
    
}
