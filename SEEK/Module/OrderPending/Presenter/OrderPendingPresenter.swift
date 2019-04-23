//
//  OrderPendingPresenter.swift
//  SEEK
//
//  Created by oatThanut on 8/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import UIKit

class OrderPendingPresenter : OrderPendingPresenterType
{
    
    // MARK: -
    var postsObservable: Observable<Entity.Post?> {
        return postsBehaviorRelay.asObservable() }
    let postsBehaviorRelay = BehaviorRelay<Entity.Post?>(value: nil)
    
    var requesterObservable: Observable<Entity.User?> {
        return requesterBehaviorRelay.asObservable() }
    let requesterBehaviorRelay = BehaviorRelay<Entity.User?>(value: nil)
    var userProfileImagePublishSubject = PublishSubject<UIImage?>()
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init(
        postViewModel: Entity.Post?)
    {
        self.postsBehaviorRelay.accept(postViewModel)
    }
    
    deinit
    {
         userProfileImagePublishSubject.onCompleted()
    }
    
    func updateItemPrice(
        newPrice: String,
        itemIndex: Int)
    {
        let item = self.postsBehaviorRelay.value?.itemList?[itemIndex]
        var itemList = self.postsBehaviorRelay.value?.itemList
        let newItem = Post.ItemList(
            name: item?.name,
            price: Double(newPrice),
            qty: item?.qty)
        itemList?[itemIndex] = newItem
        
        guard let post = self.postsBehaviorRelay.value else {
            return
        }
        
        let newPost = Post(
            postId: post.postId,
            title: post.title,
            requesterId: post.requesterId,
            delivererId: post.delivererId,
            location: post.location,
            storeName: post.storeName,
            shippingPoint: post.shippingPoint,
            itemList: itemList,
            itemQty: post.itemQty,
            tip: post.tip,
            note: post.note,
            status: post.status)
        
        self.postsBehaviorRelay.accept(newPost)
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
            .do(
                onSuccess: { [weak self] _ in
                    self?.loadProfileImage() })
            .map { _ in }
            .asObservable()
    }
    
    func updatePost()
    {
        guard let post = self.postsBehaviorRelay.value,
            let postId = post.postId else
        {
            return
        }
        
        let postDetail = PostDetail(
            orderInfo: post,
            requester: self.requesterBehaviorRelay.value)
        
        return postInteractor
            .rx
            .updatePost(
                orderId: postId,
                orderDetail: postDetail)
            .flatMap { [unowned self] in
                return self.postInteractor
                    .rx
                    .updatePostStatus(
                        orderId: postId,
                        orderStatus: .confirmPrice) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func loadProfileImage()
    {
        guard let url = URL(string: requesterBehaviorRelay.value?.image ?? "") else
        {
            return
        }
        
        if let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            userProfileImagePublishSubject.onNext(image)
        }
    }
}
