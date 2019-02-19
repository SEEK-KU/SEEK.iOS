//
//  NewFeedsPresenter.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import Moya
import UIKit

class NewFeedsPresenter: NewFeedsPresenterType
{
    let postsBehaviorRelay = BehaviorRelay<[Entity.Post?]>(value: [])
    
    var postsObservable: Observable<[Entity.Post?]> {
        return postsBehaviorRelay.asObservable()
    }
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    func loadNewFeeds() -> Observable<[Entity.Post?]>
    {
        return postInteractor
            .rx
            .loadNewFeeds()
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0) })
            .asObservable()
    }
    
}
