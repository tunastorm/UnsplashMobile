//
//  SplashViewModel.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


final class SplashViewModel: BaseViewModel {
    
    var inputGetUser: Observable<Void?> = Observable(nil)
    var outputUser: Observable<User?> = Observable(nil)
    
    override func transform() {
        inputGetUser.bind { [weak self] _ in
            self?.getUser()
        }
    }

    private func getUser() {
        outputUser.value = repository.fetchUser(sortKey: User.Column.signUpDate).first
    }
}
