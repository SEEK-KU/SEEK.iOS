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
    
    // MARK: - Router
    
    let profileRouter = ProfileRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
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
    
    func updateUserImage(imageURL: String)
    {
        return profileInteractor
            .rx
            .updateUserImage(
                imageURL: imageURL)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func navigateToLogin(
        from sourceViewController: UIViewController)
    {
        profileRouter
            .navigateToLogin(from: sourceViewController)
    }
    
    func navigateToMyTransactionDetail(
        from sourceViewController: UIViewController)
    {
        guard let id = userProfileBehaviorRelay.value?.userId else
        {
            return
        }
        
        profileRouter
            .navigateToMyTransactionDetail(
                studentId: id,
                from: sourceViewController)
    }
    
    func navigateToMyRequestHistory(
        from sourceViewController: UIViewController)
    {
        profileRouter
            .navigateToMyRequestHistory(from: sourceViewController)
    }
    
    func navigateToMyDeliveryHistory(
        from sourceViewController: UIViewController)
    {
        profileRouter
            .navigateToMyDeliveryHistory(from: sourceViewController)
    }
}
