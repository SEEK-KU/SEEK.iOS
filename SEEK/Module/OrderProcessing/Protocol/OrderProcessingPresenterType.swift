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
    var postsObservable: Observable<Entity.Post?> { get }
    var requesterObservable: Observable<Entity.User?> { get }
    
    init(
        postViewModel: Entity.Post?)
    
    func loadPostDetail(postId: String) -> Observable<Void>
    func updatePost()
}
