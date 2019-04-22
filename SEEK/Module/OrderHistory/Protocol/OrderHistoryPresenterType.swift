//
//  OrderHistoryPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 18/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol OrderHistoryPresenterType: PresenterType
{
    var postsObservable: Observable<[Post?]> { get }
    
    init(historyType: String)
    
    func loadOrderHistory() -> Observable<[Entity.Post?]>
    
    func navigateToOrderProcessing(
        title: String,
        orderId: String,
        from sourceViewController: UIViewController)
}
