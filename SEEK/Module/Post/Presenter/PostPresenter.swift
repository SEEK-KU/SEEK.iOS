//
//  PostPresenter.swift
//  SEEK
//
//  Created by oatThanut on 30/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import Moya
import UIKit

class PostPresenter: PostPresenterType
{
    let postsBehaviorRelay = BehaviorRelay<Entity.Post?>(value: nil)
    let requesterBehaviorRelay = BehaviorRelay<Entity.User?>(value: nil)
    
    var postsObservable: Observable<Entity.Post?> {
        return postsBehaviorRelay.asObservable()
    }
    
    var requesterObservable: Observable<Entity.User?> {
        return requesterBehaviorRelay.asObservable()
    }
    
    var postId = ""
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init(
        postId: String)
    {
        self.postId = postId
    }
    
    func loadPostDetail() -> Observable<Void>
    {
        return postInteractor
            .rx
            .viewPost(orderId: postId)
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0?.post)
                    self?.requesterBehaviorRelay.accept($0?.requester) })
            .map { _ in }
            .asObservable()
    }
}
