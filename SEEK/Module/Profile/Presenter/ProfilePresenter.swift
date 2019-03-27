//
//  ProfilePresenter.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import UIKit

class ProfilePresenter: ProfilePresenterType
{
    var userProfileObservable: Observable<Entity.User?> {
        return userProfileBehaviorRelay.asObservable()
    }
    private let userProfileBehaviorRelay = BehaviorRelay<Entity.User?>(value: nil)
    // MARK: - Interactor
    
    let profileInteractor = Interactor.Profile()
    
    func loadUserProfile() -> Observable<Void>
    {
        return profileInteractor
            .rx
            .loadUserProfile()
            .do(
                onSuccess: { [weak self] in
                    self?.userProfileBehaviorRelay.accept($0)  })
            .map { _ in }
            .asObservable()
    }
}
