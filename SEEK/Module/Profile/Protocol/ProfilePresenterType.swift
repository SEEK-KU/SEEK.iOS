//
//  ProfilePresenterType.swift
//  SEEK
//
//  Created by oatThanut on 19/3/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol ProfilePresenterType: PresenterType
{
    var userProfileObservable: Observable<Entity.User?> { get }
    
    func loadUserProfile() -> Observable<Void>
    
    func navigateToLogin(
        from sourceViewController: UIViewController)
    
    func navigateToMyTransactionDetail(
        from sourceViewController: UIViewController)
    
    func navigateToMyRequestHistory(
        from sourceViewController: UIViewController)
    
    func navigateToMyDeliveryHistory(
        from sourceViewController: UIViewController)
}
