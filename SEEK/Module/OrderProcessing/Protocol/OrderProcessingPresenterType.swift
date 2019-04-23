//
//  OrderProcessingPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 14/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity

import RxSwift
import UIKit

protocol OrderProcessingPresenterType: PresenterType
{
    var orderId: String { get }
    
    var postsObservable: Observable<Entity.Post?> { get }
    var requesterObservable: Observable<Entity.User?> { get }
    
    var isAllowEditingPublishSubject: PublishSubject<Bool> { get }
    var shouldShowButtomViewPublishSubject: PublishSubject<Bool> { get }
    var userProfileImagePublishSubject: PublishSubject<UIImage?> { get }
    
    init(
        viewType: String,
        orderId: String)
    
    func loadPostDetail(postId: String?) -> Observable<Void>
    func updatePost()
    func updateItemList(itemList: [Entity.Post.ItemList])
    func updateItemListCheck(
        newItemCheck: Bool,
        itemIndex: Int)
    func updateOrderProgess()
    func cancleOrder()
    func pushPaymentViewController(
        totalPrice: Double,
        from sourceViewController: UIViewController)
}
