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
import Moya
import RxSwift

public class Post
{
    // MARK: - Provider
    
    let provider = MoyaProvider<APIGatewayService>()
    
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
            .provider
            .rx
            .request(.feeds)
            .mapJSON()
            .map { ($0 as! [[String: Any]]) }
            .map { $0.map(Entity.Post.init) }
    }
    
    public func viewPost(orderId: String) -> Single<PostDetail?>
    {
        return base
            .provider
            .rx
            .request(
                .order(orderId: orderId))
            .mapJSON()
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.PostDetail.init(data: $0)  }
    }
}
