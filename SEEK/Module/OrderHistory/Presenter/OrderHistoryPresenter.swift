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
    
    // MARK: - Interactor
    
    let interactor = Interactor.Profile()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init()
    {
        
    }
    
    func loadOrderHistory(
        historyType: String) -> Observable<[Entity.Post?]>
    {
        return interactor
            .rx
            .loadOrderHistory(
                historyType: historyType)
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0) })
            .asObservable()
    }
    
    
}
