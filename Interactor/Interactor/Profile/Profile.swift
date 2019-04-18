//
//  Profile.swift
//  Interactor
//
//  Created by oatThanut on 19/3/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import APIGatewayService
import Entity
import Foundation
import RxSwift
import SwiftKeychainWrapper

public class Profile
{
    let apiGatewayService = APIGatewayService()
    
    public init()
    {
        
    }
}

extension Profile: ReactiveCompatible { }

extension Reactive where Base: Profile
{
    public func loadUserProfile() -> Single<Entity.User?>
    {
        guard let userToken = KeychainWrapper.standard.string(forKey: .ssoToken) else
        {
            return .just(nil)
        }
        
        return base
            .apiGatewayService
            .rx
            .loadUserProfile(userToken: userToken)
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.User.init(data: $0) }
    }
    
    public func loadOrderHistory(historyType: String) -> Single<[Entity.Post?]>
    {
        guard let userToken = KeychainWrapper.standard.string(forKey: .ssoToken) else
        {
            return .just([])
        }
        
        return base
            .apiGatewayService
            .rx
            .loadOrderHistory(
                token: userToken,
                historyType: historyType)
            .map { ($0 as! [[String: Any]]) }
            .map { $0.map(Entity.Post.init) }
    }
}
