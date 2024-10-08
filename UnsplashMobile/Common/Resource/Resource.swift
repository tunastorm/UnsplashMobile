//
//  Resource.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

enum Resource {
    
    enum UIConstants {
        
        enum Alpha {
            static let full = CGFloat(1.0)
            static let half = CGFloat(0.5)
        }
        
        enum Border {
            static let widthZero = CGFloat(0)
            static let width1 = CGFloat(1)
            static let width3 = CGFloat(3)
        }
        
        enum CornerRadious {
            static let startButton = CGFloat(20)
            static let profileImageView = CGFloat(60)
            static let cameraIcon = CGFloat(15)
            static let searchImage = CGFloat(16)
            static let likeButton = CGFloat(10)
            static let sortingButton = CGFloat(17)
            static let settingProfileImage = CGFloat(40)
            static let mbtiButton = CGFloat(26)
        }
        
        enum Text {
            static let appTitle = "Unsplash\nMobile"
            static let applicantName = "유철원"
            static let startButton = "시작하기"
            static let compeleteButton = "완료"
            static let searchTabBar = "검색"
            static let settingTabBar = "설정"
            
            static let profileSetting = "PROFILE SETTING"
            static let nickNamePlaceholder = "닉네임을 입력해주세요 :)"
            static let specialFilter = "@#$%"
            static let mbtiLabel = "MBTI"

            static let topicPhotosTitle = "OUR TOPIC"
            
            static let searchPhotosTitle = "SEARCH PHOTO"
            static let searchPhotosIdleMessage = "사진을 검색해보세요"
            static let noSearchResultMessage = "검색결과가 없습니다."
            
            static let photoDetailInfoLabel = "정보"
            static let photoDetailSizeInfoLabel = "크기"
            static let photoDetailViewInfoLabel = "조회수"
            static let photoDetailViewDownloadInfoLabel = "다운로드"
            static let photoDetailChartLabel = "차트"
            static let photoDetailViewChartLabel = "조회"
            static let photoDetailDownloadChartLabel = "다운로드"
            
            static let likedPhotosTitle = "MY POLAROID"
            static let likedPhotosIdleMessage = "마음에 드는 사진에 좋아요를 눌러보세요"
            static let noLikedPhotosMessage = "저장된 사진이 없어요"
            
            static let settingViewTitle = "SETTING"
            static let saveNewProfile = "저장"
            static let secessionLabel = "회원탈퇴"
            static let secessionAlertTitle = "탈퇴하기"
            static let secessionAlertMessage = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?"
            
            static let editProfileTitle = "EDIT PROFILE"
        }
    }
    
    enum Asset {

        enum SystemImage {
            static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
            static let heart = UIImage(systemName: "heart")
            static let cameraFill = UIImage(systemName: "camera.fill")
            static let chevronRight = UIImage(systemName: "chevron.right")
            static let starFill = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysTemplate)
//            static let clock = UIImage(systemName: "clock")
//            static let xmark = UIImage(systemName: "xmark")
//            static let person = UIImage(systemName: "person")
            static let networkSlash = UIImage(systemName: "network.slash")
            static let wifiExclamationmark = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(Resource.Asset.CIColor.white, renderingMode: .alwaysOriginal)
        }
        
        enum NamedImage {
            static let empty = UIImage(named: "empty")
            static let launch = UIImage(named: "launchImage")
            static let loadingApple = UIImage (named: "loading_apple")
            static let tabTrend = UIImage(named: "tab_trend")
            static let tabTrendInActive = UIImage(named: "tap_trend_inactive")
            static let tabRandom = UIImage(named: "tab_random")
            static let tabRandomInActive = UIImage(named: "tab_random_inactive")
            static let tabSearch = UIImage(named: "tab_search")
            static let tabSearchInActive = UIImage(named: "tab_search_inactive")
            static let tabLike = UIImage(named: "tab_like")
            static let tabLikeInActive = UIImage(named: "tab_like_inactive")
            static let like = UIImage(named: "like")?.withRenderingMode(.alwaysOriginal)
            static let likeInActive = UIImage(named: "like_inactive")?.withRenderingMode(.alwaysTemplate)
            static let sort = UIImage(named: "sort")!.withRenderingMode(.alwaysOriginal)
            
            static func profileImage(number: Int) -> UIImage? {
                guard number >= 0 && number <= 11 else {
                    return nil
                }
                return UIImage(named: "profile_\(number)")
            }
            
            static var randomProfile: UIImage {
                return UIImage(named: "profile_\(Int.random(in: 0...11))")!
            }
            
            static var allProfile: [UIImage] {
                var list: [UIImage] = []
                for i in 0...11 {
                    list.append(UIImage(named: "profile_\(i)")!)
                }
                return list
            }
        }
        
        enum Font {
            static let system13 = UIFont.systemFont(ofSize: 13)
            static let system14 = UIFont.systemFont(ofSize: 14)
            static let system15 = UIFont.systemFont(ofSize: 15)
            static let system16 = UIFont.systemFont(ofSize: 16)
            static let system17 = UIFont.systemFont(ofSize: 17)
            static let system18 = UIFont.systemFont(ofSize: 18)
            static let system19 = UIFont.systemFont(ofSize: 19)
            static let system20 = UIFont.systemFont(ofSize: 20)
            static let boldSystem13 = UIFont.boldSystemFont(ofSize: 13)
            static let boldSystem14 = UIFont.boldSystemFont(ofSize: 14)
            static let boldSystem15 = UIFont.boldSystemFont(ofSize: 15)
            static let boldSystem16 = UIFont.boldSystemFont(ofSize: 16)
            static let boldSystem17 = UIFont.boldSystemFont(ofSize: 17)
            static let boldSystem18 = UIFont.boldSystemFont(ofSize: 18)
            static let boldSystem19 = UIFont.boldSystemFont(ofSize: 19)
            static let boldSystem20 = UIFont.boldSystemFont(ofSize: 20)
            static let boldSystem30 = UIFont.boldSystemFont(ofSize: 30)
        }
        
        enum CIColor {
            static let blue = UIColor(hexCode: "186FF2", alpha: Resource.UIConstants.Alpha.full)
            static let white = UIColor(hexCode: "FFFFFF", alpha: Resource.UIConstants.Alpha.full)
            static let lightGray = UIColor(hexCode: "F2F2F2", alpha: Resource.UIConstants.Alpha.full)
            static let gray = UIColor(hexCode: "8C8C8C", alpha: Resource.UIConstants.Alpha.full)
            static let darkGray = UIColor(hexCode: "4D5652", alpha: Resource.UIConstants.Alpha.full)
            static let black = UIColor(hexCode: "000000", alpha: Resource.UIConstants.Alpha.full)
            static let red = UIColor(hexCode: "F04452", alpha: Resource.UIConstants.Alpha.full)
        }
    }
}
