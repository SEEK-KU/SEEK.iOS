//
//  OrderProcessingPresenter.swift
//  SEEK
//
//  Created by oatThanut on 14/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxSwift
import RxCocoa
import UIKit

class OrderProcessingPresenter: OrderProcessingPresenterType
{
    
    // MARK: -
    var postsObservable: Observable<Entity.Post?> {
        return postsBehaviorRelay.asObservable() }
    let postsBehaviorRelay = BehaviorRelay<Entity.Post?>(value: nil)
    
    var requesterObservable: Observable<Entity.User?> {
        return requesterBehaviorRelay.asObservable() }
    let requesterBehaviorRelay = BehaviorRelay<Entity.User?>(value: nil)
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init(
        postViewModel: Entity.Post?)
    {
        self.postsBehaviorRelay.accept(postViewModel)
    }
    
    func loadPostDetail(postId: String) -> Observable<Void>
    {
        return postInteractor
            .rx
            .viewPost(orderId: postId)
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0?.orderInfo)
                    self?.requesterBehaviorRelay.accept($0?.requester) })
            .map { _ in }
            .asObservable()
    }
    
    func updatePost()
    {
        guard let post = self.postsBehaviorRelay.value else
        {
            return
        }
        
        let postDetail = PostDetail(
            orderInfo: post,
            requester: self.requesterBehaviorRelay.value)
        
        return postInteractor
            .rx
            .updatePost(
                orderId: post.postId ?? "",
                orderDetail: postDetail)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
