//
//  PostPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 30/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol PostPresenterType: PresenterType
{
    var postsObservable: Observable<Post?> { get }
    var requesterObservable: Observable<User?> { get }
    
    func loadPostDetail() -> Observable<Void>
    func updateOrderStatus()
    
    func navigateToOrderPending(from sourceViewController: UIViewController)
}
