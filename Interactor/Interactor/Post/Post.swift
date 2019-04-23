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
import SwiftKeychainWrapper

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
        guard let userToken = KeychainWrapper.standard.string(forKey: .ssoToken) else
        {
            return .just(())
        }
        
        return base
            .apiGatewayService
            .rx
            .createNewPost(
                token: userToken,
                order: order)
            .map { _ in }
    }
    
    public func updatePost(
        orderId: String,
        orderDetail: Entity.PostDetail) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .updatePost(
                orderId: orderId,
                orderDetail: orderDetail)
            .map { _ in }
    }
    
    public func takeOrder(
        orderId: String,
        orderStatus: Entity.Post.OrderStatusType) -> Single<Void>
    {
        guard let userToken = KeychainWrapper.standard.string(forKey: .ssoToken) else
        {
            return .just(())
        }
        
        return base
            .apiGatewayService
            .rx
            .takeOrder(
                token: userToken,
                orderId: orderId,
                orderStatus: orderStatus)
            .map { _ in }
    }
    
    public func updatePostStatus(
        orderId: String,
        orderStatus: Entity.Post.OrderStatusType) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .updateOrderStatus(
                orderId: orderId,
                orderStatus: orderStatus)
            .map { _ in }
    }
    
    public func uploadSlip(
        orderId: String,
        slipURL: String) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .uploadSlip(
                orderId: orderId,
                slipURL: slipURL)
            .map { _ in }
    }
    
    public func updateOrderProcess(
        orderId: String,
        orderStatus: Entity.Post.OrderStatusType) -> Single<Entity.Post?>
    {
        return base
            .apiGatewayService
            .rx
            .updateOrderProcess(
                orderId: orderId,
                orderStatus: orderStatus)
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.Post.init(data: $0) }
    }
    
    public func updateOrderItemlist(
        orderId: String,
        itemList: [Entity.Post.ItemList]) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .updateOrderItemlist(
                orderId: orderId,
                itemList: itemList)
            .map { _ in }
    }
    
    public func deleteOrder(orderId: String) -> Single<Void>
    {
        return base
            .apiGatewayService
            .rx
            .deleteOrder(
                orderId: orderId)
            .map { _ in }
    }
}
