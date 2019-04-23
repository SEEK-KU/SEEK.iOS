//
//  OrderPendingPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 8/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol OrderPendingPresenterType: PresenterType
{
    var postsObservable: Observable<Entity.Post?> { get }
    var requesterObservable: Observable<Entity.User?> { get }
    var userProfileImagePublishSubject: PublishSubject<UIImage?> { get }
    
    init(
        postViewModel: Entity.Post?)
    
    func updateItemPrice(
        newPrice: String,
        itemIndex: Int)
    
    func loadPostDetail(postId: String) -> Observable<Void>
    func updatePost()
    func cancleOrder()
}
