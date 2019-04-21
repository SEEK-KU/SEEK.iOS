//
//  OrderHistoryPresenter.swift
//  SEEK
//
//  Created by oatThanut on 18/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import UIKit

class OrderHistoryPresenter: OrderHistoryPresenterType
{
    
    
    var postsObservable: Observable<[Entity.Post?]> { return postsBehaviorRelay.asObservable() }
    private let postsBehaviorRelay = BehaviorRelay<[Entity.Post?]>(value: [])
    
    public var historyType = "requester"
    
    // MARK: - Interactor
    
    let interactor = Interactor.Profile()
    
    // MARK: - Router
    
    let orderHistoryRouter = OrderHistoryRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init(
        historyType: String)
    {
        self.historyType = historyType
    }
    
    func loadOrderHistory() -> Observable<[Entity.Post?]>
    {
        return interactor
            .rx
            .loadOrderHistory(
                historyType: self.historyType)
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0) })
            .asObservable()
    }
    
    func navigateToOrderProcessing(
        orderId: String,
        from sourceViewController: UIViewController)
    {
        if historyType == "requester"
        {
            orderHistoryRouter
                .navigateToOrderProcessingAsRequester(
                    orderId: orderId,
                    from: sourceViewController)
        }
        else if historyType == "deliverer"
        {
            orderHistoryRouter
                .navigateToOrderProcessingAsDeliverer(
                    orderId: orderId,
                    from: sourceViewController)
        }
    }
}
