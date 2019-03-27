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
        return base
            .apiGatewayService
            .rx
            .loadUserProfile()
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.User.init(data: $0) }
    }
}
