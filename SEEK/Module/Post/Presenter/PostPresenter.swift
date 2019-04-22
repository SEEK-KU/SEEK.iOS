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
    
    // MARK: - Router
    
    let postRouter = PostRouter()
    
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
                    self?.postsBehaviorRelay.accept($0?.orderInfo)
                    self?.requesterBehaviorRelay.accept($0?.requester) })
            .map { _ in }
            .asObservable()
    }
    
    func takeOrder()
    {
        guard let post = postsBehaviorRelay.value,
            let postId = post.postId else
        {
            return
        }
        
        return postInteractor
            .rx
            .takeOrder(
                orderId: postId,
                orderStatus: .updatePrice)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func navigateToOrderPending(from sourceViewController: UIViewController)
    {
        guard let post = postsBehaviorRelay.value else
        {
            return
        }
        
        postRouter
            .navigateToOrderPending(
                from: sourceViewController,
                post: post)
    }
}
