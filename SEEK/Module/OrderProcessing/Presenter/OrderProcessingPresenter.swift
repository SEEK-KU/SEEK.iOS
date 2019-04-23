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
    
    var isAllowEditingPublishSubject = PublishSubject<Bool>()
    var shouldShowButtomViewPublishSubject = PublishSubject<Bool>()
    var userProfileImagePublishSubject = PublishSubject<UIImage?>()
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    var orderId = ""
    var viewType: ViewType
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init(
        viewType: String,
        orderId: String)
    {
        self.orderId = orderId
        self.viewType = ViewType.init(rawValue: viewType) ?? .requester
    }
    
    deinit
    {
        isAllowEditingPublishSubject.onCompleted()
        shouldShowButtomViewPublishSubject.onCompleted()
        userProfileImagePublishSubject.onCompleted()
    }
    
    func loadPostDetail(postId: String?) -> Observable<Void>
    {
        guard let postId = postId else
        {
            return .just(())
        }
        
        return postInteractor
            .rx
            .viewPost(orderId: postId)
            .do(
                onSuccess: { [weak self] in
                    self?.postsBehaviorRelay.accept($0?.orderInfo)
                    self?.requesterBehaviorRelay.accept($0?.requester) })
            .do(
                onSuccess: { [weak self] _ in
                    self?.viewStateConfiguration()
                    self?.loadProfileImage() })
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
    
    func updateItemList(itemList: [Entity.Post.ItemList])
    {
        guard let orderId = postsBehaviorRelay.value?.postId,
            let orderStatus = postsBehaviorRelay.value?.status else
        {
            return
        }
        
        if orderStatus == .confirmPrice
        {
            return postInteractor
                .rx
                .updateOrderItemlist(
                    orderId: orderId,
                    itemList: itemList)
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
    
    func updateItemListCheck(
        newItemCheck: Bool,
        itemIndex: Int)
    {
        let item = self.postsBehaviorRelay.value?.itemList?[itemIndex]
        var itemList = self.postsBehaviorRelay.value?.itemList
        let newItem = Post.ItemList(
            name: item?.name,
            price: item?.price,
            qty: item?.qty,
            check: newItemCheck)
        itemList?[itemIndex] = newItem
        
        guard let post = self.postsBehaviorRelay.value else
        {
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
        self.viewStateConfiguration()
    }
    
    func updateOrderProgess()
    {
        guard let orderId = postsBehaviorRelay.value?.postId,
            let orderStatus = postsBehaviorRelay.value?.status else
        {
            return
        }
        
        if orderStatus == .confirmPrice
            || orderStatus == .accepted
            || orderStatus == .processing
            || orderStatus == .shipping
            || orderStatus == .completed
        {
            return postInteractor
                .rx
                .updateOrderProcess(
                    orderId: orderId,
                    orderStatus: orderStatus)
                .do(
                    onSuccess: { [weak self] in
                        self?.postsBehaviorRelay.accept($0) })
                .subscribe(
                    onSuccess: { [weak self] _ in
                        self?.viewStateConfiguration() })
                .disposed(by: disposeBag)
        }
    }
    
    func pushPaymentViewController(
        totalPrice: Double,
        from sourceViewController: UIViewController)
    {
        guard let orderId = postsBehaviorRelay.value?.postId else
        {
            return
        }
        
        let paymentPresenter = PaymentPresenter(
            totalPrice: totalPrice,
            orderId: orderId)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let paymentViewController = storyBoard
            .instantiateViewController(withIdentifier: "Payment") as! PaymentViewController
        
        paymentViewController.presenter = paymentPresenter
        
        sourceViewController.present(paymentViewController, animated: true)
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
    
    func cancleOrder()
    {
        guard let post = self.postsBehaviorRelay.value,
            let orderId = post.postId else
        {
            return
        }
        
        return postInteractor
            .rx
            .deleteOrder(
                orderId: orderId)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension OrderProcessingPresenter
{
    func viewStateConfiguration()
    {
        guard let orderStatus = postsBehaviorRelay.value?.status else
        {
            return
        }
        
        if orderStatus == .confirmPrice
        {
            
            if viewType == .requester
            {
                // allow editing
                isAllowEditingPublishSubject.onNext(true)
                shouldShowButtomViewPublishSubject.onNext(true)
            }
            else
            {
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
                // viewOnly
            }
        }
        else if orderStatus == .accepted
        {
            if viewType == .requester
            {
                // viewOnly
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
            }
            else
            {
                // show next
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(true)
            }
        }
        else if orderStatus == .processing
        {
            if viewType == .requester
            {
                // viewOnly
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
            }
            else
            {
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(true)
                // show next
            }
        }
        else if orderStatus == .shipping
        {
            if viewType == .requester
            {
                // viewOnly
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(true)
            }
            else
            {
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
                // show next
            }
        }
        else if orderStatus == .completed
        {
            if viewType == .requester
            {
                // show next
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
            }
            else
            {
                // viewOnly
                isAllowEditingPublishSubject.onNext(false)
                shouldShowButtomViewPublishSubject.onNext(false)
            }
        }
        else
        {
            isAllowEditingPublishSubject.onNext(false)
            shouldShowButtomViewPublishSubject.onNext(false)
        }
        
    }
    
    public enum ViewType: String
    {
        case requester = "requester"
        case deliver = "deliverer"
        
        public init?(rawValue: String)
        {
            if rawValue.isEmpty
            {
                return nil
            }
            
            if rawValue == ViewType.requester.rawValue
            {
                self = .requester
            }
            else if rawValue == ViewType.deliver.rawValue
            {
                self = .deliver
            }
            else
            {
                return nil
            }
        }
    }
}
