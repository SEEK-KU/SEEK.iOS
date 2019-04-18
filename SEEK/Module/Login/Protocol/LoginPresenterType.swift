//
//  LoginPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 15/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import UIKit

protocol LoginPresenterType: PresenterType
{
    var shouldEnterUserInfoObservable: Observable<Bool?> { get }
    
    init()
    
    func isTokenExist() -> Single<Bool>
    
    func login(
        username: String,
        password: String)
    
    func navigateToRootViewController(
        from sourceViewController: UIViewController)
    
    func navigateToSignUp(
        from sourceViewController: UIViewController)
}
