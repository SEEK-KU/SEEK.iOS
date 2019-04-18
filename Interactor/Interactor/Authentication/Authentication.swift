//
//  Authentication.swift
//  Interactor
//
//  Created by oatThanut on 15/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import APIGatewayService
import Entity
import Foundation
import RxSwift
import SwiftKeychainWrapper

public class Authentication
{
    let apiGatewayService = APIGatewayService()
    
    public init()
    {
        
    }
}

extension Authentication: ReactiveCompatible {}

extension Reactive where Base: Authentication
{
    public func login(
        username: String,
        password: String) -> Single<Bool?>
    {
        return base
            .apiGatewayService
            .rx
            .login(
                username: username,
                password: password)
            .map { $0 as? [String: Any] ?? [:] }
            .map { Entity.LoginResponse.init(data: $0) }
            .do(
                onSuccess: { loginResponse in
                    guard let response = loginResponse else
                    {
                        return
                    }
                    
                    self.base.saveToken(response) })
            .map { $0?.havetoSignup }
    }
    
    public func signUp(
        firstName: String,
        lastName: String,
        faculty: String,
        telephone: String) -> Single<Void>
    {
        guard let token = KeychainWrapper.standard.string(forKey: .ssoToken),
            token.isEmpty == false else
        {
            return .just(())
        }
        
        return base
            .apiGatewayService
            .rx
            .signUp(
                token: token,
                firstname: firstName,
                lastname: lastName,
                faculty: faculty,
                telephone: telephone)
            .map { _ in }
    }
}

extension Authentication
{
    fileprivate func saveToken(_ loginResponse: LoginResponse)
    {
        guard let userToken = loginResponse.userToken else
        {
            return
        }
        
        KeychainWrapper.standard.set(userToken, forKey: .ssoToken)
    }
}

extension String
{
    public static var ssoToken: String { return "SSOToken" }
}
