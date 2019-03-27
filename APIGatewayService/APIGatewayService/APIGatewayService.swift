//
//  APIGatewayService.swift
//  APIGatewayService
//
//  Created by oatThanut on 13/2/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public class APIGatewayService
{
    fileprivate let provider: MoyaProvider<Target>
    
    public init()
    {
        self.provider = MoyaProvider<Target>(plugins: [NetworkLoggerPlugin(verbose: true)])
    }
}


extension APIGatewayService: ReactiveCompatible { }

public extension Reactive where Base: APIGatewayService
{
    public func loadNewFeeds() -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(.feeds)
            .mapJSON()
    }
    
    public func viewPost(orderId: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .order(orderId: orderId))
            .mapJSON()
    }
}

public extension Reactive where Base: APIGatewayService
{
    public func loadUserProfile() -> Single<Any>
    {
        let userId = "5810545947"
        
        return base
            .provider
            .rx
            .request(.user(userId: userId))
            .mapJSON()
    }
}
