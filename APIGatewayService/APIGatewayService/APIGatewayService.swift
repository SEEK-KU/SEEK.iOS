//
//  APIGatewayService.swift
//  APIGatewayService
//
//  Created by oatThanut on 13/2/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
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

extension Reactive where Base: APIGatewayService
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
    
    public func createNewPost(
        token: String,
        order: Post) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .createOrder(
                    token: token,
                    order: order))
            .mapJSON()
    }
    
    public func updatePost(
        orderId: String,
        orderDetail: PostDetail) -> Single<Any>
    {
        
        return base
            .provider
            .rx
            .request(
                .updateOrder(
                    orderId: orderId,
                    orderDetail: orderDetail))
            .mapJSON()
    }
    
    public func takeOrder(
        token: String,
        orderId: String,
        orderStatus: Post.OrderStatusType) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .takeOrder(
                    token: token,
                    orderId: orderId,
                    orderStatus: orderStatus))
            .mapJSON()
    }
    
    public func updateOrderStatus(
        orderId: String,
        orderStatus: Post.OrderStatusType) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .updateOrderStatus(
                    orderId: orderId,
                    orderStatus: orderStatus))
            .mapJSON()
    }
    
    public func uploadSlip(
        orderId: String,
        slipURL: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .uploadSlip(
                    orderId: orderId,
                    slipURL: slipURL))
            .mapJSON()
    }
    
    public func updateOrderProcess(
        orderId: String,
        orderStatus: Post.OrderStatusType) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .updateOrderProcess(
                    orderId: orderId,
                    orderStatus: orderStatus))
            .mapJSON()
    }
    
    public func updateOrderItemlist(
        orderId: String,
        itemList: [Post.ItemList]) -> Single<Any>
    {
        return base.provider.rx.request(
            .updateOrderItemlist(
                orderId: orderId,
                itemList: itemList))
            .mapJSON()
    }
}

extension Reactive where Base: APIGatewayService
{
    public func loadUserProfile(
        userToken: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(.user(userToken: userToken))
            .mapJSON()
    }
    
    public func updateUserImage(
        userToken: String,
        imageURL: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .updateProfilePicture(
                    token: userToken,
                    imageURL: imageURL))
            .mapJSON()
    }
    
    public func loadUserQR(userToken: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .loadUserQR(
                    token: userToken))
            .mapJSON()
    }
    
    public func uploadUserQR(
        userToken: String,
        imageURL: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .uploadUserQR(
                    token: userToken,
                    imageURL: imageURL))
            .mapJSON()
    }
    
    public func loadOrderHistory(
        token: String,
        historyType: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .orderHistory(
                    token: token,
                    historyType: historyType))
            .mapJSON()
    }
}

extension Reactive where Base: APIGatewayService
{
    public func login(
        username: String,
        password: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .login(userId: username,
                       password: password))
            .mapJSON()
    }
    
    public func signUp(
        token: String,
        firstname: String,
        lastname: String,
        faculty: String,
        telephone: String) -> Single<Any>
    {
        return base
            .provider
            .rx
            .request(
                .signUp(
                    token: token,
                    firstname: firstname,
                    lastname: lastname,
                    faculty: faculty,
                    telephone: telephone))
            .mapJSON()
    }
}
