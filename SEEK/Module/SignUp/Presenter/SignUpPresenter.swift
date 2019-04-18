
//
//  SignUpPresenter.swift
//  SEEK
//
//  Created by oatThanut on 16/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Interactor
import RxSwift
import UIKit

class SignUpPresenter
{
    
    // MARK: - Interactor
    
    let signUpInteractor = Interactor.Authentication()
    
    // MARK: - Router
    
    let signUpRouter = SignUpRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    
    func signUp(
        firstName: String,
        lastName: String,
        faculty: String,
        telephone: String )
    {
        signUpInteractor
            .rx
            .signUp(
                firstName: firstName,
                lastName: lastName,
                faculty: faculty,
                telephone: telephone)
            .subscribe()
        .disposed(by: disposeBag)
    }
    
    func navigateToRootViewController(
        from sourceViewController: UIViewController)
    {
        signUpRouter
            .navigateToRootViewController(
                from: sourceViewController)
    }
}
