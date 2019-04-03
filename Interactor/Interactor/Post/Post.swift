//
//  Post.swift
//  Interactor
//
//  Created by oatThanut on 23/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import APIGatewayService
import Entity
import Foundation
import RxSwift

public class Post
{
    let apiGatewayService = APIGatewayService()
    
    public init()
    {
        
    }
}

extension Post: ReactiveCompatible { }

extension Reactive where Base: Post
{
    public func loadNewFeeds() -> Single<[Entity.Post?]>
    {
        return base
            .apiGatewayService
            .rx
            .loadNewFeeds()
            .map { ($0 as! [[String: Any]]) }
            .map { $0.map(Entity.Post.init) }
    }
    
    public func viewPost(orderId: String) -> Single<PostDetail?>
    {
        return base
            .apiGatewayService
            .rx
            .viewPost(orderId: orderId)
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.PostDetail.init(data: $0)  }
    }
    
    public func createNewPost(order: Entity.Post) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .createNewPost(order: order)
            .map { _ in }
    }
}
