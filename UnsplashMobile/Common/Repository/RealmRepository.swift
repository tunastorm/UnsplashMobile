//
//  repository.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation
import RealmSwift

// complitionHandler를 이용해 완료 후의 작업 처리와 에러처리 동시 구현 가능할 것
final class Repository {
    
    typealias RepositoryResult = (Result<RepositoryStatus, RepositoryError>) -> Void
    typealias propertyhandler = () -> Void
    
    enum Sorting: CaseIterable {
        case latest
        case oldest
        
        var value: Bool {
            return switch self {
            case .latest: false
            case .oldest: true
            }
        }
        
        var krName: String {
            return switch self {
            case .latest: "최신순"
            case .oldest: "과거순"
            }
        }
    }
    
    private let realm = try! Realm()
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }

    func createItem(_ data: Object, complitionHandler: RepositoryResult) {
        do {
            try realm.write {
                realm.add(data)
            }
            complitionHandler(.success(RepositoryStatus.createSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.createFailed))
        }
    }
    
    func fetchItem<T:Object>(object: T.Type, primaryKey: ObjectId) -> T? {
        return realm.object(ofType: object, forPrimaryKey: primaryKey)
    }
    
    func fetchAll<T: Object>(obejct: T.Type, sortKey column: any ColumnManager, acending: Bool = true, query: ((Query<T>) -> Query<Bool>)? = nil) -> [T] {
        let value = realm.objects(obejct).sorted(byKeyPath: column.name, ascending: acending)
        return Array(value)
    }

    func searchCompoundedFilter<T:Object>(objet: T.Type, sortKey column: any ColumnManager, acending: Bool = true, compoundPredicate: NSCompoundPredicate, filter: (Query<T>) -> Query<Bool>) -> [T] {
        let value = realm.objects(objet).where(filter).filter(compoundPredicate).sorted(byKeyPath: column.name, ascending: acending)
        print(#function, value)
        return Array(value)
    }
    
    func updateItem<T:Object>(object: T.Type, value: [String: Any], complitionHandler: RepositoryResult) {
        print(#function, value)
        do {
            try realm.write {
                realm.create(object, value: value, update: .modified)
            }
            complitionHandler(.success(RepositoryStatus.updateSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.updatedFailed))
        }
    }
    
    func deleteUser(_ user: User, complitionHandler: RepositoryResult) {
        
        var resultDict: [String: Int] = ["success": 0, "failure": 0]
        user.likedList.forEach { likedPhoto in
            deleteLikedPhoto(likedPhoto) { result in
                switch result {
                case .success(let status): 
                    if let count = resultDict["success"] {
                        resultDict["success"] = count + 1
                    }
                case .failure(let error):
                    if let count = resultDict["failure"] {
                        resultDict["failure"] = count + 1
                    }
                }
            }
        }
        guard resultDict["failure"] == 0 else {
            return
        }
        do {
            try realm.write {
                realm.delete(user)
            }
            complitionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.deleteFailed))
        }
    }
    
    func addLikedPhoto(list: List<LikedPhoto> , item: LikedPhoto, complitionHandler: RepositoryResult) {
        do {
            try realm.write {
                list.append(item)
            }
            if let urls = item.urls {
                Utils.photoManager.downloadImageToDocument(url: urls.raw, filename: item.realmId.stringValue + "_raw")
                if let small = urls.small {
                    Utils.photoManager.downloadImageToDocument(url: small, filename: item.realmId.stringValue + "_small")
                }
            }
            if let artist = item.user, let profileImage = artist.profileImage {
                Utils.photoManager.downloadImageToDocument(url: profileImage.medium, filename: artist.realmId.stringValue)
            }
            complitionHandler(.success(RepositoryStatus.updateSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.updatedFailed))
        }
    }
    
    func queryLikedPhotoList(_ user: User, sort: Repository.Sorting = .latest, colors: [Int]?, complitionHandler: (Result<Results<LikedPhoto>?, RepositoryError>) -> Void) {
        
        do {
            try realm.write {
                var result: Results<LikedPhoto>?
                if let colors {
                    result = user.likedList.where{ $0.colorFilter.in(colors) }.sorted(byKeyPath: LikedPhoto.Column.regDate.name, ascending: sort.value)
                } else {
                    result = user.likedList.sorted(byKeyPath: LikedPhoto.Column.createdAt.name, ascending: sort.value)
                }
                complitionHandler(.success(result))
            }
        } catch {
            complitionHandler(.failure(RepositoryError.noResult))
        }
    }
    
    func deleteLikedPhoto(_ item: LikedPhoto, complitionHandler: RepositoryResult) {
        guard let urls = item.urls, let artist = item.user, let profileImage = item.user?.profileImage else {
            return
        }
        Utils.photoManager.removeImageFromDocument(filename: item.realmId.stringValue + "_raw")
        Utils.photoManager.removeImageFromDocument(filename: item.realmId.stringValue + "_small")
        Utils.photoManager.removeImageFromDocument(filename: artist.realmId.stringValue)
        do {
            try realm.write {
                realm.delete(profileImage)
                realm.delete(artist)
                realm.delete(urls)
                realm.delete(item)
            }
            complitionHandler(.success(RepositoryStatus.deleteSuccess))
        } catch {
            complitionHandler(.failure(RepositoryError.deleteFailed))
        }
    }

}


