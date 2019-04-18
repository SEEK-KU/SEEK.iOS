//
//  LoginPresenter.swift
//  SEEK
//
//  Created by oatThanut on 15/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Interactor
import RxSwift
import SwiftKeychainWrapper
import UIKit

class LoginPresenter: LoginPresenterType
{
    let shouldEnterUserInfoPublishSubject = PublishSubject<Bool?>()
    
    var shouldEnterUserInfoObservable: Observable<Bool?> { return shouldEnterUserInfoPublishSubject.asObservable() }
    
    // MARK: - Interactor
    
    let loginInteractor = Interactor.Authentication()
    
    // MARK: - Router
    
    let loginRouter = LoginRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init()
    {
        
    }
    
    deinit
    {
        shouldEnterUserInfoPublishSubject.onCompleted()
    }
    
    func isTokenExist() -> Single<Bool>
    {
        guard let token = KeychainWrapper.standard.string(forKey: .ssoToken),
            token.isEmpty == false else
        {
            return .just(false)
        }
        
        return .just(true)
    }
    
    func login(
        username: String,
        password: String)
    {
        
        return loginInteractor
            .rx
            .login(
                username: username,
                password: password)
            .subscribe(
                onSuccess: { [weak self] in
                    self?.shouldEnterUserInfoPublishSubject.onNext($0) })
            .disposed(by: disposeBag)
    }
    
    func navigateToRootViewController(
        from sourceViewController: UIViewController)
    {
        loginRouter
            .navigateToRootViewController(
                from: sourceViewController)
    }
    
    func navigateToSignUp(
        from sourceViewController: UIViewController)
    {
        loginRouter
            .navigateToSignUp(
                from: sourceViewController)
    }
}
